#!/usr/bin/env bash

FIRST_SUBNET=$(aws ec2 describe-subnets | jq -r '.Subnets[0].SubnetId' )
VPN_ID=$(aws ec2 describe-client-vpn-endpoints | jq -r '.ClientVpnEndpoints[0].ClientVpnEndpointId')
# add open route as well
aws ec2 associate-client-vpn-target-network \
  --client-vpn-endpoint-id "${VPN_ID}" \
  --subnet-id "${FIRST_SUBNET}"
