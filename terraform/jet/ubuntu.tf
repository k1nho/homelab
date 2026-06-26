################
#VMs
################

resource "openstack_compute_instance_v2" "ubuntu24_quad" {
  count = var.master_node_count

  name            = "kmaster${count.index + 1}"
  image_id        = var.image_id
  flavor_id       = 3
  key_pair        = var.public_key 
  security_groups = ["default", "k8sciliumnode"]

  metadata = {
    node = "K3s master node"
    CNI = "cilium"
    terraform_controlled = "yes"
  }

  network {
    name = var.private_network
  }
}

resource "openstack_compute_instance_v2" "ubuntu24_sm" {
  count = var.worker_node_count

  name            = "kworker${count.index + 1}"
  image_id        = var.image_id
  flavor_id       = 2
  key_pair        = var.public_key 
  security_groups = ["default", "k8sciliumnode"]

  metadata = {
    node = "K3s worker node"
    CNI = "cilium"
    terraform_controlled = "yes"
  }

  network {
    name = var.private_network
  }
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


################
#Output
################

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../../ansible/inventory.ini"

  content = templatefile(
    "${path.module}/templates/inventory.ini.tpl",
    {
      masters = [
        for idx, vm in openstack_compute_instance_v2.ubuntu24_quad : {
          name = vm.name
          ip   = openstack_networking_floatingip_v2.masters[idx].address
        }
      ]

      workers = [
        for idx, vm in openstack_compute_instance_v2.ubuntu24_sm : {
          name = vm.name
          ip   = openstack_networking_floatingip_v2.workers[idx].address
        }
      ]
    }
  )
}
