#!/bin/bash

# Say hi
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo "CIPFS downloader (by Isthmus)"
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Split the name ($1) into hash & key
# First 46 characters are IPFS address
# Remaining 32 characters are the symmetric decryption key
FULLNAME = $1
FILEHASH = echo ${FULLNAME:0:45}
KEY = echo ${FULLNAME:46:77}

#NEED CODE HERE

# Download from to IPFS
IPFS_OUTPUT=`ipfs get ....`
NEW_FILENAME = #need code
echo ... downloaded from IPFS

# Decrypt the file 
# gpg --yes --batch --passphrase=$KEY $NEW_FILENAME
	

echo ~~~~~~~~~~~~~~
echo ... File retrieved and decrypted
echo $NEW_FILENAME

