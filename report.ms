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
\# TODO : WEP Encryption diagram
\# TODO : Demonstration walk through of the process
\# TODO : Mention WPA
\# TODO : Mention WPA's stalting of key with SSID
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
\#.SH 2 "Issues"
.SH 3
Rivest Cipher 4 (RC4)
.PP
The first issue described is actually an issue with the stream cipher used Rivest Cipher 4
.B "RC4" ). (
The stream cipher was first devised in 1987 it was used in a number of predominantly protocols up until 2015 such as
.B "WPA"
(version 1),
.B "SSL"
and
.B "TLS" .
The algorithm was, and still is, a proprietary algorithm practicing "security through obscurity" however an anonymous user posted the source code in 1994 to a usenet.
Though despite creating an identical output it was never confirmed to be the actual source code and is thus reffered to as "Alleged RC4"
.B "ARC4" .
The algorithm is remarkable for its simplicity, being only 76 lines of code, and for its speed, requiring only 19 instructions for each random value.
The algorithm takes an input of an IV and a Key, the algorithm then repeats the key until it has a 256 byte key.
This key is then "permutated" by iterating through the key and swapping the bytes indices and then used to generate a keystream.
.SH 3
RC4 Issues
.PP
One minor flaw that exists with this lies in the first 256 bytes of the resulting RC4 keystream being disproportionally non random, thus in most implementations of RC4 the first ~256 bytes are discarded.
This is
.B "not"
the case in WEP and thus the initial output of the stream is susceptible.
\#.[ Andrew Roos .]
.PP
A second flaw that reveals that the relationship between the first 8 bytes of the key, if chosen correctly, can inform on the remaining half of the key.
This flaw is not an issue in the SSL implementation of RC4 as SSL uses MD5 to hash the key before it used.
\#.[ David Wagner .]
.SH 2
WEP Issues
.PP
These issues in RC4 can be avoided as described, discarding the initial ~256 byte output and hashing the key before using it however WEP implements neither of these.
In fact WEP's implementation makes the situation worse by regenerating the keystream, with a fresh IV, for each packet, meaning that it is very easy to capture a wide variety of IV's.
Further the 802.11 protocol has a number of static plaintext elements that it embeds into the packet header.
These known bytes allow the attacker to make informed assumptions about the ciphertext packets being examined.
.PP
In 2001 it was discovered in the Fluhrer, Mantin & Shamir
.B "FMS" ) (
attack that certain IV's had a predictable resulting output.
Since the IV used is known, as it is transmitted in plaintext with the ciphertext, a wide range of IV's can be quickly obtained.
An attacker can then use a voting system to guess at the a next byte of the key, repeatedly, until the entire secret key has been revealed.
\#.[ Weakness in Key Scheduling Algorithm .]
.QP
.RS
.I
It is worth mentioning that the FMS attack is a vulnerability in RC4. However it is due to the nature of the WEP implementation of RC4 that makes it viable.
.RE
.R
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
.SH 2
General WEP Issues
.PP
Of the issues described above, the largest issue with 802.11 (WLAN) is the fact its wireless.
Packets sent across the network can be picked up by anyone sitting within range of the Access Point
.B "AP" ) (
which is a major disadvantage over the wired 802 (LAN) which requires physical access.
.PP
An attacker wishing to do an aggressive attack on an 802.11b AP, 11 Mbit/s throughput, assuming the standard Maximum Transmission Unit
.B "MTU" ) (
and a consistent network connection would be able to capture the full range of possible IV's in 5 hours.
This was discovered to be unnecessary in as an attack success rate of 50% can be achieved after capturing only 40,000 packets (increasing to 95% at 85,000 packets).
The 802.11g standard introduced the 54 MBit/s (22 Mbit average maximum throughput) specification, a major step up in bandwidth and reducing the time to retrieve all possible IV's within an hour.
This even further reduced the time taken in the average aggressive attack to less than a minute.
\#.[ Breaking WEP in less than 60 seconds .]
.PP
Further, the use of the static PSK for encrypting the traffic means that an attacker can capture a large amount of traffic quickly and then disconnect from the network and break the encryption offline.
This is less of an issue as the previous one as the time taken to break WEP is so small.

.NH
Countermeasures
.PP
A number of countermeasures can be used to combat the impotence of WEP.
The primary tool we are going to use is a VPN.
A VPN will encrypt all of the traffic travelling through the tunnel itself meaning that we are no longer handing WEP a plaintext message but instead ciphertext from our VPN implementation of choice.
This means that if (or when) the WEP security is broken, the data will still be unreadable by an attacker.
.SH 2
VPN
.PP


.NH
Ethical
