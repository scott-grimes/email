# deploy to a random subnet

locals {
  availability_zone = data.aws_subnet.selected.availability_zone
  availability_zone_id = data.aws_subnet.selected.availability_zone_id
  subnet_id = data.aws_subnet.selected.id
}

data aws_vpc primary {
  default = true
}

data aws_subnet_ids primary {
  vpc_id = data.aws_vpc.primary.id
}

data aws_subnet selected {
  id    = sort(tolist(data.aws_subnet_ids.primary.ids))[random_integer.az_index.result]
}

resource random_integer az_index {
  min     = 0
  max     = length(data.aws_subnet_ids.primary.ids)
}

resource random_password password {
  length = 16
  special = true
  override_special = "_%@"
}
