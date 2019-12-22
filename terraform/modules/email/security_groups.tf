locals {
  email_ports = {
    "recieve_email" = 25,
    "ssl_client_email_submission" = 465,
    "tls_client_email_submission" = 587,
    "imap" = 143,
    "imap_ssl" = 993,
    "pop3" = 110,
    "pop3_ssl" = 995,
  }

    security_groups = [
        aws_security_group.email.id,
        aws_security_group.ssh_internal.id
    ]

}

resource aws_security_group email {
  name   = "email"
  vpc_id = data.aws_vpc.primary.id

  dynamic ingress {
    for_each = local.email_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      description = ingress.key
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic egress {
    for_each = local.email_ports
    content {
      from_port   = egress.value
      to_port     = egress.value
      description = egress.key
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags = {
    Name = "email"
  }


}


resource aws_security_group ssh_internal {
  name   = "internal_ssh"
  vpc_id = data.aws_vpc.primary.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = [data.aws_vpc.primary.cidr_block]
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = [data.aws_vpc.primary.cidr_block]
  }

  tags = {
    Name = "internal_ssh"
  }

}
