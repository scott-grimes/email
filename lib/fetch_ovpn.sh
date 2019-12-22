#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
function finish {
  rm -rf tmp.ovpn
}
trap finish EXIT

VPN_ID=$(aws ec2 describe-client-vpn-endpoints | jq -r '.ClientVpnEndpoints[0].ClientVpnEndpointId')
aws ec2 export-client-vpn-client-configuration --client-vpn-endpoint-id "${VPN_ID}" --output text > tmp.ovpn
CERT=$(sed -n '/-----BEGIN CERTIFICATE-----/,$p' "${SCRIPT_DIR}/../secrets/client.tld.crt")
KEY=$(cat "${SCRIPT_DIR}/../secrets/client.tld.key")

CERT="<cert>
${CERT}
</cert>"
KEY="<key>
${KEY}
</key>"

#LAST=$(sed -i '$d' tmp.ovpn)
echo "${CERT}" >> tmp.ovpn
echo "${KEY}" >> tmp.ovpn
echo "${LAST}" >> tmp.ovpn

mv tmp.ovpn "${SCRIPT_DIR}/../secrets/email.ovpn"
