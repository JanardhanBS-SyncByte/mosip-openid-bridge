# Deploy

Installs **authmanager** into namespace `kernel`.

Parent: [root README](../README.md) · Chart: [`helm/authmanager`](../helm/authmanager/README.md)

Scripts: `install.sh [kubeconfig]` · `restart.sh` · `delete.sh`. Pin `CHART_VERSION` to match the chart. Smoke: `/v1/authmanager`.

Do not drop `conf-secrets` on restart. Do not hardcode secrets.

## Overview

See [OpenID Bridge](https://docs.mosip.io/1.2.0/modules/commons/openid-bridge-developer-guide). Cluster layout: [Sandbox Deployment Guide](https://docs.mosip.io/1.2.0/deploymentnew/v3-installation).

## Install

```sh
./install.sh
```

* During `install.sh`, a prompt asks whether the server has a public domain and a valid SSL certificate.
* If it does not, choose `n`. That enables an `init-container` with an `emptyDir` volume on the deployment.
* The init-container downloads the server’s self-signed SSL certificate and mounts it into the container Java keystore (`cacerts`).
* Use that option only in development environments.

Optional kubeconfig:

```sh
./install.sh /path/to/kubeconfig
```

## Restart

```sh
./restart.sh
```

## Delete

```sh
./delete.sh
```

---

## Contribution & Community

• To learn how you can contribute code to this application, [click here](https://docs.mosip.io/1.2.0/community/code-contributions).

• If you have questions or encounter issues, visit the [MOSIP Community](https://community.mosip.io/) for support.

• For any GitHub issues: [Report here](https://github.com/mosip/mosip-openid-bridge/issues)

---

## License

This project is licensed under the [Mozilla Public License 2.0](../LICENSE).
