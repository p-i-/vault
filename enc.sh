#!/bin/bash

# Encrypts containing folder

SCRIPT_FOLDER=$(cd $(dirname $0) && pwd)  # (doesn't switch folders, tested!)

PASSWORD=$(cat "$SCRIPT_FOLDER"/__password.txt)

STORE_FILEPATH=$(cat "$SCRIPT_FOLDER"/__encrypted_filepath.txt)
STORE_FOLDER=$(dirname "$STORE_FILEPATH")
STORE_FILE=$(basename "$STORE_FILEPATH")


# * force-create if not exist
mkdir -p "$STORE_FOLDER"


# * write decoder executable to target folder
cp "$SCRIPT_FOLDER"/__decrypt.sh "$STORE_FOLDER"/decrypt
chmod a+x                        "$STORE_FOLDER"/decrypt


# * vault/ -> vault.tar
cd "$SCRIPT_FOLDER"
tar -czf ../vault.tar .


# * vault.tar -> vault.raw
openssl \
	enc -aes-256-cbc \
	-md sha512 \
	-pbkdf2 \
	-iter 1000 \
	-salt \
	-in  "$SCRIPT_FOLDER"/../vault.tar \
	-out "$SCRIPT_FOLDER"/../vault.raw \
	-pass pass:"$PASSWORD"
unset PASSWORD
rm -f "$SCRIPT_FOLDER"/../vault.tar


# * (securely copy) vault.raw -> "$STORE_FOLDER"/vault.raw
if [ -f "$STORE_FILEPATH" ]; then
	echo "Backing up original to ${STORE_FILEPATH}.backup"
	cp "$STORE_FILEPATH" "$STORE_FILEPATH".backup
fi
cp "$SCRIPT_FOLDER"/../vault.raw "$STORE_FILEPATH"
rm "$SCRIPT_FOLDER"/../vault.raw
rm -f "$STORE_FILEPATH".backup


# * transfer timestamp (mod'd, acc'd) from enc
# 	    https://unix.stackexchange.com/questions/118577/changing-a-files-date-created-and-last-modified-attributes-to-another-file
touch -r "$SCRIPT_FOLDER"/encrypt "$STORE_FILEPATH"


rm -r "$SCRIPT_FOLDER"

echo "Encrypted to $STORE_FILEPATH"
echo

read -rsn 1 -p "Press any key to continue..." < /dev/tty  # https://mywiki.wooledge.org/BashFAQ/065

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
