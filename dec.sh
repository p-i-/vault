#!/bin/bash

# * Pass in file to decrypt
if [ -z "$1" ]; then
	echo "usage:"
	echo "   dec.sh path/to/my_vault_file"
	exit 1
fi

RAW_FOLDER="$(cd "$(dirname "$1")"; pwd)"
RAW_FILE=$(basename "$1")

echo $RAW_FOLDER
echo $RAW_FILE

RAW_FILEPATH="$RAW_FOLDER"/"$RAW_FILE"
if [ ! -f "$RAW_FILEPATH" ]; then
	echo "File not exists"
	exit 1
fi

TEMP=$(mktemp -d /tmp/vault.XXXXXXXX)
mkdir -p "$TEMP"

# decrypt to /tmp/vault.tar
openssl \
	enc -aes-256-cbc \
	-d \
	-md sha512 \
	-salt \
	-in "$RAW_FILEPATH" \
	-out "$TEMP"/vault.tar

# ^ Removed 2 options to make compatible with "LibreSSL 2.6.5" which ships with macOS:
#   -pbkdf2
#   -iter 1000

if [ $? != 0 ]; then
	rm -r "$TEMP"
	echo "openssl error (maybe bad password), aborting!"
	echo "Hit ENTER to quit!"
	read
	exit 1
fi

# extract from tar & delete tar
cd "$TEMP"
tar -xzf vault.tar
rm vault.tar

# update record of where encrypted vault file is stored
# so that when we we re-encrypt, we can replace the same file 
echo "$RAW_FILEPATH" > __encrypted_filepath.txt

echo Unpacked to: "$TEMP"

source "$TEMP"/init.sh