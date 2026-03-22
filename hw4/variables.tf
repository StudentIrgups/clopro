###cloud vars
variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "password" {
  type        = string
  description = "password for db"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "zone_b" {
  type        = string
  default     = "ru-central1-b"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "zone_d" {
  type        = string
  default     = "ru-central1-d"
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

variable "nat_instance_ip" {
  type = string
  default = "192.168.10.254"
  description = "NAT instance IP"
}

variable "public_cidr0" {
  type = string
  default = "192.168.10.0/24"
  description = "Public CIDR 10"
}

variable "public_cidr1" {
  type = string
  default = "192.168.11.0/24"
  description = "Public CIDR 11"
}

variable "public_cidr2" {
  type = string
  default = "192.168.12.0/24"
  description = "Public CIDR 12"
}

variable "private_cidr0" {
  type = string
  default = "192.168.20.0/24"
  description = "Private CIDR"
}

variable "private_cidr1" {
  type = string
  default = "192.168.21.0/24"
  description = "Private CIDR"
}