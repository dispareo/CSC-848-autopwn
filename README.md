The purpose of this script is to attempt to autopwn as soon as it's plugged into an ethernet.
As it is written in the first iteration, it should be eth0. 

It does a few things:
1) starts OpenVPN back to the VPN server (C2) 
2) Starts an Autossh shell back to the server (C2)
3) Starts a backup "oh crap!" SSH session to the (C2)
4) nmaps the local /24 network
   - identifies common ports of attack
   - runs enumeration scripts against those ports/services
   - attempts to run responder and send hashes back over the SSH session
   - going to attempt to "autocrack" them using hashcat on the "big rig"


NOTE TO SELF - get better at MD. I've always been fine with drab text, but some of the other GH's I've seen look great
