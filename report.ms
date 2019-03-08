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
The algorithm uses either a 40 bit or 104 bit secret key to produce either a 64 or 128 bit keystream using RC4.
.SH 2
Issues
.PP



.NH
Countermeasures

.NH
Ethical
