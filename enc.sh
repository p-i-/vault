#!/bin/bash

# Encrypts containing folder

MASTER_PASSWORD=1234
STORE_FOLDER=/Users/pi/google-drive/vault/
TIMESTAMP=201905251430.41
# NOTE: 
#    Run ` enc.sh` and ` dec.sh X.tar.enc` -- i.e. with preceding space
#    (https://unix.stackexchange.com/questions/10922/temporarily-suspend-bash-history-on-a-given-shell)

# Any command-fail forces quit
set -e

# assume this file is /tmp/vault/enc.sh
cd $(dirname "$0")

# force-create if not exist
mkdir -p "$STORE_FOLDER"

# we precede with __ to remind user NOT to run as is. i.e. do enc.sh first!
cp __dec.sh "$STORE_FOLDER"/dec.sh

# if we are in /foo/bar/quux/, retrieve "quux"
parent_dir="${PWD##*/}"
# NOTE: $PWD == /foo/bar ; ##*/ = remove all till and with last slash, == bar

cd ..

# compress and delete original
tar -c -z -f vault.tar "$parent_dir"/
rm -fr "$parent_dir"

# encrypt and delete compressed
openssl \
	enc -aes-256-cbc \
	-md sha512 \
	-pbkdf2 \
	-iter 1000 \
	-salt \
	-in vault.tar \
	-out vault.raw \
	-pass pass:"$MASTER_PASSWORD"
rm -f vault.tar

# fudge timestamp:
# 	https://unix.stackexchange.com/questions/118577/changing-a-files-date-created-and-last-modified-attributes-to-another-file
touch -m -a -t "$TIMESTAMP" vault.raw

mv vault.raw "$STORE_FOLDER"

cd "$STORE_FOLDER"

# turn history back on
#   https://unix.stackexchange.com/questions/10922/temporarily-suspend-bash-history-on-a-given-shell	
set -o history
