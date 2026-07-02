variable "image_id" {
  description = "Image ID to use for compute instances"
  type        = string
}

variable "master_node_count" {
  description = "The number of control plane nodes to spawn"
  type        = number
  default     = 1
}

variable "worker_node_count" {
  description = "The number of worker nodes to spawn"
  type        = number
  default     = 2
}

variable "master_node_name_prefix" {
  description = "The common name prefix of the control plane nodes"
  type        = string
  default     = "cp"
}

variable "worker_node_name_prefix" {
  description = "The common name prefix of the worker nodes"
  type        = string
  default     = "worker"
}

variable "node_power_state" {
  description = "The node state after spawn"
  type        = string
  default     = "active"
}

variable "os_public_key" {
  description = "The ssh public key to use for all the nodes"
  type        = string
}

variable "private_network" {
  description = "The name of the private network"
  type        = string
  default     = "auto_allocated_network"
}
