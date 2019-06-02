#!/bin/bash

CURR_FOLDER=$(pwd)

# Store script folder
cd $(dirname "$0")
SCRIPT_FOLDER="$(pwd)"

# * Make TEMP vault-unpacked folder & switch to it
TEMP=$(mktemp -d /tmp/vault.initial.XXXXXXXX)
rm -r "$TEMP"
mkdir "$TEMP"
cd "$TEMP"


# * Copy encryptor into it & make executable
cp "$SCRIPT_FOLDER"/enc.sh enc
chmod a+x enc


# * Copy DEcryptor into it, but __prefix it
#   __foo in a decrypted vault folder is a "Do Not Meddle" file
#   We'll have 3:
#     - __dec.sh
#     - __encrypted_folder.txt
#     - __password.txt
cp "$SCRIPT_FOLDER"/dec.sh __dec.sh


# init.sh script
echo "# Upon decryption, commands here will execute" > init.sh
echo "open ." >> init.sh


# Sample secret data
mkdir vault
echo bar > vault/foo.txt


# * Path for vault
echo "Enter vault file:"
read -r encrypted_filepath

cd "$CURR_FOLDER"
DIR="$(dirname "$encrypted_filepath")"
if [ ! -d "$DIR" ]; then
	echo "Creating folder: $DIR"
	mkdir -p "$DIR"
fi
cd "$DIR"
RAW_FOLDER="$(pwd)"
RAW_FILE=$(basename "$encrypted_filepath")
RAW_FILEPATH="$RAW_FOLDER"/"$RAW_FILE"

# return to temp folder
cd "$TEMP"
echo "$RAW_FILEPATH" > __encrypted_filepath.txt


# * Password
echo "Enter password:"
read -rs password
echo "$password" > __password.txt


# * View TEMP
echo
echo "Creating initial vault contents at $(pwd):"
ls -lR


# # * Encrypt (& erase this folder)
# echo
# echo Hit ENTER to encrypt
# read

# echo "Encrypting..."
enc
