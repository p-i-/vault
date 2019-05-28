#!/bin/bash

# quit on error
set -e

# switch to folder of script
cd $(dirname "$0")

rm -rf /tmp/vault

mkdir -p /tmp/vault

cp   enc.sh  /tmp/vault
cp __dec.sh  /tmp/vault
cp   foo.txt /tmp/vault

chmod a+x /tmp/vault/enc.sh
chmod a+x /tmp/vault/__dec.sh

echo "Enter password:"
# raw, silent
read -r -s password
echo "$password" > /tmp/vault/__password.txt

/tmp/vault/enc.sh SETUP
