#!/bin/bash

# * quit on error, print each command
set -ex

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


# NOTE:
#    We _don't_ quit on error with `set -e` -- see http://mywiki.wooledge.org/BashFAQ/105

# # switch to folder of script
# cd $(dirname "$0")

# RAW_FOLDER=$(pwd)

TEMP=$(mktemp -d /tmp/vault.XXXXXXXX)
mkdir -p "$TEMP"
# cd "$TEMP"

# decrypt to /tmp/vault.tar
openssl \
	enc -aes-256-cbc \
	-d \
	-md sha512 \
	-pbkdf2 \
	-iter 1000 \
	-salt \
	-in "$RAW_FILEPATH" \
	-out "$TEMP"/vault.tar

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

# # turn off history
# #   https://unix.stackexchange.com/questions/10922/temporarily-suspend-bash-history-on-a-given-shell
# set +o history

# rm -fr /tmp/vault/
# rm -f vault.enc
# rm -- "$0"				# rm this file

# leaves X/

# # Start an interactive shell in the directory with
# # HISTFILE set to /dev/null
# ( cd "vault" && HISTFILE=/dev/null bash )

# trap 'cd "$TEMP"' EXIT

echo Unpacked to: "$TEMP"

source "$TEMP"/init.sh