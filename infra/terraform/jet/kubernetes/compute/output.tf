resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../../../../ansible/inventory.ini"

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

output "masters" {
  value = [
    for idx, vm in openstack_compute_instance_v2.ubuntu24_quad : {
      name       = vm.name
      public_ip  = openstack_networking_floatingip_v2.masters[idx].address
      private_ip = vm.access_ip_v4
    }
  ]
}

output "workers" {
  value = [
    for idx, vm in openstack_compute_instance_v2.ubuntu24_sm : {
      name       = vm.name
      public_ip  = openstack_networking_floatingip_v2.workers[idx].address
      private_ip = vm.access_ip_v4
    }
  ]
}
