variable "do_token" {}
variable "pub_key" {}
variable "pvt_key" {}
variable "ssh_fingerprint" {}
variable "availability_zone_names" {
  type    = list(string)
  default = ["nyc3"]  
}

provider "digitalocean" {
  token = "${var.do_token}"
}

