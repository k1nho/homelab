##################
# Compute Module #
##################
variable "image_id" {
  description = "Image ID to use for compute instances"
  type        = string
}

variable "os_public_key" {
  description = "The ssh public key to use for all the nodes"
  type        = string
}

variable "node_power_state" {
  description = "The node state after spawn"
  type        = string
  default     = "shelved_offloaded"
}


##############
# K3s Module #
##############

variable "ssh_user" {
  description = "The name of the ssh user"
  type        = string
  default     = "ubuntu"
}
