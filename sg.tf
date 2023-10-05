resource "aws_security_group" "alb-sg" {
  name        = "alb-sg"
  description = "Allow access to ALB from internet"
  vpc_id      = aws_vpc.dev-vpc.id

  ingress {
    description = "https for ALB"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "http for ALB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}

resource "aws_security_group" "bastion-sg" {
  name        = "bastion-sg"
  description = "Bastion SG"
  vpc_id      = aws_vpc.dev-vpc.id

  ingress {
    description = "ssh for bastion"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "ansible-sg" {
  name        = "ansible-sg"
  description = "ansible SG"
  vpc_id      = aws_vpc.dev-vpc.id

  ingress {
    description     = "ssh for ansible"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion-sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "webserver-sg" {
  name        = "webserver-sg"
  description = "Webserver-SG"
  vpc_id      = aws_vpc.dev-vpc.id

  ingress {
    description     = "ssh for webserver"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.ansible-sg.id]
  }

  ingress {
    description     = "https for ALB"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.alb-sg.id]
  }

  ingress {
    description     = "http for ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb-sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

