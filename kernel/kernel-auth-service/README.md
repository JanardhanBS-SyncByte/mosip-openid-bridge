# Kernel Auth Service

[![Maven Package upon a push](https://github.com/mosip/mosip-openid-bridge/actions/workflows/push-trigger.yml/badge.svg?branch=develop)](https://github.com/mosip/mosip-openid-bridge/actions/workflows/push-trigger.yml)

## Overview

**Kernel Auth Service** is the MOSIP auth manager HTTP process. It issues and validates tokens against Keycloak (or a compatible IdP) for MOSIP modules.

Parent: [`../README.md`](../README.md) · Helm: [`../../helm/authmanager`](../../helm/authmanager/README.md) · Deploy: [`../../deploy`](../../deploy/README.md)

Do not change `/v1/authmanager` without Helm/deploy. Boot 4 uses ZIP layout. Embedded server is Tomcat.

---

## At a glance

| Item | Value |
|------|--------|
| Port | `8091` |
| Context path | `/v1/authmanager` |
| Main class | `io.mosip.kernel.auth.AuthBootApplication` |
| IAM | `KeycloakImpl` |
| Image | `kernel-auth-service` |
| Maven deps | commons `kernel-core`, reactor `kernel-openid-bridge-api` + `kernel-auth-adapter` (unpacked at package time) |

**Quick health check (after start):**

| Purpose | URL |
|---------|-----|
| Health | http://localhost:8091/v1/authmanager/actuator/health |
| Swagger UI | http://localhost:8091/v1/authmanager/swagger-ui/index.html |
| OpenAPI | http://localhost:8091/v1/authmanager/v3/api-docs |

---

## Features

- Generate token using userid and password
- Generate token using client-id and secret key
- Validate token
- Refresh token
- Invalidate token on expiry
- OTP and UIN-backed flows where configured

---

## Database

Identity is Keycloak. There are no MOSIP schema scripts in this module.

---

# Local Setup

## Prerequisites
- **JDK:** 21
- **Maven:** 3.9+
- **Docker:** Latest (optional)
- **Keycloak/IDP:** Required for a full run
- **Config Server** with MOSIP property files
- commons **`kernel-core` 1.4.1-SNAPSHOT** installed first

### Configuration

Uses files in [mosip-config](https://github.com/mosip/mosip-config/tree/master). Refer to the tagged version for your release.
- [application-default.properties](https://github.com/mosip/mosip-config/blob/master/application-default.properties)
- [kernel-default.properties](https://github.com/mosip/mosip-config/blob/master/kernel-default.properties)

## Installation

### Local Setup (for Development or Contribution)

1. Config server must be running. See the [MOSIP Config Server Setup Guide](https://docs.mosip.io/1.2.0/modules/registration-processor/registration-processor-developers-guide#environment-setup).

2. From `kernel/`:

```text
mvn -pl kernel-auth-service -am clean install -Dmaven.javadoc.skip=true "-Dgpg.skip=true"
```

3. Start:

```text
java -jar kernel-auth-service/target/kernel-auth-service-1.4.1-SNAPSHOT.jar
```

Or run `io.mosip.kernel.auth.AuthBootApplication` from the IDE.

4. Verify `http://localhost:8091/v1/authmanager/actuator/health`.

Remote config:

```text
java -Dspring.profiles.active=<profile> -Dspring.cloud.config.uri=<config-url> -Dspring.cloud.config.label=<config-label> -jar kernel-auth-service-1.4.1-SNAPSHOT.jar
```

### Local Setup with Docker

#### Option 1: Pull from Docker Hub

```text
docker pull mosipid/kernel-auth-service:1.4.1-SNAPSHOT
```

#### Option 2: Build locally

```text
cd kernel/kernel-auth-service
docker build -t kernel-auth-service .
```

```text
docker run -d -p 8091:8091 --name kernel-auth-service kernel-auth-service
```

Pass `active_profile_env`, `spring_config_url_env`, and `spring_config_label_env` as in the Dockerfile. The adapter is already in the image; do not wget `kernel-auth-adapter.jar`.

---

## Deployment

### Kubernetes

Cluster install: [`deploy/`](../../deploy/README.md) (`./install.sh [kubeconfig]`). Chart [`helm/authmanager`](../../helm/authmanager/README.md). Sandbox: [v3 installation](https://docs.mosip.io/1.2.0/deploymentnew/v3-installation).

---

## Documentation

### API Documentation

[MOSIP Kernel Authentication Manager Service](https://mosip.github.io/documentation/1.2.0/kernel-authentication-manager-service.html)

### Product Documentation

[OpenID Bridge developer guide](https://docs.mosip.io/1.2.0/modules/commons/openid-bridge-developer-guide)

---

## Contribution & Community

• To learn how you can contribute code to this application, [click here](https://docs.mosip.io/1.2.0/community/code-contributions).

• If you have questions or encounter issues, visit the [MOSIP Community](https://community.mosip.io/) for support.

• For any GitHub issues: [Report here](https://github.com/mosip/mosip-openid-bridge/issues)

---

## License

This project is licensed under the [Mozilla Public License 2.0](../../LICENSE).
