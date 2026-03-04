###cloud vars
variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

variable "vms_resources" {
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
  }))
  default = {
    "web" = {
      cores         = 2
      memory        = 4
      core_fraction = 20
    },
  }
}

variable "vm_ubuntu_version" {
  type        = string
  default     = "ubuntu-2204-lts"
  description = "Distr"
}

variable "vm_platform_id" {
  type        = string
  default     = "standard-v3"
  description = "Platform id"
}

variable "nat_instance_ip" {
  type = string
  default = "192.168.10.254"
  description = "NAT instance IP"
}

variable "public_cidr" {
  type = string
  default = "192.168.10.0/24"
  description = "Public CIDR"
}

variable "private_cidr" {
  type = string
  default = "192.168.20.0/24"
  description = "Private CIDR"
}

variable "nat_instance_image_id" {
  type = string
  default = "fd80mrhj8fl2oe87o4e1"
  description = "NAT image ID"
}

variable "lamp_image_id" {
  type = string
  default = "fd827b91d99psvq5fjit"
  description = "NAT image ID"
}