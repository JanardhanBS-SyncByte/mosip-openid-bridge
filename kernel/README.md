# Kernel

Java parent for MOSIP OpenID Bridge. Infra (Helm / install) → [root README](../README.md).

The reactor publishes:

- **kernel-openid-bridge-api** — OIDC DTOs and SPIs. Siblings take it with **no** `<version>`.
- **kernel-authcodeflowproxy-api** — OAuth 2.0 authorization-code proxy APIs
- **kernel-auth-adapter** — Spring Security adapter (Maven dependency for MOSIP services)
- **kernel-auth-service** — Auth manager HTTP · `:8091` · `/v1/authmanager`

Do not reintroduce `kernel-bom`. Pin versions on `kernel/pom.xml`. Boot 4 uses ZIP layout, not `<executable>true`. Logger and Velocity templates live in commons `kernel-core`.

**Configuration** lives in [mosip-config](https://github.com/mosip/mosip-config). Path matching uses the Boot 3.4 key `spring.mvc.pathmatch.matching-strategy` (`PATH_PATTERN_PARSER` default, `ANT_PATH_MATCHER` for Ant).

### Build

Install commons `kernel-core` first, then from `kernel/`:

```text
mvn clean install -Dmaven.javadoc.skip=true "-Dgpg.skip=true"
```

PowerShell: quote `-D`. One module: `mvn -pl <mod> -am test`.

### Deploy

HTTP service: [`deploy/`](../deploy/README.md). Chart: [`helm/authmanager`](../helm/authmanager/README.md).

Local run (all OS / IDEs / Docker): [`kernel-auth-service/README.md`](kernel-auth-service/README.md) · [`run-local.sh`](kernel-auth-service/run-local.sh) · [`run-local.bat`](kernel-auth-service/run-local.bat). Scripts compile, test, then start. Do not copy cluster GC flags; use `JDK_JAVA_OPTIONS` only if you need heap.

```text
cd kernel/kernel-auth-service && ./run-local.sh
```

```text
cd kernel\kernel-auth-service
run-local.bat
```

See [`AGENTS.md`](AGENTS.md).
