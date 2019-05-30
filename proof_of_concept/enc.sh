#!/bin/bash

# NOTE: 
#    Run ` enc.sh` and ` dec.sh X.tar.enc` -- i.e. with preceding space
#    (https://unix.stackexchange.com/questions/10922/temporarily-suspend-bash-history-on-a-given-shell)

set -e
# Any subsequent(*) commands which fail will cause the shell script to exit immediately

cd $(dirname "$0")

cp __dec.sh ../dec.sh

# F="${PWD##*/}"
# echo "$F"
#
# NOTE: $PWD == /foo/bar ; ##*/ = remove all till and with last slash, == bar

cd ..

tar -czf X.tar X/

rm -fr X/

openssl \
	enc -aes-256-cbc \
	-md sha512 \
	-pbkdf2 \
	-iter 1000 \
	-salt \
	-in X.tar \
	-out X.tar.enc \
	-pass pass:abcd

rm -f X.tar

# leaves X.tar.enc

# https://unix.stackexchange.com/questions/118577/changing-a-files-date-created-and-last-modified-attributes-to-another-file
touch -m -a -t 201905251430.41 X.tar.enc
