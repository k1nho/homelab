resource "helm_release" "cilium" {
  name      = "cilium"
  namespace = "kube-system"

  repository = "https://helm.cilium.io/"
  chart      = "cilium"

  version = var.cilium_version

  create_namespace = false

  values = [
    templatefile(
      "${path.module}/values/cilium-values.yaml",
      {
        server_ip   = var.server_ip
        server_port = var.server_port
      }
    )
  ]
}

resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.argocd_version

  create_namespace = true

  depends_on = [helm_release.cilium]
}
