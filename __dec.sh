#!/bin/bash

# decrypts VAULT_FILE into "$TMP_FOLDER"/vault/
VAULT_FILE=vault.raw
TMP_FOLDER=/tmp/

# quit on error
set -e

# switch to folder of script
cd $(dirname "$0")

# https://superuser.com/questions/1007647/bash-how-to-remove-bp-precmd-invoke-cmd-error/1168690
unset PROMPT_COMMAND

mkdir -p "$TMP_FOLDER"

# decrypt arg0 to /tmp/vault.tar
openssl \
	enc -aes-256-cbc \
	-d \
	-md sha512 \
	-pbkdf2 \
	-iter 1000 \
	-salt \
	-in "$VAULT_FILE" \
	-out "$TMP_FOLDER"/vault.tar

# extract from tar & delete tar
cd "$TMP_FOLDER"
tar -x -z -f vault.tar
rm vault.tar

#cd vault

# turn off history
#   https://unix.stackexchange.com/questions/10922/temporarily-suspend-bash-history-on-a-given-shell
set +o history

# rm -fr /tmp/vault/
# rm -f vault.enc
# rm -- "$0"				# rm this file

# leaves X/

# Start an interactive shell in the directory with
# HISTFILE set to /dev/null
( cd "vault" && HISTFILE=/dev/null bash )
