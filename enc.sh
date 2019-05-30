#!/bin/bash

# Encrypts containing folder

# * quit on error
set -e

# * switch to folder of script
cd $(dirname "$0")

PASSWORD=$(cat __password.txt)
STORE_FOLDER=$(cat __encrypted_folder.txt)

# * force-create if not exist
mkdir -p "$STORE_FOLDER"

# * transfer enc's timestamp (mod'd, acc'd)
touch -r enc "$STORE_FOLDER"

# * write decoder executable to target folder
cp __dec.sh "$STORE_FOLDER"/dec
chmod a+x "$STORE_FOLDER"/dec

# * vault/ -> vault.tar
tar -czf ../vault.tar .
# if we are in folder /foo/bar/quux, retrieve "quux":
#     ##*/ removes all up to and including last slash
parent_dir="${PWD##*/}"
cd ..
rm -r "$parent_dir"

# * vault.tar -> vault.raw
openssl \
	enc -aes-256-cbc \
	-md sha512 \
	-pbkdf2 \
	-iter 1000 \
	-salt \
	-in vault.tar \
	-out vault.raw \
	-pass pass:"$PASSWORD"
unset PASSWORD
rm -f vault.tar

# extra-secure update!
if [ -f "$STORE_FOLDER"/vault.raw ]; then
	cp "$STORE_FOLDER"/vault.raw "$STORE_FOLDER"/vault.raw.backup
fi
cp vault.raw "$STORE_FOLDER"
rm vault.raw

# * transfer timestamp (mod'd, acc'd) from enc
# 	    https://unix.stackexchange.com/questions/118577/changing-a-files-date-created-and-last-modified-attributes-to-another-file
touch -r "$STORE_FOLDER" "$STORE_FOLDER"/vault.raw
# touch -m -a -t "$TIMESTAMP" "$STORE_FOLDER"
# touch -m -a -t "$TIMESTAMP" "$STORE_FOLDER"/vault.raw

# cd "$STORE_FOLDER"

# # * turn history back on
# #       https://unix.stackexchange.com/questions/10922/temporarily-suspend-bash-history-on-a-given-shell	
# set -o history

# if [[ $1 != SETUP ]]; then
#     # When exiting, terminate the parent shell
# 	trap 'kill -s HUP "$PPID"' EXIT
# fi

# trap 'cd ..' EXIT

echo Encrypting to "$STORE_FOLDER"/vault.raw
echo Execute "$STORE_FOLDER"/dec to decrypt!