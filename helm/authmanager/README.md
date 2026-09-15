# Authmanager

Helm chart for Kernel auth manager (`kernel-auth-service`).

Parent: [root README](../../README.md) · Installer: [`deploy/`](../../deploy/README.md)

Istio prefix `/v1/authmanager`. Image `kernel-auth-service`. Port `:8091`. Align `CHART_VERSION` with `deploy/install.sh`. Do not split the chart.

## TL;DR

```console
$ helm repo add mosip https://mosip.github.io
$ helm install my-release mosip/authmanager
```

## Introduction

Authmanager is part of Kernel, with its own Helm chart so it can be installed and managed independently in namespace `kernel`.

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0
- MOSIP config-server (and `conf-secrets`) already installed
- PV provisioner support in the underlying infrastructure if persistence is enabled

## Installing the Chart

To install the chart with the release name `authmanager`:

```console
helm install my-release mosip/authmanager
```

> **Tip**: List all releases using `helm list`

Cluster installer (copies configmaps, optional insecure TLS): [`../../deploy/install.sh`](../../deploy/install.sh).

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
```

The command removes Kubernetes components associated with the chart and deletes the release. Do not delete `conf-secrets` as part of an authmanager upgrade.

---

## Contribution & Community

• To learn how you can contribute code to this application, [click here](https://docs.mosip.io/1.2.0/community/code-contributions).

• If you have questions or encounter issues, visit the [MOSIP Community](https://community.mosip.io/) for support.

• For any GitHub issues: [Report here](https://github.com/mosip/mosip-openid-bridge/issues)

---

## License

This project is licensed under the [Mozilla Public License 2.0](../../LICENSE).
