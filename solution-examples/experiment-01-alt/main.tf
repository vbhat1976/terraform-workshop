module "server" {
  source = "./modules/server"
}

resource "null_resource" "always-run-provider-script" {
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = module.server.instance_public_ip
      user        = "ubuntu"
      private_key = module.server.private_key
    }
    scripts = ["./provisioner.sh"]
  }
}
