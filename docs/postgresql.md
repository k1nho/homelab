# CloudNativePG (CNPG)

![CloudNativePG Logo](./assets/CNPG.png)

For relational databases, we use [CloudNativePG](https://cloudnative-pg.io/) (CNPG) to spin up a Cluster of PostgreSQL databases. The CNPG operator handles the full lifecycle of the database, including **leader election, boostraping, automated backups, and many more**.

## Installation

### ArgoCD

Installing via ArgoCD:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: cnpg
  namespace: argocd
  annotations:
    argocd.argoproj.io/sync-wave: "0"
spec:
  project: default
  sources:
    - repoURL: https://cloudnative-pg.github.io/charts
      chart: cloudnative-pg
      targetRevision: 0.27.1
  destination:
    server: https://kubernetes.default.svc
    namespace: cnpg-system
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
      - ServerSideApply=true # CRDs are large (avoid annotation size limits)
```

### Helm

Installing with Helm:

```bash
helm repo add cnpg https://cloudnative-pg.github.io/charts
helm upgrade --install cnpg --namespace cnpg-system \
  --create-namespace \
  cnpg/cloudnative-pg
```

## Basic Cluster Setup

To create a basic PostgreSQL cluster, we can apply the following CRD:

```yaml
apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: linkding-db
spec:
  instances: 3
  storage:
    size: 1Gi

  imageName: ghcr.io/cloudnative-pg/postgresql:18.3
```

This creates a PostgreSQL cluster with one primary and two replicas, and each with 1Gi of storage. Check out the
[examples](https://cloudnative-pg.io/docs/1.28/samples/) for more advanced setups, and the [cluster specification](https://cloudnative-pg.io/docs/1.28/cloudnative-pg.v1/#clusterspec) for all the available options.
