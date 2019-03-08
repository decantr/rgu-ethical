.TL
Ethical Hacking Report
.AU
Shaw Eastwood
.AI
Robert Gordon University

.SH
Introduction
.PP
This document is broken into three sections and will detail the issues raised.
The first section is on the inherent security issues and weaknesses found in the
.B "WEP"
(Wired Equivalent Privacy) and the pressing need to upgrade the wireless infrastructure.
The second section will contain my proposal and test implementation of a solution to improve the security of the WEP network, through the use of an
.B "IDS" ,
a firewall and a VPN implementation such as
.B "WG"
(wireguard) to protect the network and the data.
Finally the last section will be a discussion of the ethics of white hat hacking and penetration testing.
Included will be the ethical framework and standards that ethical hackers operate on.

.NH
Wired Equivalent Privacy
\# TODO : Problems with RC4
\# TODO : WEP Encryption diagram
\# TODO : Explain flaws with the IV
\# TODO : Demonstration walkthrough of the process
.PP
The Wired Equivalent Privacy
.B "WEP" ) (
algorithm was introduced into the 802.11 wireless standard in 1997 and was purvasive until 802.11g in 2003 which introduced WPA.
As the name suggets it was intdended to provide packet level encryption for data being transmitted over the network.
The algorithm uses either a 40 bit or 104 bit secret key to produce either a 64 or 128 bit key used for the RC4 stream cipher.
However a number of issues became clear with the WEP algorithm during its lifespan.
.SH 2
Issues
.pp
The first issue was with the stream cipher,
.B "RC4" .
First devised in 1987 it used in a number of protocols such as
.B "WPA" ,
.B "SSL"
and
.b "TLS" .
The algorithm was, and still is, proprietary practicing security through obscurity althought the source code was posted in 1994.
The algorithm is remarkable for its simplicity, being only
.b "76"
lines of code, and for its speed, requiring only
.b "19"
instructions for each random value.
From then a number of issues were discovered such as Weak Keys in the Stream Cipher
\#.[weak Keys.]
which the the initial byte of the psuedo random stream was correlated with only a few bytes of the key, reducing work for an informed brute force.
RC4 persisted to be a dominant algorithm despite its flaws until in 2001 it was descovered that the intial bytes of the keysream were not random and thus revealing information about the secret key.
By capturing large numbers of packets analysing them the key could be discovered.
\#.[ weakness in key scheduling .[
.pp
The second major issue with WEP is the size of the Initialisation Vector (IV).
As WEP uses a Stream Cipher and not a Block Cipher it is imperative that the traffic key must not be reused.


.NH
Countermeasures

.NH
Ethical
