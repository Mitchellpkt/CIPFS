#!/bin/bash

# Say hi
echo
echo \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*
echo "    Confidential IPFS, v0.1"
echo @isthmus \(github.com\/mitchellpkt\)
echo \*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*
echo
echo --------
echo NOTICES:
echo -  CIPFS requires standard PGP and IPFS to be installed
echo -  This implementation provides OFF-DEVICE security
echo -  Feel free to improve, modify, and distribute CIPFS code \& protocol
echo  \ \ \(please include attribution and PR useful tweaks to origin repo\)
echo -  Default behavior is deterministic key generation
echo  \ \ \i.e. symmetric encrypt with first 32 chars of SHA-256 sum, so that:
echo   \ \ identical files ==\> identical ciphertexts ==\> no IPFS bloat
echo   -  If your threat model is sensitive to IPFS storage hypothesis testing, 
echo   \ \ "then add --random-key flag to generate a unique one-time key"
echo 
echo --------
echo PROGRESS:
echo

#########
## upload functionality
if [ "$1" == "add" ]; then

# Random or deterministic key?
if [[ " $* " == *' --random-key '* ]]
then
# Generate  random 32 character alphanumeric string (upper and lowercase) 
# Code from https://gist.github.com/earthgecko/3089509
KEY=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
echo ... generated random key
else
FHASH=$(sha256sum $2)
echo hash is:
echo $FHASH
KEY=$(echo "$FHASH" | cut -b 1-32)
echo key is
echo $KEY
echo ... generated deterministic key
fi

# Encrypt file
gpg --yes --batch --passphrase=$KEY --cipher-algo AES256 -c $2
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
mv $FNAME $FNAME.gpg

# Decrypt the file 
gpg --yes --batch --quiet --cipher-algo AES256 --passphrase=$KEY $FNAME.gpg
rm $FNAME.gpg
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
