resource "digitalocean_droplet" "go-server-00" {
  image = "centos-7-x64"
  name = "go-server-00"
  region = "nyc3"
  size = "1gb"
  private_networking = true
  user_data = "${file("config/goserversetup.sh")}"
  ssh_keys = [
    "${var.ssh_fingerprint}"
  ]
  connection {
    user = "root"
    type = "ssh"
    private_key = "${file(var.pvt_key)}"
    timeout = "2m"
  }
}
