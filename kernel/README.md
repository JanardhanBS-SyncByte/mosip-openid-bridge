# Kernel

Java parent for MOSIP OpenID Bridge. Infra (Helm / install) → [root README](../README.md).

The reactor publishes:

- **kernel-openid-bridge-api** — OIDC DTOs and SPIs. Siblings take it with **no** `<version>`.
- **kernel-authcodeflowproxy-api** — OAuth 2.0 authorization-code proxy APIs
- **kernel-auth-adapter** — Spring Security adapter (Maven dependency for MOSIP services)
- **kernel-auth-service** — Auth manager HTTP · `:8091` · `/v1/authmanager`

Do not reintroduce `kernel-bom`. Pin versions on `kernel/pom.xml`. Boot 4 uses ZIP layout, not `<executable>true`. Logger and Velocity templates live in commons `kernel-core`.

**Configuration** lives in [mosip-config](https://github.com/mosip/mosip-config).

### Build

Install commons `kernel-core` **1.4.1-SNAPSHOT** first, then from `kernel/`:

```text
mvn clean install -Dmaven.javadoc.skip=true "-Dgpg.skip=true"
```

PowerShell: quote `-D`. One module: `mvn -pl <mod> -am test`.

### Deploy

HTTP service: [`deploy/`](../deploy/README.md). Chart: [`helm/authmanager`](../helm/authmanager/README.md).

Local run with a profile:

```text
java -Dspring.profiles.active=<profile> -jar kernel-auth-service-1.4.1-SNAPSHOT.jar
```

Remote config:

```text
java -Dspring.profiles.active=<profile> -Dspring.cloud.config.uri=<config-url> -Dspring.cloud.config.label=<config-label> -jar kernel-auth-service-1.4.1-SNAPSHOT.jar
```

See [`AGENTS.md`](AGENTS.md).
