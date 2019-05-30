#!/bin/bash

VAULT_FILE=vault.raw

# quit on error
# TODO: 
#    http://mywiki.wooledge.org/BashFAQ/105
# set -e

# switch to folder of script
cd $(dirname "$0")

raw_folder="$pwd"

# https://superuser.com/questions/1007647/bash-how-to-remove-bp-precmd-invoke-cmd-error/1168690
# unset PROMPT_COMMAND

TEMP=$(mktemp -d /tmp/vault.XXXXXXXX)
mkdir -p "$TEMP"

# decrypt to /tmp/vault.tar
openssl \
	enc -aes-256-cbc \
	-d \
	-md sha512 \
	-pbkdf2 \
	-iter 1000 \
	-salt \
	-in "$VAULT_FILE" \
	-out "$TEMP"/vault.tar

if [ $? != 0 ]; then
	rm -r "$TEMP"
	echo openssl error (maybe bad password?), aborting!
	echo Hit ENTER to leave!
	read
	exit 1
fi

# extract from tar & delete tar
cd "$TEMP"
tar -xzf vault.tar
rm vault.tar

# update record of where encrypted vault file is stored
# so that when we we re-encrypt, we can replace the same file 
cat "$raw_folder" > __encrypted_folder.txt

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

open "$TEMP"