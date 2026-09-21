# kernel/

Pins on `pom.xml`. Compiler 3.x (not 4). Vert.x **3.9.16**. `DateUtils2`. ZIP not `<executable>true`. Each module POM has project `<version>` (kattu xmllint); sibling **deps** omit `<version>`. Parent keeps `git-commit-id-plugin`.

`openid-bridge-api` · `authcodeflowproxy-api` · `auth-adapter` · `auth-service` (`:8091` `/v1/authmanager`)

`PathPatternSupport` + `matching-strategy` (`PATH_PATTERN_PARSER` | `ANT_PATH_MATCHER`). Spring 7: `fromUriString` · `getStatusCode().value()` · `APPLICATION_JSON` · Tomcat.

Ban: merge adapter→service · Keycloak adapter BOM · Vert.x 4/5 · invent `@author`

`mvn -pl <mod> -am test`. PS: quote `-D`. JaCoCo `@{argLine}`. XML: no `--`. Local: `kernel-auth-service/run-local.sh|.bat` (`init` `start` `smoke` `stop`).
