/* output "web" {
  value =  {
    for k in yandex_compute_instance.web:
      k.network_interface[0].ip_address => k.network_interface[0].nat_ip_address
  }
} */
/* output "vms" {
  value = {
    for k in data.yandex_compute_instance_group.data-instance-group:
      k.network_interface[0].ip_address => k.network_interface[0].nap_ip_address
  }
} */