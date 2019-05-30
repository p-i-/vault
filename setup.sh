#!/bin/bash

# quit on error
set -e

# switch to folder of script
cd $(dirname "$0")

TEMP=$(mktemp -d /tmp/vault.XXXXXXXX)

rm -rf "$TEMP"

mkdir -p "$TEMP"

cp   enc.sh  "$TEMP"/enc
chmod a+x "$TEMP"/enc

cp dec.sh  "$TEMP"/__dec.sh

# sample secret data
echo bar > "$TEMP"/foo.txt

# to save dev-cycle time...
if [ -f ENCRYPTED_FOLDER.txt ]; then
	cp ENCRYPTED_FOLDER.txt "$TEMP"/__encrypted_folder.txt
else

	echo "Enter folder for encrypted vault file:"
	read -r encrypted_folder
	echo "$encrypted_folder" > "$TEMP"/__encrypted_folder.txt
fi

echo "Enter password:"
# raw, silent
read -r -s password
echo "$password" > "$TEMP"/__password.txt

ls -l "$TEMP"

"$TEMP"/enc SETUP
