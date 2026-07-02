module "k3s" {
  source  = "xunleii/k3s/module"
  version = "3.4.0"

  k3s_version = var.k3s_version

  cidr = {
    pods     = var.pod_cidr
    services = var.service_cidr
  }

  servers = {
    for idx, node in var.masters :
    node.name => {
      ip = node.private_ip

      connection = {
        host  = node.public_ip
        user  = var.ssh_user
        agent = true
      }

      flags = concat(
        var.server_flags,
        idx == 0 ? ["--cluster-init"] : [],
        [
          "--node-external-ip=${node.public_ip}",
          "--tls-san=${var.api_server_address}"
        ]
      )
    }
  }

  agents = {
    for node in var.workers :
    node.name => {
      name = node.name
      ip   = node.private_ip

      connection = {
        host  = node.public_ip
        user  = var.ssh_user
        agent = true
      }

      flags = concat(
        var.agent_flags,
        [
          "--node-external-ip=${node.public_ip}",
        ]
      )
    }
  }
}
