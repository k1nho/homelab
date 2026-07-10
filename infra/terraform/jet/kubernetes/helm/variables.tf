variable "kubeconfig_path" {
  type = string
}

variable "server_ip" {
  type = string
}

variable "server_port" {
  type = string
}

variable "cilium_version" {
  type    = string
  default = "1.18.0"
}

variable "argocd_version" {
  type    = string
  default = "7.8.0"
}
