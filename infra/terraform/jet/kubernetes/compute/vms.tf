################
#NFS Volume
################

resource "openstack_blockstorage_volume_v3" "nfs_data" {
  name = "nfs-data"
  # In GB
  size        = 500
  volume_type = "__DEFAULT__"
  description = "Persistent storage for Kubernetes NFS"
}

################
#VMs
################

resource "openstack_compute_instance_v2" "ubuntu24_quad" {
  count = var.master_node_count

  name            = "${var.master_node_name_prefix}${count.index + 1}"
  image_id        = var.image_id
  flavor_id       = 3
  key_pair        = var.os_public_key
  security_groups = ["default", "k8sciliumnode"]
  power_state     = var.node_power_state

  metadata = {
    node                 = "K3s master node"
    CNI                  = "cilium"
    terraform_controlled = "yes"
  }

  network {
    name = var.private_network
  }
}

resource "openstack_compute_instance_v2" "ubuntu24_sm" {
  count = var.worker_node_count

  name            = "${var.worker_node_name_prefix}${count.index + 1}"
  image_id        = var.image_id
  flavor_id       = 2
  key_pair        = var.os_public_key
  security_groups = ["default", "k8sciliumnode"]
  power_state     = var.node_power_state

  metadata = {
    node                 = "K3s worker node"
    CNI                  = "cilium"
    terraform_controlled = "yes"
  }

  network {
    name = var.private_network
  }
}

resource "openstack_compute_instance_v2" "nfs" {
  name            = "kubernetes-nfs-server"
  image_id        = var.image_id
  flavor_id       = 2
  key_pair        = var.os_public_key
  security_groups = ["nfs-server"]
  power_state     = var.node_power_state

  block_device {
    uuid                  = var.image_id
    source_type           = "image"
    destination_type      = "local"
    boot_index            = 0
    delete_on_termination = true
  }

  block_device {
    uuid                  = openstack_blockstorage_volume_v3.nfs_data.id
    source_type           = "volume"
    destination_type      = "volume"
    boot_index            = 1
    delete_on_termination = false
  }

  network {
    name = var.private_network
  }

  user_data = file("${path.module}/templates/cloud-init.yaml")
}

################
#FIPS 
################

resource "openstack_networking_floatingip_v2" "masters" {
  count = var.master_node_count
  pool  = "public"
}

resource "openstack_networking_floatingip_v2" "workers" {
  count = var.worker_node_count
  pool  = "public"
}

resource "openstack_networking_floatingip_v2" "nfs" {
  pool = "public"
}

################
#PORTS
################

data "openstack_networking_port_v2" "master_ports" {
  count = var.master_node_count

  device_id  = openstack_compute_instance_v2.ubuntu24_quad[count.index].id
  network_id = openstack_compute_instance_v2.ubuntu24_quad[count.index].network[0].uuid
}

data "openstack_networking_port_v2" "worker_ports" {
  count = var.worker_node_count

  device_id  = openstack_compute_instance_v2.ubuntu24_sm[count.index].id
  network_id = openstack_compute_instance_v2.ubuntu24_sm[count.index].network[0].uuid
}

data "openstack_networking_port_v2" "nfs_ports" {
  device_id  = openstack_compute_instance_v2.nfs.id
  network_id = openstack_compute_instance_v2.nfs.network[0].uuid
}

################
#FIPS Association
################

resource "openstack_networking_floatingip_associate_v2" "masters" {
  count = var.master_node_count

  floating_ip = openstack_networking_floatingip_v2.masters[count.index].address
  port_id     = data.openstack_networking_port_v2.master_ports[count.index].id
}

resource "openstack_networking_floatingip_associate_v2" "workers" {
  count = var.worker_node_count

  floating_ip = openstack_networking_floatingip_v2.workers[count.index].address
  port_id     = data.openstack_networking_port_v2.worker_ports[count.index].id
}

resource "openstack_networking_floatingip_associate_v2" "nfs" {
  floating_ip = openstack_networking_floatingip_v2.nfs.address
  port_id     = data.openstack_networking_port_v2.nfs_ports.id
}
