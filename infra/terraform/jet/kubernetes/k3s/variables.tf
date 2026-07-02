variable "masters" {
  type = list(object({
    name       = string
    public_ip  = string
    private_ip = string
  }))
}


variable "workers" {
  type = list(object({
    name       = string
    public_ip  = string
    private_ip = string
  }))
}


variable "ssh_user" {
  type = string
}


variable "k3s_version" {
  type    = string
  default = "v1.36.2+k3s1"
}


variable "pod_cidr" {
  default = "10.42.0.0/16"
}


variable "service_cidr" {
  default = "10.43.0.0/16"
}


variable "api_server_address" {
  type = string
}


variable "server_flags" {
  type = list(string)
  default = [
    "--flannel-backend=none",
    "--disable-kube-proxy",
    "--disable-network-policy",
    "--disable-cloud-controller",

    "--disable=traefik",
    "--disable=servicelb",

    "--kubelet-arg=cloud-provider=external",
    "--write-kubeconfig-mode=644"
  ]
}


variable "agent_flags" {
  type = list(string)
  default = [
    "--node-label=node-role=worker"
  ]
}
