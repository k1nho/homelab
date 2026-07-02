terraform {
  required_version = ">= 0.14.0"
  required_providers {
    local = {
      source = "hashicorp/local"
    }
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3.4.0"
    }
  }
}

provider "local" {}

provider "openstack" {}
