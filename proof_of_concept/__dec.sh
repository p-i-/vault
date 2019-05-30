#!/bin/bash

set -e
# Any subsequent(*) commands which fail will cause the shell script to exit immediately

# cd $(dirname "$0")/..

openssl \
	enc -aes-256-cbc \
	-d \
	-md sha512 \
	-pbkdf2 \
	-iter 1000 \
	-salt \
	-in "$1" \
	-out X.tar

rm -f X.tar.enc

rm -fr X/

tar -zxf X.tar X/

rm -f X.tar

rm -- "$0"

# leaves X/