resource "digitalocean_droplet" "go-server" {
  image = "centos-7-x64"
  name = "go-server-00"
  region = "nyc3"
  size = "2gb"
  private_networking = true
  user_data = "${file("config/goserversetup.sh")}"
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
      "sudo yum -y install yum-utils",
      "sudo yum -y install epel-release",
      "yum-config-manager --enable rhui-REGION-rhel-server-extras rhui-REGION-rhel-server-optional",
      "curl https://download.gocd.org/gocd.repo -o /etc/yum.repos.d/gocd.repo",
      "sudo yum install -y java-1.8.0-openjdk",
      "mkdir /var/go",
      "sudo yum -y install go-server",
      "sudo yum -y install nginx",
      "sudo systemctl stop nginx",
      "sudo yum -y install certbot python2-certbot-nginx",
      "sudo certbot certonly -n --standalone -d gocd.ballenger.dev --agree-tos --email 'southpaw930@gmail.com' --no-eff-email",
      "ln -s /etc/letsencrypt/live/gocd.ballenger.dev/fullchain.pem /etc/ssl/ssl_cert.pem",
      "ln -s /etc/letsencrypt/live/gocd.ballenger.dev/privkey.pem /etc/ssl/ssl_key.pem",
      #"echo \"0 0,12 * * * python -c 'import random; import time; time.sleep(random.random() * 3600)' && certbot renew\" | sudo tee -a /etc/crontab > /dev/null"      
    ]
  }
  provisioner "file" {
   source     = "ssl/ssl-dhparams.pem"
   destination = "/etc/ssl/dhparam.pem"
  }   
  provisioner "file" {
   content     = "${data.template_file.cruiseconfig.rendered}"
   destination = "/etc/go/cruise-config.xml"
  }  
  provisioner "file" {
   content     = "${data.template_file.gocdnginxconfig.rendered}"
   destination = "/etc/nginx/nginx.conf"
  }
  provisioner "remote-exec" {
    inline = [
      "chown go:go /etc/go/cruise-config.xml",
      "chmod 664 /etc/go/cruise-config.xml",
      "sudo /etc/init.d/go-server start",
      "setsebool -P httpd_can_network_connect 1",
      "systemctl restart nginx",
    ]
  }  
}

