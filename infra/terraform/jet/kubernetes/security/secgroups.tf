data "openstack_networking_subnet_v2" "private_subnet" {
  name = "auto_allocated_subnet_v4"
}

resource "openstack_networking_secgroup_v2" "k8sciliumnode" {
  name        = "k8sciliumnode"
  description = "k8s node (Cilium CNI)"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_ciliumudp" {
  description       = "Enable Cilium VXLAN mode via UDP"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 8472
  port_range_max    = 8472
  remote_ip_prefix  = data.openstack_networking_subnet_v2.private_subnet.cidr
  security_group_id = openstack_networking_secgroup_v2.k8sciliumnode.id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.k8sciliumnode.id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_ping" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  port_range_min    = 0
  port_range_max    = 0
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.k8sciliumnode.id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_incoming_all" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 0
  port_range_max    = 0
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.k8sciliumnode.id
}
