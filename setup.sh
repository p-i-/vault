#!/bin/bash

# switch to folder of script
cd $(dirname "$0")

SRC=$(pwd)

TEMP=$(mktemp -d /tmp/vault.XXXXXXXX)
rm -r "$TEMP"
mkdir "$TEMP"
cd "$TEMP"

cp "$SRC"/enc.sh enc
chmod a+x enc

cp "$SRC"/dec.sh __dec.sh

# target folder (we offer to save dev-cycle time with ENCRYPTED_FOLDER.txt)
if [ -f "$SRC"/ENCRYPTED_FOLDER.txt ]; then
	cp "$SRC"/ENCRYPTED_FOLDER.txt __encrypted_folder.txt
else
	echo "Enter (full path) folder for encrypted vault file:"
	read -r encrypted_folder
	echo "$encrypted_folder" > __encrypted_folder.txt
fi

if [ -d "$encrypted_folder" ]; then
	echo "Folder already exists, aborting!"
	exit 1
fi

# password
echo "Enter password:"
read -rs password
echo "$password" > __password.txt

# sample secret data
echo bar > foo.txt

echo "Creating initial vault contents:"
ls -l

echo "Encrypting..."
./enc SETUP
