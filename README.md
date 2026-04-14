![Kinho's Homelab Cover](./docs/assets/homelab_series_cover.png)

Welcome! This is my personal, continuously evolving **Kubernetes cluster** designed to learn and experiment with multiple cloud-native technologies.
Along the way, I self-host multiple services, including my **tech blog**, **Jellyfin media server**, **Linkding bookmark manager**, and many more.

---

# The Homelab Series

The progress of the homelab is documented in a **storytelling format** through my [blog](https://kincodes.com/tags/homelab-series/), where I share updates, challenges, and lessons learned during the development and expansion of the cluster.

---

# The Homelab Documentation

The [documentation](https://kincodes.com/homelab/) contains an describes the architecture, components, and their purpose within the **k3s cluster** for the homelab series. It complements the blog by providing more details about configurations, and guides that might be skipped in the storytelling posts.

---

# Architecture

This repository uses the app of apps pattern to trigger the installation all the Kubernetes resources with ArgoCD. Moreover, it uses a promotion system structure based on environment hierarchy.

- `root.yaml`: The entrypoint defines a bootstrap application that points to all the homelab ApplicationSets
- `appsets`: Contains all the ApplicationSet Custom Resource to apply
- `kustomize-apps`: Contains all the applications that are installed via [Kustomize](https://kustomize.io/)
- `charts`: Contains all the applications that are installed via [Helm Charts](https://helm.sh/)
- `values`: Contains all the custom values to apply to the helm charts based on the environment hierarchy
- `docs`: The homelab documentation

---

# Applications

Applications running in the cluster are split by the installation strategy which can be: Kustomize, and Helm Charts.

## 📜 Kustomize

|                                                                                                 | App                                                      | Description                  | Homelab Kustomize                                                                   |
| ----------------------------------------------------------------------------------------------- | -------------------------------------------------------- | ---------------------------- | ----------------------------------------------------------------------------------- |
| <img src="https://cdn.jsdelivr.net/gh/selfhst/icons/png/argo-cd.png" width="24">                | [**Argo UI**](https://argo-cd.readthedocs.io/en/stable/) | The Argo UI                  | [Kustomize](https://github.com/k1nho/homelab/kustomize-apps/argocd/envs/homelab/)   |
| <img src="https://img.icons8.com/?size=100&id=cXYUoqPdbtbr&format=png&color=000000" width="24"> | [**Blog**](https://kincodes.com)                         | My personal blog             | [Kustomize](https://github.com/k1nho/homelab/kustomize-apps/blog/envs/homelab/)     |
| <img src="https://cdn.jsdelivr.net/gh/selfhst/icons/png/homepage.png" width="24">               | [**Homepage**](https://gethomepage.dev/)                 | Cluster Dashboard Entrypoint | [Kustomize](https://github.com/k1nho/homelab/kustomize-apps/homepage/envs/homelab/) |
| <img src="https://cdn.jsdelivr.net/gh/selfhst/icons/png/linkding.png" width="24">               | [**Linkding**](https://linkding.link/)                   | Bookmark manager application | [Kustomize](https://github.com/k1nho/homelab/kustomize-apps/linkding/envs/homelab/) |

## ☸️ Helm

|                                                                                     | App                                                                                                     | Description                                                                                         | Chart                                                                                    | Values                                                                                                        |
| ----------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- |
| <img src="https://cdn.jsdelivr.net/gh/selfhst/icons/png/cilium.png" width="24">     | [**Cilium**](https://cilium.io/)                                                                        | Cilium is the CNI of choice for the cluster                                                         | [Chart](https://github.com/cilium/cilium/tree/v1.18.4/install/kubernetes/cilium)         | [Values](https://github.com/cilium/cilium/blob/v0.18.4/install/kubernetes/cilium/values.yaml)                 |
| <img src="https://cdn.jsdelivr.net/gh/selfhst/icons/png/postgresql.png" width="24"> | [**Cloud Native PG**](https://cloudnative-pg.io/)                                                       | Kubernetes operator to manage the full lifecycle of a PostgreSQL database cluster                   | [Chart](https://github.com/cloudnative-pg/charts/tree/main/charts/cloudnative-pg)        | [Values](https://github.com/cloudnative-pg/charts/blob/main/charts/cloudnative-pg/values.yaml)                |
| <img src="https://cdn.jsdelivr.net/gh/selfhst/icons/png/infisical.png" width="24">  | [**Infisical Secrets Operator**](https://infisical.com/docs/integrations/platforms/kubernetes/overview) | Implements the external secret operator pattern (ESO) to manage Kubernetes secrets in the cluster   | [Chart](github.com/Infisical/kubernetes-operator/tree/main/helm-charts/secrets-operator) | [Values](https://github.com/Infisical/kubernetes-operator/blob/main/helm-charts/secrets-operator/values.yaml) |
| <img src="https://cdn.jsdelivr.net/gh/selfhst/icons/png/tailscale.png" width="24">  | [**Tailscale Operator**](https://tailscale.com/docs/features/kubernetes-operator)                       | Tailscale kubernetes operator (enable ingress to access services on all authorized tailnet devices) | [Chart]()                                                                                | [Values]()                                                                                                    |

---
