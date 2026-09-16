# kernel/

Java parent. Infra → [root](../AGENTS.md).

| Module | Role |
|--------|------|
| `kernel-openid-bridge-api` | OIDC DTOs/SPIs. Siblings: **no** `<version>` |
| `kernel-authcodeflowproxy-api` | Auth-code proxy |
| `kernel-auth-adapter` | Spring Security adapter (Maven) |
| `kernel-auth-service` | Authmanager · `:8091` · `/v1/authmanager` |

Pins on `kernel/pom.xml`. Children inherit plugins. `kernel-core` + siblings: **no** `<version>`. ZIP layout, not `<executable>true`. Logger/velocity in `kernel-core`. Compiler plugin: Maven **3.x** GA (not 4.x beta).

**Keep:** `/v1/authmanager`, Keycloak IAM, `DateUtils2`, adapter filter chain. Spring 7: `fromUriString`; `getStatusCode().value()`; `APPLICATION_JSON`; Tomcat; `AnyRequestMatcher` + `PathPatternRequestMatcher` (`PathPatternSupport`; no `AntPathRequestMatcher`).

**Do not:** `kernel-bom`; merge adapter into service; restore `DateUtils`; Keycloak adapter BOM; Vert.x **4/5** (stay **3.9.16**).

**Build:** `mvn -pl <mod> -am test` from `kernel/`. PowerShell: quote `-D`. Surefire: `@{argLine}`. XML comments: no `--`. No invented `@author`.
