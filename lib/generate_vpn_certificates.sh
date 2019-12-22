#!/usr/bin/env bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CUR_DIR="${PWD}"
TEMP_DIR=$(mktemp)
function finish {
  rm -rf "${TEMP_DIR}"
  cd "${CUR_DIR}"
}
trap finish EXIT

DEST_DIR="${SCRIPT_DIR}/../secrets/"
cd "${SCRIPT_DIR}/easyrsa"
rm -rf pki
./easyrsa init-pki
echo "mydomain" | ./easyrsa build-ca nopass
./easyrsa build-server-full server nopass
./easyrsa build-client-full client.tld nopass

cp pki/ca.crt $DEST_DIR
cp pki/issued/server.crt $DEST_DIR
cp pki/private/server.key $DEST_DIR
cp pki/issued/client.tld.crt $DEST_DIR
cp pki/private/client.tld.key $DEST_DIR
rm -rf pki
