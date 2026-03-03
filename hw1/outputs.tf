output "web" {
  value =  {
    for k in yandex_compute_instance.web:
      k.network_interface[0].ip_address => k.network_interface[0].nat_ip_address
  }
}