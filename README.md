![CIPFS_logo.png](CIPFS_logo.png)

# Confidential InterPlanetary File System
Confidentiality layer for IPFS decentralized storage

## Motivation
The current implementation of IPFS offers no privacy by default - files are uploaded in plaintext, and accessible to strangers' nodes and anybody with the hash.

CIPFS is an encryption layer on top of the existing IPFS. A random key is generated for each upload and appended to the name used to address files. For the sender and receiver, the UX is the same, except that the file reference is 78 characters long instead of 46 characters. However the nodes and surveilling entities can no longer access any of the files they are holding.

## Notation
Let `||` represent string concatenation, and `H(...)` represent IPFS's hash function

## Current System (no privacy)
We have a (plaintext) message or file `P` that we would like to store on IPFS. IPFS uses a global namespace with hash-based content-addressing, so we upload `P` and access it later by querying `H(P)`. 

There are several downsides
-  IPFS nodes can read `P`.
-  Anybody with `H(P)` can retrieve `P`.
-  Anybody with a file `P` can calculate `H(P)` and test whether the file was uploaded to IPFS previously.

^^ Note that these are largely features & design decisions rather than bugs. There are always privacy / convenience / scaling tradeoffs, and CIPFS will provide privacy (i.e. solve the 3 issues listed above) at the expense of a longer ID string and file deduplication.

## Confidential IPFS

### Upload Procedure 

Suppose Arlene wishes to share plaintext document `P` with Boris using IPFS. The CIPFS client performs this procedure:
1.  Generate random number `R` from a pseudorandom number generator.
2.  Symmetric encrypt `P` with `R` to generate ciphertext `C`.
3.  Upload `C` to IPFS (which will index it by `H(C)`).
4.  Display `CIPFS_ID`, which is `H(C) || R`.

### Download Procedure 

Now, Arlene gives the `CIPFS_ID` string containing the pointer and the key to Boris. Boris's CIPFS client performs this procedure:
1.  Break `CIPFS_ID` into `H(C)` and `R`.
2.  Query IPFS for `H(C)` and download `C`.
3.  Symmetric decrypt `C` using `R` to produce `P`.
4.  Display/save `P`.

### Notes
A few nice characteristics emerge
-  **No read access for infrastructure**: Only Arlene and Boris have `R` so the IPFS nodes cannot decrypt `C` to read `P`.
-  An attacker with `P` **cannot perform hypothesis** testing about file existance on IPFS, since without `R` they cannot generate `C` or `H(C)`.
-  Similarly, **censorship and surveillance resistance** arise since `R` introduces ciphertext unlinkability. Even if I am an attacker with `P` and total surveillance over IPFS, I cannot prove which encrypted files & transmissions are related.
-  Arlene can share a **linked commit** by posting `H(C)` to prove that that `C` exists on IPFS. She can later reveal `R` to unlock `P`.
-  Arlene can also share an **unlinked commit** by posting `H(H(C)||R)`, which is also `H(CIPFS_ID)`. Others cannot verify whether or not `C` exists on IPFS until Arlene reveals `CIPFS_ID`.
