#!/bin/bash

# decrypts VAULT_FILE into "$DEST_FOLDER"/vault/
VAULT_FILE=vault.raw
DEST_FOLDER=/tmp/

# quit on error
set -e

mkdir -p "$DEST_FOLDER"

cd $(dirname "$0")

# decrypt arg0 to /tmp/vault.tar
openssl \
	enc -aes-256-cbc \
	-d \
	-md sha512 \
	-pbkdf2 \
	-iter 1000 \
	-salt \
	-in "$VAULT_FILE" \
	-out "$DEST_FOLDER"/vault.tar

# extract from tar & delete tar
cd "$DEST_FOLDER"
tar -x -z -f vault.tar
rm -f vault.tar

cd vault

# turn off history
#   https://unix.stackexchange.com/questions/10922/temporarily-suspend-bash-history-on-a-given-shell
set +o history

# rm -fr /tmp/vault/
# rm -f vault.enc
# rm -- "$0"				# rm this file

# leaves X/