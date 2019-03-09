.TL
Flaws In The WEP Protocol And Proposal For Improving Security Of The WEP Network
.AU
Shaw Eastwood
.AI
Robert Gordon University
.DA
.AB
A discussion of the issues inherent in the WEP protocol and the RC4 cipher stream it uses.
A discussion of potential countermeasures for a network that must deploy a WEP network and the implementation of a IDS system. Finally a discussion of the ethics of the field.
.AE
.SH
Introduction
.PP
This document is broken into three sections and will detail the issues raised.
The first section is on the inherent security issues and weaknesses found in the Wired Equivalent Privacy
.B "WEP" ) (
and the pressing need to upgrade the wireless infrastructure.
The second section will contain my proposal and test implementation of a solution to improve the security of the WEP network, through the use of an Intrusion Detection System
.B "IDS" ), (
a firewall and a Virtual Private Network
.B "VPN" ) (
implementation such as WireGuard
.B "WG" ) (
to protect the network and the data.
Finally the last section will be a discussion of the ethics of white hat hacking and penetration testing.
Included will be the ethical framework and standards that ethical hackers operate on.

.NH
Wired Equivalent Privacy
\# TODO : Problems with RC4
\# TODO : WEP Encryption diagram
\# TODO : Explain flaws with the IV
\# TODO : Demonstration walk through of the process
.PP
The WEP algorithm was introduced with the IEEE 802.11 wireless standard in 1997 which was an extension to the 802 Local Area Network
.B "LAN" ) (
protocols to add Wireless functionality
.B "WLAN" ). (
As the name suggests it was intended to provide a similar level of confidentiality to the wireless network as was already present on existing LAN's.
The protocol implements this by providing packet level encryption for data being transmitted over the network.
The algorithm creates either a 64 or 128 bit key comprising of a 24 bit Initialisation Vector
.B "IV" ) (
and either a 40 or 104 bit Pre Shared Key.
This restriction allowed for either 5 or 13 ASCII character passwords respectively (or 10 or 26 hexadecimal strings).
WEP was pervasive until major security flaws were discovered and the 802.11i revision was issued which introduced Wi-Fi Protected Access
.B "WPA" ). (
However a number of issues became clear with the WEP algorithm during its lifespan.
.SH 2
Issues
.PP
The first issue was with the stream cipher,
.B "RC4" .
First devised in 1987 it used in a number of protocols such as
.B "WPA" ,
.B "SSL"
and
.B "TLS" .
The algorithm was, and still is, proprietary practicing security through obscurity although the source code was posted in 1994.
The algorithm is remarkable for its simplicity, being only 76 lines of code, and for its speed, requiring only 19 instructions for each random value.
From then a number of issues were discovered such as Weak Keys in the Stream Cipher
\#.[weak keys.]
which the initial byte of the pseudorandom stream was correlated with only a few bytes of the key, reducing work for an informed brute force.
RC4 persisted to be a dominant algorithm despite its flaws until in 2001 it was discovered that the initial bytes of the key stream were not random and thus revealing information about the secret key.
By capturing large numbers of packets analysing them the key could be discovered.
\#.[ weakness in key scheduling .[
.PP
The second major issue with WEP is the size of the Initialisation Vector
.B "IV" ). (
As WEP uses a Stream Cipher and not a Block Cipher it is imperative that the traffic key not be reused.
However with a 24 bit IV the possible permutations are only 2
\*{24\*}
or 16,777,216 significantly increasing the likelihood of key repetition to %50 after only 300,000 packets.
Further, with an aggressive method of replaying Address Resolution Protocol
.B "ARP" ) (
requests a sufficient number of packets to retrieve the secret key can be obtained in under a minute.
\#.[ breaking 104 bit WEP ].


.NH
Countermeasures


.NH
Ethical
