//
// Create a new VPC Route Table.
//
resource "yandex_vpc_route_table" "lab-rt-a" {
  network_id = module.vpc_dev.network_id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = var.nat_instance_ip
  }
}