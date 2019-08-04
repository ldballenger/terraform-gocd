resource "digitalocean_droplet" "go-agent" {
  count = 1
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
      "sudo yum -y update",
      "curl https://download.gocd.org/gocd.repo -o /etc/yum.repos.d/gocd.repo",
      "sudo yum install -y java-1.8.0-openjdk",
      "mkdir /var/go",
      "chown go:go /var/go",
      "sudo yum install -y go-agent-19.5.0-9272"
    ]
  }
  provisioner "file" {
   content     = "${data.template_file.goagentconf.rendered}"
   destination = "/etc/default/go-agent"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo /etc/init.d/go-agent start",
      "sudo yum -y install unzip wget",
      "sudo yum -y install https://releases.hashicorp.com/vagrant/2.2.5/vagrant_2.2.5_x86_64.rpm",      
      "chown go:go /var/go",
      "wget -O /tmp/terraform_0.12.3_linux_amd64.zip https://releases.hashicorp.com/terraform/0.12.3/terraform_0.12.3_linux_amd64.zip",
      "sudo unzip /tmp/terraform_0.12.3_linux_amd64.zip -d /tmp/",
      "mv /tmp/terraform /usr/bin/terraform",
      "su - go -c 'vagrant plugin install vagrant-digitalocean'",
      "su - go -c 'vagrant plugin install vagrant-managed-servers'",
      "su - go -c 'vagrant plugin install vagrant-puppet-install'"
    ]
  }
}
