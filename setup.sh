#!/bin/bash

# * quit on error, print each command
# set -ex

INITIAL_PWD=$(pwd)

# Store script folder
SCRIPT_FOLDER=$(cd $(dirname $0) && pwd)  # (doesn't switch folders, tested!)


# * Make TEMP vault-unpacked folder & switch to it
TEMP=$(mktemp -d /tmp/vault.initial.XXXXXXXX)
rm -r "$TEMP"
mkdir "$TEMP"


# * Copy encryptor into it & make executable
cp "$SCRIPT_FOLDER"/enc.sh "$TEMP"/encrypt
chmod a+x "$TEMP"/encrypt

# * Copy DEcryptor into it, but __prefix it
#   __foo in a decrypted vault folder is a "Do Not Meddle" file
#   We'll have 3:
#     - __dec.sh
#     - __encrypted_folder.txt
#     - __password.txt
cp "$SCRIPT_FOLDER"/dec.sh "$TEMP"/__decrypt.sh


# Copy decrypt executable to /usr/local/bin
cp "$SCRIPT_FOLDER"/dec.sh /usr/local/bin/decrypt
chmod a+x                  /usr/local/bin/decrypt


# init.sh script
echo "# Upon decryption, commands here will execute"  > "$TEMP"/init.sh
echo "open ."                                        >> "$TEMP"/init.sh


# Sample secret data
mkdir "$TEMP"/files
echo bar > "$TEMP"/files/foo.txt


# * filepath for vault
read -e  -p "Enter vault file: "  encrypted_filepath

VAULT_DIR="$(dirname "$encrypted_filepath")"
VAULT_FILE=$(basename "$encrypted_filepath")
if [ ! -d "$VAULT_DIR" ]; then
	echo "Creating folder: $VAULT_DIR"
	mkdir -p "$VAULT_DIR"
fi

# get a clean absolute filepath, regardless of whether the user input a relative or absolute path
cd "$VAULT_DIR"
VAULT_DIR="$(pwd)"
RAW_FILEPATH="$VAULT_DIR"/"$VAULT_FILE"

# return to temp folder
echo "$RAW_FILEPATH" > "$TEMP"/__encrypted_filepath.txt


# * Password
echo "Enter password:"
read -rs password
echo "$password" > "$TEMP"/__password.txt


# * View TEMP
echo
echo "Created initial vault contents at $TEMP"
