# MOSIP OpenID Bridge

[![Maven Package upon a push](https://github.com/mosip/mosip-openid-bridge/actions/workflows/push-trigger.yml/badge.svg?branch=develop)](https://github.com/mosip/mosip-openid-bridge/actions/workflows/push-trigger.yml)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=mosip_mosip-openid-bridge&metric=alert_status)](https://sonarcloud.io/dashboard?branch=develop&id=mosip_mosip-openid-bridge)

## Overview

**MOSIP OpenID Bridge** is the authentication stack for MOSIP: an HTTP auth manager, a Spring Security adapter, and OpenID Connect libraries.

It bridges MOSIP services with Keycloak (or a compatible IdP) for token issue, validation, and authorization-code login.

---
# Services

The following modules are part of MOSIP OpenID Bridge:

---

1. **[Kernel Auth Service](kernel/kernel-auth-service)** - Auth manager HTTP · `:8091` · `/v1/authmanager`.
2. **[Kernel Auth Adapter](kernel/kernel-auth-adapter)** - Spring Security adapter (Maven dependency for MOSIP HTTP services).
3. **[Kernel OpenID Bridge API](kernel/kernel-openid-bridge-api)** - OIDC DTOs, constants, and service interfaces (published library).
4. **[Kernel Auth Code Flow Proxy API](kernel/kernel-authcodeflowproxy-api)** - OAuth 2.0 authorization-code login, logout, and token proxy (published library).

---

## Database

Auth manager identity is Keycloak (or a compatible IAM). There are no MOSIP schema scripts in this repository.

---

# Local Setup

## Prerequisites
- **JDK:** 21
- **Maven:** 3.9+
- **Docker:** Latest (optional, for container runs)
- **Keycloak/IDP:** Required for a full auth-manager run
- **Config Server** with the MOSIP property files
- **commons `kernel-core`** installed locally first

### Runtime Dependencies

`kernel-auth-adapter` and `kernel-openid-bridge-api` are Maven artifacts. Host MOSIP services depend on them; do not download them with Docker `wget` at container start.

`kernel-core` is **not** this reactor. Build it from [commons](https://github.com/mosip/commons) first:

```text
cd commons/kernel
mvn -pl kernel-core -am install "-Dgpg.skip=true"
```

### Configuration

OpenID Bridge uses configuration files from this [repository](https://github.com/mosip/mosip-config/tree/master).
Use the tagged version that matches your release.
- [application-default.properties](https://github.com/mosip/mosip-config/blob/master/application-default.properties) : Common MOSIP settings.
- [kernel-default.properties](https://github.com/mosip/mosip-config/blob/master/kernel-default.properties) : Kernel / auth-manager overrides (IAM URLs, clients, realms).

## Installation

### Local Setup (for Development or Contribution)

1. Make sure the config server is running. For detailed instructions, refer to the [MOSIP Config Server Setup Guide](https://docs.mosip.io/1.2.0/modules/registration-processor/registration-processor-developers-guide#environment-setup).

**Note**: Replace properties with your own configurations (DB credentials if used, IAM credentials, URLs).

2. Clone the repository:

```text
git clone <repo-url>
cd mosip-openid-bridge
```

3. Build the project (from `kernel/`; PowerShell: quote `-D`):

```text
cd kernel
mvn clean install -Dmaven.javadoc.skip=true "-Dgpg.skip=true"
```

4. Start auth manager (JDK 21 defaults; cluster GC is `JDK_JAVA_OPTIONS`, not the command line). Full OS / IDE / Docker notes: [`kernel/kernel-auth-service/README.md`](kernel/kernel-auth-service/README.md).

Linux / macOS / WSL / Git Bash:

```text
cd kernel/kernel-auth-service
chmod +x run-local.sh
./run-local.sh init
./run-local.sh start
```

Windows cmd:

```text
cd kernel\kernel-auth-service
run-local.bat init
run-local.bat start
```

Or run `io.mosip.kernel.auth.AuthBootApplication` (IntelliJ, Eclipse, VS Code/Cursor, NetBeans).

5. Verify Swagger / health at `http://localhost:8091/v1/authmanager`.

### Local Setup with Docker (Easy Setup for Demos)

#### Option 1: Pull from Docker Hub

Recommended for testers, students, and external users.

```text
docker pull mosipid/kernel-auth-service:<$version>
```

#### Option 2: Build Docker Images Locally

Recommended for contributors who want to modify or build from source.

1. Clone and build the project:

```text
git clone <repo-url>
cd mosip-openid-bridge
cd kernel
mvn clean install -Dmaven.javadoc.skip=true "-Dgpg.skip=true"
```

2. Build the auth-manager image:

```text
cd kernel/kernel-auth-service
docker build -t kernel-auth-service .
```

#### Running the Service

Scripts: `./run-local.sh docker` or `run-local.bat docker` (`init` + image build + run).

```text
docker run --rm -p 8091:8091 --name kernel-auth-service -e active_profile_env=local -e spring_config_url_env=http://host.docker.internal:51000 kernel-auth-service
```

Linux add `--add-host=host.docker.internal:host-gateway`. Optional `-e JDK_JAVA_OPTIONS="-Xms512M -Xmx512M"`. Details: [`kernel/kernel-auth-service/README.md`](kernel/kernel-auth-service/README.md).

#### Verify Installation

```text
docker ps
```

Access the service at `http://localhost:8091/v1/authmanager`.


---

## Deployment

### Kubernetes

To deploy auth manager on a Kubernetes cluster, refer to the [Sandbox Deployment Guide](https://docs.mosip.io/1.2.0/deploymentnew/v3-installation) and this repo’s [`deploy/`](deploy/README.md) installer.

Chart: [`helm/authmanager`](helm/authmanager/README.md). Image `kernel-auth-service`. Istio prefix `/v1/authmanager`. Align `CHART_VERSION` with `deploy/install.sh`.


## Documentation

### API Documentation

API endpoints, base URL, and mock server details: [MOSIP Kernel Authentication Manager Service](https://mosip.github.io/documentation/1.2.0/kernel-authentication-manager-service.html).

### Product Documentation

Functional overview: [MOSIP OpenID Bridge developer guide](https://docs.mosip.io/1.2.0/modules/commons/openid-bridge-developer-guide).


---
## Contribution & Community

• To learn how you can contribute code to this application, [click here](https://docs.mosip.io/1.2.0/community/code-contributions).

• If you have questions or encounter issues, visit the [MOSIP Community](https://community.mosip.io/) for support.

• For any GitHub issues: [Report here](https://github.com/mosip/mosip-openid-bridge/issues)

---

## License

This project is licensed under the [Mozilla Public License 2.0](LICENSE).
