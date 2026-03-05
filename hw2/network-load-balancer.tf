resource "yandex_lb_target_group" "target-group" {
    
    depends_on = [ yandex_compute_instance_group.instance-group ]
    region_id = "ru-central1"

    dynamic "target" {
        for_each = toset(data.yandex_compute_instance_group.group-info.instances[*].network_interface[0].ip_address)
        content {
            address   = target.value
            subnet_id = module.vpc_dev.subnet_id["public"]
        }
    }
}

resource "yandex_lb_network_load_balancer" "network-load-balancer" {
  name = "network-load-balancer"

  listener {
    name = "tcp-listener"
    port = 80                 
    protocol = "tcp"
    target_port = 80          
    
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.target-group.id
    healthcheck {
        name = "http"
        http_options {
            port =  80
            path = "/"
        }
    }
  }
}