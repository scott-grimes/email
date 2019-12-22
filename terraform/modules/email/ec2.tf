resource aws_instance server {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name = "private-key"
  iam_instance_profile = var.name
  vpc_security_group_ids = local.security_groups
  subnet_id = local.subnet_id
  associate_public_ip_address = true

  tags = {
    Name = var.name
  }
  depends_on = [ aws_ebs_volume.persistant_storage ]
}

resource aws_ebs_volume persistant_storage {
  availability_zone = local.availability_zone
  size              = var.persistant_storage_size

  tags = {
    Name = "PersistantStorage",
  }
}

resource aws_key_pair deployer {
  key_name   = "private-key"
  public_key = file("${path.module}/../../../secrets/ssh_key.pub")
}
