variable "access_key" {}

variable "secret_access_key" {}

variable "main_vpc_cidr" {
    type   = string
    default = "10.0.0.0/16"
}

variable "public_subnet" {
    type = string
    default = "10.0.100.0/24"
}

variable "private_subnet" {
    type = string
    default = "10.0.200.0/24"
}