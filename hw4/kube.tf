resource "yandex_iam_service_account" "k8s-sa" {
  name = "k8s-service-account"
  folder_id = var.folder_id
}

resource "yandex_resourcemanager_folder_iam_member" "k8s-editor" {
  folder_id = var.folder_id
  role = "editor"
  member = "serviceAccount:${yandex_iam_service_account.k8s-sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s-puller" {
  folder_id = var.folder_id
  role = "container-registry.images.puller"
  member = "serviceAccount:${yandex_iam_service_account.k8s-sa.id}"
}

resource "yandex_kms_symmetric_key" "key-a" {
  name              = "symetric-key"
  description       = "Key for netology"
  default_algorithm = "AES_128"
  rotation_period   = "8760h" 
}

resource "yandex_kubernetes_cluster" "regional-cluster" {
  name       = "regional-k8s"
  network_id = module.vpc_dev.network_id

  master {
    dynamic master_location {
      for_each = { for k in module.vpc_dev.subnet_id: k.name => k if strcontains(k.name, "public")}
        content {
          zone      = master_location.value.zone
          subnet_id = master_location.value.id
        }
    }
    version   = "1.31"
    public_ip = true
  }

  service_account_id      = yandex_iam_service_account.k8s-sa.id
  node_service_account_id = yandex_iam_service_account.k8s-sa.id

  kms_provider {
    key_id = yandex_kms_symmetric_key.key-a.id
  }
}

resource "yandex_kubernetes_node_group" "node-group" {
  cluster_id = yandex_kubernetes_cluster.regional-cluster.id
  name       = "node-group"

  instance_template {
    platform_id = "standard-v3"
    resources {
      memory = 4
      cores  = 2
    }
    boot_disk {
      type = "network-hdd"
      size = 30
    }
    network_interface {
      subnet_ids = [ for k in module.vpc_dev.subnet_id : 
        k.id if strcontains(k.name, "public")
      ]      
    }
    metadata = {
        serial-port-enable = 1
        user-data          = data.template_file.cloudinit.rendered
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    dynamic "location" {
        for_each = { for k in module.vpc_dev.subnet_id: k.name => k if strcontains(k.name, "public")}
        content {
            zone  = location.value.zone
        }
    }   
  }
}

data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")

  vars = {
    ssh_public_key = file("~/.ssh/ssh-key-1756817743452.pub")
  }
}

data "yandex_compute_instance_group" "data-instance-group" {
  instance_group_id = yandex_kubernetes_node_group.node-group.instance_group_id
}