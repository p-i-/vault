#!/bin/bash

# quit on error
set -e

# switch to folder of script
cd $(dirname "$0")

TEMP=$(mktemp -d /tmp/vault.XXXXXXXX)

rm -r "$TEMP"
mkdir "$TEMP"

cp enc.sh  "$TEMP"/enc
chmod a+x  "$TEMP"/enc

cp dec.sh  "$TEMP"/__dec.sh

# target folder (we offer to save dev-cycle time with ENCRYPTED_FOLDER.txt)
if [ -f ENCRYPTED_FOLDER.txt ]; then
	encrypted_folder=$(cat ENCRYPTED_FOLDER.txt)
else
	echo "Enter folder for encrypted vault file:"
	read -r encrypted_folder
fi

if [ -d "$encrypted_folder" ]; then
	echo "Folder already exists, aborting!"
	exit 1
fi

echo "$encrypted_folder" > "$TEMP"/__encrypted_folder.txt

# password
echo "Enter password:"
read -rs password
echo "$password" > "$TEMP"/__password.txt

# sample secret data
echo bar > "$TEMP"/foo.txt

echo "Creating initial vault contents:"
ls -l "$TEMP"

echo "Encrypting..."
"$TEMP"/enc SETUP
