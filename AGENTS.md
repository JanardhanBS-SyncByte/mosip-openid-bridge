# mosip-openid-bridge

JDK 21 · Maven 3.9+ · Boot **4.1.1**. `cd kernel && mvn clean install "-Dgpg.skip=true"`. No `kernel-bom`.

| Area | Guide |
|------|-------|
| Java | [`kernel/AGENTS.md`](kernel/AGENTS.md) |
| Helm | [`helm/AGENTS.md`](helm/AGENTS.md) |
| Install | [`deploy/AGENTS.md`](deploy/AGENTS.md) |

Auth libs: `kernel-auth-adapter` + `kernel-openid-bridge-api` (Maven). `kernel-core` **1.4.1-SNAPSHOT** from commons (`mvn -pl kernel-core -am install "-Dgpg.skip=true"` there first).

**Do not:** `kernel-bom`; sibling `<version>` pins; `/v1/authmanager` without Helm/deploy; Boot `<executable>true` (ZIP only); `DateUtils` (use `DateUtils2`).
