output "web" {
  value =  [
    for k in yandex_compute_instance.web: {
      nap_ip = k.network_interface[0].nat_ip_address     
      ip     = k.network_interface[0].ip_address
    }     
  ]  
}