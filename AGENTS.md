# mosip-openid-bridge

JDK 21 · Maven 3.9+ · Boot in `kernel/pom.xml`. `cd kernel && mvn clean install "-Dgpg.skip=true"`.

[`kernel/`](kernel/AGENTS.md) · [`helm/`](helm/AGENTS.md) · [`deploy/`](deploy/AGENTS.md)

Adapter + `kernel-openid-bridge-api` (Maven). commons `kernel-core` first.

**Don't:** `kernel-bom` · sibling `<version>` · `/v1/authmanager` sans Helm · `<executable>true` · `DateUtils`
