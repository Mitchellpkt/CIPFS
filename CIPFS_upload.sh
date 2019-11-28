#!/bin/bash

# Say hi
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo "CIPFS uploader (by Isthmus)"
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Generate  random 32 character alphanumeric string (upper and lowercase) 
# Code from https://gist.github.com/earthgecko/3089509
KEY=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
echo ... generated key

# Encrypt file
gpg --yes --batch --passphrase=$KEY -c $1
echo ... encrypted file

# Note... here's how to decrypt:
# gpg --yes --batch --passphrase=[Enter your passphrase here] filename.txt.gpg
	
# Upload to IPFS
IPFS_OUTPUT=`ipfs add $1.gpg`
echo ... uploaded to IPFS

IPFS_HASH=$(echo $IPFS_OUTPUT | awk '{print $2}') # Can I silence this?

echo ~~~~~~~~~~~~~~
echo CIPFS_address:
echo $IPFS_HASH$KEY

