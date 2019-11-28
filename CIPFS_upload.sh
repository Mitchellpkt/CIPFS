#!/bin/bash

echo CIPFS uploader

# bash generate random 32 character alphanumeric string (upper and lowercase) 
# Code from https://gist.github.com/earthgecko/3089509
NEW_UUID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

echo symmetric $1 $1.pgp

gpg --yes --batch --passphrase=$NEW_UUID -c $1

echo key = $NEW_UUID
