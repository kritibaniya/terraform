resource "openstack_compute_instance_v2" "control-node" {
 name = var.instance1_name
 image_id = "6d7bb615-2ee7-41ab-bb98-2afdc6063519"
 flavor_id = "osl0c4r16d80"
 key_pair = openstack_compute_keypair_v2.jumphost_key.name
 security_groups = ["default", "Task1_SecurityGroup"]
 
 network {
  name = openstack_networking_network_v2.auto_network.name
 }
}

resource "openstack_compute_instance_v2" "worker-node1" {
 name = var.instance2_name
 image_id = "6d7bb615-2ee7-41ab-bb98-2afdc6063519"
 flavor_id = "osl0c4r16d80"
 key_pair = openstack_compute_keypair_v2.jumphost_key.name
 security_groups = ["default", "Task1_SecurityGroup"]

 network {
  name = openstack_networking_network_v2.auto_network.name
 }
}

resource "openstack_compute_instance_v2" "worker-node2" {
 name = var.instance3_name
 image_id = "6d7bb615-2ee7-41ab-bb98-2afdc6063519"
 flavor_id = "osl0c4r16d80"
 key_pair = openstack_compute_keypair_v2.jumphost_key.name
 security_groups = ["default", "Task1_SecurityGroup"]

 network {
  name = openstack_networking_network_v2.auto_network.name
 }
}


resource "openstack_networking_network_v2" "auto_network"{
 name = var.network_name
 admin_state_up = true
}

resource "openstack_networking_subnet_v2" "auto_subnet"{
 name = var.subnet_name
 network_id = openstack_networking_network_v2.auto_network.id
 cidr = "10.10.0.0/24"
 ip_version = 4
}

resource "openstack_networking_router_v2" "auto_router" {
  name                = "auto_router"
  external_network_id = "e6ff1cc8-59d6-433e-ac9a-cdbe4293c2e9"
}

resource "openstack_networking_router_interface_v2" "router_interface_1" {
  router_id = openstack_networking_router_v2.auto_router.id
  subnet_id = openstack_networking_subnet_v2.auto_subnet.id
}

resource "openstack_networking_floatingip_v2" "floating_ip" {
  pool = "Internet"
}

resource "openstack_compute_floatingip_associate_v2" "fIP" {
  floating_ip = openstack_networking_floatingip_v2.floating_ip.address
  instance_id = openstack_compute_instance_v2.control-node.id
}

resource "openstack_compute_keypair_v2" "jumphost_key"{
 name = "jumphost_key"
 public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDg8Xc+FLVjZatXe4D3/cFJwlwNk1SwDu349fA1NepebWdC8M7Ew3ahGCB5uk6YUL1aGIa6BWFdRfPZGRrwuvLY1L/ahZ3e3qHAjHE9fgdFbeAGEtTnX8d+iVjPygVA239NwVDvNWccNDlCQGbsmPYBp/D+wN8u+xug3znt3mTLw4WAQV1EUglexGfH/nUNXyZBlVUty+zcDghnc9srQWqWZZ6BuAwoSAoJXuHgQ+ATjknBKa55Wr7REJoblICXPoAwYoy9rRI++6ba5QDSMvdeENnftHudrDuCBe9xhZaG1Ex9kzkfmVhAA2Hj8v7qq9S42RZDLeaysh2DvVYH0SOsaSfKsUY+y/d9bxyU7y6B2M2TJ8d0t8qonOv2Gp4Qn/OB5w2t3spsOU/Klu7dmNNu/38TNnLX3YfE64Y0JJ+Y7donlbqylDr7JKKy4geqnKdo0ESeI4t3ELGZQSDL46S7cha2V9PQ1rm4SITSMv23LTmy1TFwRPX62al66G7XVrc= ubuntu@task1-instance"
}
