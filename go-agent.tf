resource "digitalocean_droplet" "go-agent-XX" {
  count = 2
  image = "centos-7-x64"
  name = "go-agent-0${count.index}"
  region = "nyc3"
  size = "1gb"
  private_networking = true
  ssh_keys = [
    "${var.ssh_fingerprint}"
  ]
  connection {
    user = "root"
    type = "ssh"
    host = self.ipv4_address
    private_key = "${file(var.pvt_key)}"
    timeout = "2m"
  }
  provisioner "remote-exec" {
    inline = [
      "sleep 25",
      "sudo yum -y update",
      "curl https://download.gocd.org/gocd.repo -o /etc/yum.repos.d/gocd.repo",
      "sudo yum install -y java-1.8.0-openjdk",
      "mkdir /var/go",
      "sudo yum install -y go-agent"
    ]
  }
  provisioner "file" {
   content     = "${data.template_file.goagentconf.rendered}"
   destination = "/etc/default/go-agent"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo /etc/init.d/go-agent start"
    ]
  }
}
