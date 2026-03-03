###cloud vars
variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "vpc_name" {
  type        = string
  description = "VPC network"
}

variable "mass_zones" {
  type = list(object({
    vpc_name       = string
    subnet_name    = string
    cidr           = string
    route_table_id = string
  }))
}

