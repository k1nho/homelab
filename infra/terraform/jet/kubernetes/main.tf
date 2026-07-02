module "security" {
  source = "./security"

  providers = {
    openstack = openstack
  }
}

module "compute" {
  depends_on = [module.security]
  source     = "./compute"

  providers = {
    openstack = openstack
    local     = local
  }

  image_id         = var.image_id
  os_public_key    = var.os_public_key
  node_power_state = var.node_power_state
}

module "k3sinstall" {
  depends_on = [module.compute]
  source     = "./k3s"

  masters            = module.compute.masters
  workers            = module.compute.workers
  ssh_user           = var.ssh_user
  api_server_address = module.compute.masters[0].public_ip
}

resource "local_file" "kubeconfig" {
  content         = module.k3sinstall.kubeconfig
  filename        = pathexpand("~/.config/kubeconfig.yaml")
  file_permission = "0600"
}

module "helm" {
  source = "./helm"

  server_ip       = module.compute.masters[0].public_ip
  server_port     = "6443"
  kubeconfig_path = local_file.kubeconfig.filename
}
