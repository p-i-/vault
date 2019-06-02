#!/bin/bash

# Encrypts containing folder

# * quit on error
set -e

# * switch to folder of script
cd $(dirname "$0")

PASSWORD=$(cat __password.txt)

STORE_FILEPATH=$(cat __encrypted_filepath.txt)

STORE_FOLDER=$(dirname "$STORE_FILEPATH")
STORE_FILE=$(basename "$STORE_FILEPATH")

# * force-create if not exist
mkdir -p "$STORE_FOLDER"

# * transfer enc's timestamp (mod'd, acc'd)
touch -r enc "$STORE_FOLDER"

# * write decoder executable to target folder
cp __dec.sh "$STORE_FOLDER"/dec
chmod a+x "$STORE_FOLDER"/dec

# * vault/ -> vault.tar
tar -czf ../vault.tar .

# * `cd ..`
#      (to retrieve immediate containing folder-name, e.g. /foo/bar/quux -> "quux",
#         do ##*/ which removes all up to and including last slash)
parent_dir="${PWD##*/}"
cd ..

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

# * (securely copy) vault.raw -> "$STORE_FOLDER"/vault.raw
if [ -f "$STORE_FILEPATH" ]; then
	echo "Backing up original to ${STORE_FILEPATH}.backup"
	cp "$STORE_FILEPATH" "$STORE_FILEPATH".backup
fi
cp vault.raw "$STORE_FILEPATH"
rm vault.raw
rm -f "$STORE_FILEPATH".backup

# * transfer timestamp (mod'd, acc'd) from enc
# 	    https://unix.stackexchange.com/questions/118577/changing-a-files-date-created-and-last-modified-attributes-to-another-file
touch -r "$parent_dir"/enc "$STORE_FILEPATH"

rm -r "$parent_dir"

echo "Encrypting to $STORE_FILEPATH"
echo

# - - - - - - - 
# DEAD/OLD:
# # * turn history back on
# #       https://unix.stackexchange.com/questions/10922/temporarily-suspend-bash-history-on-a-given-shell	
# set -o history

# if [[ $1 != SETUP ]]; then
#     # When exiting, terminate the parent shell
# 	trap 'kill -s HUP "$PPID"' EXIT
# fi

# trap 'cd ..' EXIT
