data "template_file" "goagentconf" {
  template = "${file("${path.module}/config/go-agent.tpl")}"

  vars = {
    go-server_priv_ip = "${digitalocean_droplet.go-server-00.ipv4_address_private}"
  }
}
