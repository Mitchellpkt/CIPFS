#!/bin/bash

# Say hi
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo "CIPFS downloader (by Isthmus)"
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Split the name ($1) into hash & key
# First 46 characters are IPFS address
# Remaining 32 characters are the symmetric decryption key
x=$1 # er4rur843tru43f8fyu7weyf7wyf7whfygewvuw6fft6wftewgfwegf6ewgfcweygwluhvyrewvgykr
FNAME=$(echo "$x" | cut -b 1-46)
KEY=$(echo "$x" | cut -b 47-$((47+32)))

# Download from to IPFS
IPFS_OUTPUT=`ipfs get $FNAME`
echo ... downloaded from IPFS
mv $FNAME $FNAME.pgp

# Decrypt the file 
gpg --yes --batch --passphrase=$KEY $FNAME.pgp
rm $FNAME.pgp
	
echo ~~~~~~~~~~~~~~
echo ... File retrieved and decrypted
echo $NEW_FILENAME

