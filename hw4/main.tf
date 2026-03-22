module "vpc_dev" {
  source       = "./vpc_dev"
  vpc_name     = var.vpc_name
  cloud_id     = var.cloud_id
  folder_id    = var.folder_id
  mass_zones   = [
    { 
        vpc_name       = var.default_zone, 
        subnet_name    = "public0", 
        cidr           = var.public_cidr0, 
        route_table_id = "" 
    },
    { 
        vpc_name       = var.zone_b, 
        subnet_name    = "public1", 
        cidr           = var.public_cidr1, 
        route_table_id = "" 
    },
    { 
        vpc_name       = var.zone_d, 
        subnet_name    = "public2", 
        cidr           = var.public_cidr2, 
        route_table_id = "" 
    },
    { 
        vpc_name       = var.default_zone, 
        subnet_name    = "private0", 
        cidr           = var.private_cidr0, 
        route_table_id = yandex_vpc_route_table.lab-rt-a.id 
    },
    { 
        vpc_name       = var.zone_b, 
        subnet_name    = "private1", 
        cidr           = var.private_cidr1, 
        route_table_id = yandex_vpc_route_table.lab-rt-a.id 
    },    
  ]
}