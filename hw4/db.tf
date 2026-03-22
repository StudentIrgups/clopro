resource "yandex_mdb_mysql_cluster" "mysql" {
  name = "cluster"
  environment = "PRESTABLE"
  network_id =  module.vpc_dev.network_id
  version = "8.0"

  resources {
    resource_preset_id = "b1.medium"
    disk_type_id       = "network-ssd"
    disk_size          = 20
  }

  dynamic "host" {
    for_each = { for k in module.vpc_dev.subnet_id: k.name => k if strcontains(k.name, "private") }
      content {
        zone      = host.value.zone
        subnet_id = host.value.id
      }
  }

  backup_window_start {
    hours   = 23
    minutes = 59
  }

  maintenance_window {
    type = "ANYTIME"
  }

  deletion_protection = false // надоело удалять через web
}

resource "yandex_mdb_mysql_database" "netology-db" { 
  depends_on = [ yandex_mdb_mysql_cluster.mysql ]
  name       = "netology-db"
  cluster_id = yandex_mdb_mysql_cluster.mysql.id
}

resource "yandex_mdb_mysql_user" "user-netology" {
  cluster_id = yandex_mdb_mysql_cluster.mysql.id
  name       = "netology"
  password   = var.password

  permission {
    database_name = yandex_mdb_mysql_database.netology-db.name
    roles         = ["ALL"]
  }
}