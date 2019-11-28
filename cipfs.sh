#!/bin/bash

# Say hi
echo ~~~~~~~~~~~~~~~~~~
echo "CIPFS (by Isthmus)"
echo ~~~~~~~~~~~~~~~~~~
echo
echo NOTICE: 
echo CIPFS provides OFF-DEVICE confidentiality to prevent the network or IPFS nodes from reading your files. CIPFS provides NO ON-DEVICE security, and should not be used if you suspect that your device may be compromised
echo

#########
## upload
if [ "$1" == "add" ]; then

echo PROGRESS:
# Generate  random 32 character alphanumeric string (upper and lowercase) 
# Code from https://gist.github.com/earthgecko/3089509
KEY=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
echo ... generated key

# Encrypt file
gpg --yes --batch --passphrase=$KEY -c $2
echo ... encrypted $2

# Note... here's how to decrypt:
# gpg --yes --batch --passphrase=[Enter your passphrase here] filename.txt.gpg
	
# Upload to IPFS
IPFS_OUTPUT=`ipfs add $2.gpg`
rm $2.gpg
echo ... uploaded to IPFS

IPFS_HASH=$(echo $IPFS_OUTPUT | awk '{print $2}') # Can I silence this?

echo
echo ~~~~~~~~~~~~~~
echo CIPFS_address:
echo C$IPFS_HASH$KEY
echo ~~~~~~~~~~~~~~
echo

fi

	
#########
## download
if [ "$1" == "get" ]; then

# Split the name ($1) into hash & key
# First 46 characters are IPFS address
# Remaining 32 characters are the symmetric decryption key
x=$2 # er4rur843tru43f8fyu7weyf7wyf7whfygewvuw6fft6wftewgfwegf6ewgfcweygwluhvyrewvgykr
FNAME=$(echo "$x" | cut -b 2-47)
KEY=$(echo "$x" | cut -b 48-$((48+32)))

# Download from to IPFS
IPFS_OUTPUT=`ipfs get $FNAME`
echo ... downloaded from IPFS
mv $FNAME $FNAME.pgp

# Decrypt the file 
gpg --yes --batch --passphrase=$KEY $FNAME.pgp
rm $FNAME.pgp
mv $FNAME C$FNAME
	
echo ~~~~~~~~~~~~~~
echo ... File retrieved and decrypted
echo $NEW_FILENAME

fi
