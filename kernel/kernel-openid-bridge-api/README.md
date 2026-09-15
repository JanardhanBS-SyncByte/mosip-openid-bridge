# Kernel OpenID Bridge API

## Overview

**Kernel OpenID Bridge API** is the published library of OpenID Connect DTOs, constants, and service interfaces used by the adapter, auth-code proxy, and auth manager.

It has **no** HTTP controllers and **no** Spring Boot main class. Siblings depend on it with **no** `<version>` (parent `dependencyManagement` = `${project.version}`).

Parent: [`../README.md`](../README.md)

---

# Local Setup

## Prerequisites
- **JDK:** 21
- **Maven:** 3.9+
- commons **`kernel-core` 1.4.1-SNAPSHOT** installed first

## Usage

```xml
<dependency>
    <groupId>io.mosip.kernel</groupId>
    <artifactId>kernel-openid-bridge-api</artifactId>
    <version>1.4.1-SNAPSHOT</version>
</dependency>
```

Reactor siblings omit `<version>`.

## Installation

From `kernel/`:

```text
mvn -pl kernel-openid-bridge-api -am clean install -Dmaven.javadoc.skip=true "-Dgpg.skip=true"
```

## Configuration

This library does not bind MOSIP config by itself. Hosts that implement the interfaces take IAM properties from [mosip-config](https://github.com/mosip/mosip-config).

Scan / import package: `io.mosip.kernel.openid.bridge`.

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
