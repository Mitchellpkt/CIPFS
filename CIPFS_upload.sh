#!/bin/bash

# Say hi
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo "CIPFS uploader (by Isthmus)"
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo
echo NOTICE: 
echo CIPFS provides OFF-DEVICE confidentiality to prevent the network or IPFS nodes from reading your files. CIPFS provides NO ON-DEVICE security, and should not be used if you suspect that your device may be compromised
echo

echo PROGRESS:
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

echo
echo ~~~~~~~~~~~~~~
echo CIPFS_address:
echo $IPFS_HASH$KEY
echo ~~~~~~~~~~~~~~
echo
