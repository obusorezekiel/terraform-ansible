resource "tls_private_key" "terrafrom_generated_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {

  # Name of key: Write the custom name of your key
  key_name = "ansible_key"

  # Public Key: The public will be generated using the reference of tls_private_key.terrafrom_generated_private_key
  public_key = tls_private_key.terrafrom_generated_private_key.public_key_openssh

  # Store private key :  Generate and save private key(aws_keys_pairs.pem) in current directory 
  provisioner "local-exec" {
    command = <<-EOT
      echo '${tls_private_key.terrafrom_generated_private_key.private_key_pem}' > ansible_key.pem
      chmod 400 ansible_key.pem
    EOT
  }
}