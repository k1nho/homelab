variable "master_node_count" {
  default = "1"
}

variable "worker_node_count" {
  default = "2"
}

variable "public_key" {
  default = "nsdfkey"
}

variable "image_id" {
  # image id of the iso
  default = "b06b3fd1-4bb8-4868-ad61-3f60b7907291"
}

variable "private_network" {
  default = "auto_allocated_network"
}
