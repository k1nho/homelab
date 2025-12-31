# GitOps

![ArgoCD Logo](./assets/argocd_logo.png)

[ArgoCD](https://argo-cd.readthedocs.io/en/stable/) is used as the declarative continuous delivery solution for the cluster.
Based on the GitOps workflow, it provides:

- Git as the source of truth for the state of the cluster
- Automated application life cycle management with easy rollbacks and updates
- Declarative [app of apps](https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/#app-of-apps) pattern for easy deployment.

# Setup

To setup argo, we need to apply all its CRDs, and create a new namespace with the following command:

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Then, you can extract the initial password for the admin user from the secret `argocd-initial-admin-secret`.

```bash
kubectl get secret argocd-initial-admin-secret -n argocd -ojsonpath='{.data.password}' | base64 -d
```

To quickly check the Argo UI, we can port forward the argocd server

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```
