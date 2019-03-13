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
.B "SE" ) (
to protect the network and the data.
Finally the last section will be a discussion of the ethics of white hat hacking and penetration testing.
Included will be the ethical framework and standards that ethical hackers operate on.

.NH
Wired Equivalent Privacy
\# TODO : WEP Encryption diagram
\# TODO : Demonstration walk through of the process
\# TODO : Mention WPA
\# TODO : Mention WPA's stalting of key with SSID
\# TODO : WEP Authentication
\# TODO : Issues with CRC-32
.PP
The WEP algorithm was introduced with the IEEE 802.11 wireless standard in 1997 which was an extension to the 802 Local Area Network
.B "LAN" ) (
protocols to add Wireless functionality
.B "WLAN" ). (
As the name suggests it was intended to provide a similar level of confidentiality to the wireless network as was already present on existing LAN's.
The protocol implements this by providing packet level encryption for data being transmitted over the network provided by Rivest Cipher 4
.B "RC4" ) (
and the Cyclic Redundancy Check 32
.B "CRC-32" ) (
to ensure packet integrity.
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
Proposal
.PP
To improve the security of the highly vulnerable WEP section of the Greenshoots Ltd. a number of options exsist.
The primary tool we are going to use for this is a VPN, which will create another layer of security on the network.
It does this by constructing a "tunnel" in which the "private network" exists, this can be done over any network from a LAN to the public internet.
A VPN will encrypt all of the traffic travelling through the tunnel itself meaning that we are no longer handing WEP a plaintext message but instead ciphertext from our VPN implementation of choice.
The network is only accessible once a user has passed an authentication check in the form of either a Username and Password or in the form of
This means that if (or when) the WEP security is broken, the data will still be unreadable by an attacker.
\# VPN DIAGRAM
.SH 2
SoftEther VPN
.PP
SoftEther is a long standing open source VPN implementation written in C and C++ available for all of the major platforms.
SE's own VPN language is a Layer 3 implementation licenced with Apache and written in C making it suited for the range of devices that would benefit from the VPN.
It also has the ability to deploy a number of other VPN implementations from OpenVPN to IPsec, however for our demonstration setup the native implemnentation will be sufficient.
By default SoftEther authenticates clients to a self generated certificate and individual key which an administrator must provide to each client connecting.
For a production enviroment, a more lightweight implementation such as IPsec or WireGuard may be more prefereable if the throughput on the network is required to be unhampered.
.SH 3
Implementation
.PP
The SoftEther package comes in two binary's, an installable server and client.
For our demonstration two VM's will be used to act as two nodes on our network, both running Windows 7 SP 1 named Blue and Green respectively, with a Kali Linux VM acting as a hostile unauthenticated attacker, listening to our traffic.
Kali will have a running Wireshark instance listening on the NIC attached to the network with other VM's and we will be monitoring the traffic as weping between our two machines before and after the VPN setup.
Our network will be setup such that all three machines are in the same subnet, although in the wild the Kali Linux machine would not need to join the network merely have a Wireless NIC in promiscuous mode.
Our Windows Server, Blue, will be
.CW "10.0.0.1" ,
our Windows Client, Green, will be
.CW "10.0.0.2" ,
while Kali will be
.CW "10.0.0.3" .
.TS
center tab(:);
c s s
l | c | c
l | c | n.
IP Addresses

Virtual Machine:Role:IP address
_
Windows 7 Blue:Server:10.0.0.1
_
Windows 7 Green:Client:10.0.0.2
_
Kali Linux:Attacker:10.0.0.3
.TE
.PP
Initially we will send a ping from our Blue Server to our Green Client with
.CW "ping 10.0.0.2"
and obserce in Kali linux that we see a cleartext ICMP packet being sent and its associated reply.
\# ethical-k-unencrypted.png
Now we know that all VM's are connected and working and we have data being transmitted in clear we can begin the VPN setup.
.SH 3
Installation of SoftEther
\# ethical-s-choice.png
.PP
During the installation it is important to choose the avaiable "SoftEther VPN Server" and "SoftEther VPN Client" options during the server and client installation respectively.
.SH 3
Server Setup
\# ethical-s-remoteaccess.png
.PP
SoftEther allows a number of configurations on the VPN Server.
In our demonstration the
.B "Remote Access VPN Server" " "
will be used as it provides far more functionality than we require, creating a bridge between remote locations and our local network.
This is intended to allow authenticated remote users to access local resources such as files available on a local intranet, for example.
However while this is far outside the remit of our demonstration, it will provide the basic functionality we require.
.QP
.RS
.I
In a production environment this VPN would not be on the edge of a network (unless it was providing the entire company VPN) and thus would not be exposed itself.
.RE
.R
\# ethical-s-vpnsettings.png
.PP
Once we have selected the appropriate type of VPN for our implementation, we must configure the server.
As we said earlier our Windows Blue Server will be
.CW "10.0.0.1"
so we will set the hostname accordingly.
For the Port, we do not need to worry about changing this as this will be the only server running on this VM.
If we wanted to have multiple instances or had a firewall with only a specific port opened then we would need to change this.
Finally our adminstrator password is up to the discretion of the network administrator setting this up, however it would be good practice to ensure this was a strong password.
\# ethical-s-createcert.png
.PP
Next we we need to create the certificate for our client which our server can use to ensure that our client is who they say they are.
In production we would likely see this certificate entered into a Certificate Authority
.B "CA" ) (
which is a central,
.B "trusted" ,
authority which would allow the network administrator to easily handle and manage many certificates easily without the need to manually create a new one for each user.
However again, for demonstration purposes this is unnesecary and we will just issue a Self-Signed Certificate and distribute this to the clients manually.
.TS
center tab(:);
c s
l | c.
Certificate Details
Common Name(CN):User001
Organization (O):Greenshoots Ltd.
Organization Unit (OU):IT
Country (C):UK
State (ST):Scotland
Locale (L):Aberdeen
Seriel Number (Hex): N/A
Expires:3650 Days
.TE
.PP
Creating this certificate will give us the file with which we can authenticate the client connectiing to the server with.
With this proccess hooked up to an Lightweight Directory Access Protocol
.B "LDAP" ) (
or Active Directory
.B "AD" ) (
server, the certificates could be tied to those user profiles and would be generated and expired as the LDAP/AD accounts were.
\# ethical-s-vpnsetup
.PP
Once we have completed this our VPN can be started and we will be looking at the an information screen with various options and information regarding users connected.
From here we will need to move to the client and connect them to the server.
.SH 3
Client Setup

.SH 2
Intrusion Detection System
.PP

.NH
Ethical
