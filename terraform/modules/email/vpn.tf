# terraform does not fully support client vpn endpoints yet.
# You must manually...
# 1) add an authorized ingress from 0.0.0.0/0
# 2) add a route to 0.0.0.0/0 via any of the (edge) subnets
#
# to use: download the openvpn config from aws console
# add the <cert> and <key> blocks from the client .crt and .key files

resource aws_acm_certificate server {
  private_key       = "${file("${path.module}/../../../secrets/server.key")}"
  certificate_body  = "${file("${path.module}/../../../secrets/server.crt")}"
  certificate_chain = "${file("${path.module}/../../../secrets/ca.crt")}"
  tags = {
    Name    = "VPN_SERVER_CERT",
  }

  # needed due to TF bug always wanting to recreate acm
  lifecycle {
    ignore_changes = all
  }
}

resource aws_acm_certificate client {
  private_key       = "${file("${path.module}/../../../secrets/client.tld.key")}"
  certificate_body  = "${file("${path.module}/../../../secrets/client.tld.crt")}"
  certificate_chain = "${file("${path.module}/../../../secrets/ca.crt")}"
  tags = {
    Name    = "VPN_CLIENT_CERT",
  }

  # needed due to TF bug always wanting to recreate acm
  lifecycle {
    ignore_changes = all
  }
}

resource aws_ec2_client_vpn_endpoint default {
  server_certificate_arn = aws_acm_certificate.server.arn
  client_cidr_block      = "10.1.0.0/16"
  split_tunnel = true
  connection_log_options {
    enabled = false
  }
  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = aws_acm_certificate.client.arn
  }
  tags = {
    Name = "my_vpn"
  }
}

#resource aws_ec2_client_vpn_network_association default {
#  for_each = toset(local.infra.subnet_ids_edge)
#  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.default.id
#  subnet_id              = each.value
#}
