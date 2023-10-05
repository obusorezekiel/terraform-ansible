resource "aws_instance" "bastion_instance" {
  ami           = "ami-0bb4c991fa89d4b9b"
  instance_type = "t2.micro"
  key_name      = "ansible_key"

  subnet_id                   = aws_subnet.public_subnet_az1.id
  vpc_security_group_ids      = [aws_security_group.bastion-sg.id]
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    "Name" : "Bastion-Server"
  }
}

resource "aws_instance" "ansible_instance" {
  ami           = "ami-0261755bbcb8c4a84"
  instance_type = "t2.micro"
  key_name      = "ansible_key"

  subnet_id                   = aws_subnet.priv_subnet_az1.id
  vpc_security_group_ids      = [aws_security_group.ansible-sg.id]
  associate_public_ip_address = false
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    "Name" : "Ansible-Server"
  }
}

resource "aws_instance" "web_instance_1" {
  ami           = "ami-0bb4c991fa89d4b9b"
  instance_type = "t2.micro"
  key_name      = "ansible_key"

  subnet_id                   = aws_subnet.priv_subnet_az1.id
  vpc_security_group_ids      = [aws_security_group.webserver-sg.id]
  associate_public_ip_address = false
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    "Name" : "Web-Server-1"
  }
}


resource "aws_instance" "web_instance_2" {
  ami           = "ami-0bb4c991fa89d4b9b"
  instance_type = "t2.micro"
  key_name      = "ansible_key"

  subnet_id                   = aws_subnet.priv_subnet_az2.id
  vpc_security_group_ids      = [aws_security_group.webserver-sg.id]
  associate_public_ip_address = false
  lifecycle {
    create_before_destroy = true
  }

    tags = {
    "Name" : "Web-Server-2"
  }


}