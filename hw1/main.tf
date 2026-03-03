module "vpc_dev" {
  source       = "./vpc_dev"
  vpc_name     = var.vpc_name
  cloud_id     = var.cloud_id
  folder_id    = var.folder_id
  mass_zones   = [
    { vpc_name = "ru-central1-a", subnet_name = "public", cidr = var.public_cidr, route_table_id = "" },
    { vpc_name = "ru-central1-a", subnet_name = "private", cidr = var.private_cidr, route_table_id = yandex_vpc_route_table.lab-rt-a.id },
  ]
}

resource "yandex_compute_instance" "web" {
  count       = 3
  name        = "${count.index % 2 == 0 ?"pubilc":"private"}${count.index}"
  platform_id = var.vm_platform_id
  allow_stopping_for_update = true

  resources { 
    cores         = var.vms_resources["web"].cores
    memory        = var.vms_resources["web"].memory
    core_fraction = var.vms_resources["web"].core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = var.nat_instance_image_id
    }
  }
  scheduling_policy {
    preemptible = true    
  }
  network_interface {
    subnet_id  = count.index % 2 == 0 ? module.vpc_dev.subnet_id["public"]:module.vpc_dev.subnet_id["private"]
    ip_address = count.index % 2 == 0 && count.index == 0 ? var.nat_instance_ip:""
    nat        = count.index % 2 != 0 ? false:true
  }
  metadata = {
    user-data          = data.template_file.cloudinit.rendered
    serial-port-enable = 1
  }
}

data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")

  vars = {
    ssh_public_key = file("~/.ssh/ssh-key-1756817743452.pub")
  }
}