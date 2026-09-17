#!/usr/bin/env bash
# Local auth-manager: compile, run all tests, package Boot ZIP, then start.
# Cluster GC/heap flags are JDK_JAVA_OPTIONS (Helm). Omit them locally.
#
# Usage:
#   ./run-local.sh
#   ./run-local.sh docker
#   SPRING_PROFILES_ACTIVE=local SPRING_CLOUD_CONFIG_URI=http://localhost:51000 ./run-local.sh
set -euo pipefail

MODULE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KERNEL_DIR="$(cd "${MODULE_DIR}/.." && pwd)"
MODE="${1:-java}"
PORT="${PORT:-8091}"
IMAGE="${IMAGE:-kernel-auth-service}"
PROFILE="${SPRING_PROFILES_ACTIVE:-local}"
CONFIG_URI="${SPRING_CLOUD_CONFIG_URI:-}"
CONFIG_LABEL="${SPRING_CLOUD_CONFIG_LABEL:-}"
CONTEXT="/v1/authmanager"
BASE="http://localhost:${PORT}${CONTEXT}"

usage() {
	echo "Usage: $0 [java|docker]"
	echo "Compiles, runs all Maven tests, packages, then starts."
	echo "Env: SPRING_PROFILES_ACTIVE SPRING_CLOUD_CONFIG_URI SPRING_CLOUD_CONFIG_LABEL JDK_JAVA_OPTIONS PORT IMAGE"
	exit 1
}

build() {
	command -v java >/dev/null 2>&1 || { echo "java not on PATH (need JDK 21)" >&2; exit 1; }
	command -v mvn >/dev/null 2>&1 || { echo "mvn not on PATH (need Maven 3.9+)" >&2; exit 1; }
	echo "==> compile + test + package kernel-auth-service"
	# Surefire inherits the env. local profile would take the deprecated offline path in adapter tests.
	(
		cd "${KERNEL_DIR}"
		env -u SPRING_PROFILES_ACTIVE mvn -pl kernel-auth-service -am clean package "-Dgpg.skip=true" "-Dmaven.javadoc.skip=true"
	)
}

find_jar() {
	local jar
	jar="$(ls -1 "${MODULE_DIR}/target"/kernel-auth-service-*.jar 2>/dev/null | grep -vE 'sources|javadoc|original' | head -n 1 || true)"
	if [[ -z "${jar}" || ! -f "${jar}" ]]; then
		echo "No Boot ZIP after Maven. From kernel/: mvn -pl kernel-auth-service -am package \"-Dgpg.skip=true\"" >&2
		exit 1
	fi
	if [[ "$(wc -c < "${jar}")" -lt 1048576 ]]; then
		echo "${jar} is not the Boot ZIP (no Main-Class)" >&2
		exit 1
	fi
	echo "${jar}"
}

print_endpoints() {
	echo
	echo "authmanager  profile=${PROFILE}  port=${PORT}  context=${CONTEXT}"
	echo "  health     ${BASE}/actuator/health"
	echo "  swagger    ${BASE}/swagger-ui/index.html"
	echo "  openapi    ${BASE}/v3/api-docs"
	echo "  info       ${BASE}/actuator/info"
	echo "  mappings   ${BASE}/actuator/mappings"
	echo "  prometheus ${BASE}/actuator/prometheus"
	echo "  token      POST ${BASE}/authenticate/clientidsecretkey"
	echo "  validate   GET  ${BASE}/authorize/admin/validateToken"
	echo "  refresh    POST ${BASE}/authorize/refreshToken/{appid}"
	echo "  invalidate POST ${BASE}/authorize/invalidateToken"
	echo
}

java_args() {
	local args=("-Dspring.profiles.active=${PROFILE}")
	if [[ -n "${CONFIG_URI}" ]]; then
		args+=("-Dspring.cloud.config.uri=${CONFIG_URI}")
	fi
	if [[ -n "${CONFIG_LABEL}" ]]; then
		args+=("-Dspring.cloud.config.label=${CONFIG_LABEL}")
	fi
	echo "${args[@]}"
}

run_java() {
	build
	local jar
	jar="$(find_jar)"
	echo "OS=$(uname -s) jar=${jar} profile=${PROFILE}"
	print_endpoints
	# JDK_JAVA_OPTIONS is read by the JVM; leave unset for local defaults.
	# shellcheck disable=SC2046,SC2086
	exec java $(java_args) -jar "${jar}"
}

docker_host_args() {
	case "$(uname -s)" in
	Linux*) echo --add-host=host.docker.internal:host-gateway ;;
	esac
}

run_docker() {
	build
	command -v docker >/dev/null 2>&1 || { echo "docker not on PATH" >&2; exit 1; }
	docker rm -f kernel-auth-service >/dev/null 2>&1 || true
	echo "==> docker build ${IMAGE}"
	docker build -t "${IMAGE}" "${MODULE_DIR}"
	print_endpoints
	# shellcheck disable=SC2046
	exec docker run --rm -p "${PORT}:8091" --name kernel-auth-service \
		$(docker_host_args) \
		-e "active_profile_env=${PROFILE}" \
		-e "spring_config_url_env=${CONFIG_URI}" \
		-e "spring_config_label_env=${CONFIG_LABEL}" \
		-e "JDK_JAVA_OPTIONS=${JDK_JAVA_OPTIONS:-}" \
		"${IMAGE}"
}

case "${MODE}" in
-h | --help) usage ;;
java) run_java ;;
docker) run_docker ;;
*) usage ;;
esac
