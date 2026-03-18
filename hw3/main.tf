module "vpc_dev" {
  source       = "./vpc_dev"
  vpc_name     = var.vpc_name
  cloud_id     = var.cloud_id
  folder_id    = var.folder_id
  mass_zones   = [
    { vpc_name = var.default_zone, subnet_name = "public", cidr = var.public_cidr, route_table_id = "" }
  ]
}