# deploy/

Authmanager → NS `kernel`. Parent: [root](../AGENTS.md). Chart: [`helm/AGENTS.md`](../helm/AGENTS.md).

`install.sh [kubeconfig]` · `restart.sh` · `delete.sh`. Pin `CHART_VERSION`. Smoke: `/v1/authmanager`.

**Do not:** drop `conf-secrets` on restart; hardcode secrets.
