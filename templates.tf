data "template_file" "goagentconf" {
  template = "${file("${path.module}/config/go-agent.tpl")}"

  vars = {
    go-server_priv_ip = "${digitalocean_droplet.go-server.ipv4_address_private}"
  }
}

data "template_file" "goserverconf" {
  template = "${file("${path.module}/config/go-server.tpl")}"

  vars = {
    go-server_priv_ip = "${digitalocean_droplet.go-server.ipv4_address_private}"
  }
}

data "template_file" "cruiseconfig" {
  template = "${file("${path.module}/config/cruise-config.xml.tpl")}"
}

data "template_file" "gocdnginxconfig" {
  template = "${file("${path.module}/config/gocd.ballenger.dev.conf.tpl")}"
}
