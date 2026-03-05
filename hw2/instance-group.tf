resource "yandex_compute_instance_group" "instance-group" {
    depends_on = [ yandex_iam_service_account.sa,
                   data.template_file.cloudinit-lamp,
                   yandex_resourcemanager_folder_iam_member.sa-editor ]
    name = "my-instance-group"

    instance_template {
        platform_id = var.vm_platform_id

        scheduling_policy {
            preemptible = true    
        }

        resources {
            cores         = var.vms_resources["web"].cores
            memory        = var.vms_resources["web"].memory
            core_fraction = var.vms_resources["web"].core_fraction
        }

        boot_disk {
            mode = "READ_WRITE"
            initialize_params {
                image_id = var.lamp_image_id
                size     = 4
            }
        }

        network_interface {
            network_id = module.vpc_dev.network_id
            subnet_ids = [ module.vpc_dev.subnet_id["public"] ]
            nat        = false
        }

        metadata = {
            user-data          = data.template_file.cloudinit-lamp.rendered
            serial-port-enable = 1
        }

        network_settings {
            type = "STANDARD"
        }
    }

    scale_policy {
        fixed_scale {
            size = 3
        }
    }

    allocation_policy {
        zones = [var.default_zone]
    }

    deploy_policy {
        max_unavailable = 3
        max_creating    = 3
        max_expansion   = 6
        max_deleting    = 3
    }

    health_check {
        healthy_threshold  = 3
        interval           = 20
        timeout            = 10
        unhealthy_threshold = 4
        http_options {
            path = "/"
            port = 80
        }
    }
    service_account_id  = yandex_iam_service_account.sa.id
}

resource "yandex_iam_service_account" "sa" {
  name = "account-instance-group"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-editor" { 
  depends_on = [ yandex_iam_service_account.sa ]
  folder_id = var.folder_id
  role      = "admin"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

data "template_file" "cloudinit-lamp" {
  template = file("./cloud-init-lamp.yml")

  vars = {
    ssh_public_key = file("~/.ssh/ssh-key-1756817743452.pub")
    storage_name   = yandex_storage_bucket.storage.bucket
    file           = local_file.picture.filename
  }
}
data "yandex_compute_instance_group" "group-info" {  
  instance_group_id = yandex_compute_instance_group.instance-group.id

  depends_on = [
    yandex_compute_instance_group.instance-group
  ]
}