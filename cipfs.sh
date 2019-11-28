#!/bin/bash

# Say hi
echo \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*
echo "    Confidential IPFS, v0.1"
echo @isthmus \(github.com\/mitchellpkt\)
echo \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*
echo
echo --------
echo NOTICES:
echo - CIPFS requires standard PGP and IPFS to be installed
echo - This implementation provides OFF-DEVICE security
echo - Feel free to improve, modify, and distribute CIPFS code \& protocol
echo  \ \ \(please include attribution and PR useful tweaks to origin repo\)
echo 
echo --------
echo PROGRESS:
echo

#########
## upload functionality
if [ "$1" == "add" ]; then

# Generate  random 32 character alphanumeric string (upper and lowercase) 
# Code from https://gist.github.com/earthgecko/3089509
KEY=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
echo ... generated key

# Encrypt file
gpg --yes --batch --passphrase=$KEY -c $2
echo ... encrypted $2
	
# Upload to IPFS
echo ... uploading to IPFS
echo
IPFS_OUTPUT=`ipfs add $2.gpg`
echo
rm $2.gpg

# Extract IPFS name
IPFS_HASH=$(echo $IPFS_OUTPUT | awk '{print $2}')

echo
echo \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*
echo Retrieve file with this CIPFS ticket:
echo C$IPFS_HASH$KEY
echo \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*
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
echo
echo ... downloaded from IPFS
mv $FNAME $FNAME.pgp

# Decrypt the file 
gpg --yes --batch --quiet --passphrase=$KEY $FNAME.pgp
rm $FNAME.pgp
mv $FNAME C$FNAME
	
echo ... decrypted file

echo
echo \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*
echo Retrieved file name:
echo C$FNAME
echo
echo Retrieved file SHA-256 sum:
VARI=$(sha256sum C$FNAME)
echo $VARI | head -n1 | awk '{print $1;}'
echo \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*
echo

fi
