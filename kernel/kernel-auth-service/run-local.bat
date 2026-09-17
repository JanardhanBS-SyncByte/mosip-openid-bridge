@echo off
REM Local auth-manager: compile, run all tests, package Boot ZIP, then start.
REM Cluster GC/heap flags are JDK_JAVA_OPTIONS (Helm). Omit them locally.
REM
REM Usage:
REM   run-local.bat
REM   run-local.bat docker
REM   set SPRING_CLOUD_CONFIG_URI=http://localhost:51000 && run-local.bat
setlocal EnableDelayedExpansion
cd /d "%~dp0"
set "MODULE_DIR=%cd%"
for %%I in ("%MODULE_DIR%\..") do set "KERNEL_DIR=%%~fI"

set "MODE=%~1"
if "%MODE%"=="" set "MODE=java"
if /i "%MODE%"=="-h" goto usage
if "%MODE%"=="/?" goto usage
if /i "%MODE%"=="help" goto usage

if not defined SPRING_PROFILES_ACTIVE set "SPRING_PROFILES_ACTIVE=local"
set "RUN_PROFILE=%SPRING_PROFILES_ACTIVE%"
if not defined PORT set "PORT=8091"
if not defined IMAGE set "IMAGE=kernel-auth-service"
set "CONTEXT=/v1/authmanager"
set "BASE=http://localhost:%PORT%%CONTEXT%"

if /i "%MODE%"=="java" goto java
if /i "%MODE%"=="docker" goto docker
goto usage

:build
where java >nul 2>&1
if errorlevel 1 (
	echo java not on PATH ^(need JDK 21^)
	exit /b 1
)
where mvn >nul 2>&1
if errorlevel 1 (
	echo mvn not on PATH ^(need Maven 3.9+^)
	exit /b 1
)
echo ==^> compile + test + package kernel-auth-service
REM Surefire inherits the env. local profile would take the deprecated offline path in adapter tests.
set "SPRING_PROFILES_ACTIVE="
pushd "%KERNEL_DIR%"
call mvn -pl kernel-auth-service -am clean package "-Dgpg.skip=true" "-Dmaven.javadoc.skip=true"
set "RC=%ERRORLEVEL%"
popd
set "SPRING_PROFILES_ACTIVE=%RUN_PROFILE%"
if not "%RC%"=="0" exit /b %RC%
exit /b 0

:print_endpoints
echo.
echo authmanager  profile=%RUN_PROFILE%  port=%PORT%  context=%CONTEXT%
echo   health     %BASE%/actuator/health
echo   swagger    %BASE%/swagger-ui/index.html
echo   openapi    %BASE%/v3/api-docs
echo   info       %BASE%/actuator/info
echo   mappings   %BASE%/actuator/mappings
echo   prometheus %BASE%/actuator/prometheus
echo   token      POST %BASE%/authenticate/clientidsecretkey
echo   validate   GET  %BASE%/authorize/admin/validateToken
echo   refresh    POST %BASE%/authorize/refreshToken/{appid}
echo   invalidate POST %BASE%/authorize/invalidateToken
echo.
exit /b 0

:find_jar
set "JAR="
for %%F in ("%MODULE_DIR%\target\kernel-auth-service-*.jar") do (
	echo %%~nxF | findstr /i /c:"sources" /c:"javadoc" /c:".original" >nul
	if errorlevel 1 set "JAR=%%~fF"
)
if not defined JAR (
	echo No Boot ZIP after Maven. From kernel/: mvn -pl kernel-auth-service -am package "-Dgpg.skip=true"
	exit /b 1
)
for %%S in ("!JAR!") do if %%~zS LSS 1048576 (
	echo !JAR! is not the Boot ZIP ^(no Main-Class^)
	exit /b 1
)
exit /b 0

:java
call :build
if errorlevel 1 exit /b 1
call :find_jar
if errorlevel 1 exit /b 1
echo OS=Windows jar=!JAR! profile=%RUN_PROFILE%
call :print_endpoints
set "PROPS=-Dspring.profiles.active=%RUN_PROFILE%"
if defined SPRING_CLOUD_CONFIG_URI set "PROPS=!PROPS! -Dspring.cloud.config.uri=%SPRING_CLOUD_CONFIG_URI%"
if defined SPRING_CLOUD_CONFIG_LABEL set "PROPS=!PROPS! -Dspring.cloud.config.label=%SPRING_CLOUD_CONFIG_LABEL%"
java !PROPS! -jar "!JAR!"
exit /b %ERRORLEVEL%

:docker
call :build
if errorlevel 1 exit /b 1
where docker >nul 2>&1
if errorlevel 1 (
	echo docker not on PATH
	exit /b 1
)
docker rm -f kernel-auth-service >nul 2>&1
echo ==^> docker build %IMAGE%
docker build -t %IMAGE% "%MODULE_DIR%"
if errorlevel 1 exit /b 1
call :print_endpoints
docker run --rm -p %PORT%:8091 --name kernel-auth-service -e active_profile_env=%RUN_PROFILE% -e spring_config_url_env=%SPRING_CLOUD_CONFIG_URI% -e spring_config_label_env=%SPRING_CLOUD_CONFIG_LABEL% -e JDK_JAVA_OPTIONS=%JDK_JAVA_OPTIONS% %IMAGE%
exit /b %ERRORLEVEL%

:usage
echo Usage: run-local.bat [java^|docker]
echo Compiles, runs all Maven tests, packages, then starts.
echo Env: SPRING_PROFILES_ACTIVE SPRING_CLOUD_CONFIG_URI SPRING_CLOUD_CONFIG_LABEL JDK_JAVA_OPTIONS PORT IMAGE
exit /b 1
