module "vpc_dev" {
  source       = "./vpc_dev"
  vpc_name     = var.vpc_name
  cloud_id     = var.cloud_id
  folder_id    = var.folder_id
  mass_zones   = [
    { vpc_name = "ru-central1-a", subnet_name = "public", cidr = "192.168.10.0/24" },
  ]
}


resource "yandex_compute_instance" "web" {
  count       = 1
  name        = "web${count.index + 1}"
  platform_id = var.vm_platform_id
  allow_stopping_for_update = true

  resources { 
    cores         = var.vms_resources["web"].cores
    memory        = var.vms_resources["web"].memory
    core_fraction = var.vms_resources["web"].core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1"
    }
  }
  scheduling_policy {
    preemptible = true    
  }
  network_interface {
    subnet_id          = module.vpc_dev.subnet_id[0].id
    nat                = true
    
  }
  metadata = {
    serial-port-enable = local.serial-port-enable
    ssh-keys           = "${local.ssh-keys}"  
  }
  
}