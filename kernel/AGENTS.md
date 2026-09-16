# kernel/

Java. Infra → [root](../AGENTS.md). Pins: `pom.xml`. Compiler 3.x GA (not 4.x). Vert.x **3.9.16**. `DateUtils2`. ZIP not `<executable>true`.

`openid-bridge-api` · `authcodeflowproxy-api` · `auth-adapter` · `auth-service` (`:8091` `/v1/authmanager`)

Spring 7: `fromUriString` · `getStatusCode().value()` · `APPLICATION_JSON` · Tomcat · `PathPatternSupport` (`matching-strategy`: `PATH_PATTERN_PARSER` | `ANT_PATH_MATCHER`)

**Don't:** merge adapter into service · Keycloak adapter BOM · Vert.x 4/5 · invent `@author`

**Build:** `mvn -pl <mod> -am test`. PS: quote `-D`. Surefire `@{argLine}`. XML: no `--`.
