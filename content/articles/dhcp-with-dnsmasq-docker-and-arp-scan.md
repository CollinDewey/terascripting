---
title: DHCP with dnsmasq, Docker, and arp-scan
author: Collin Dewey
date: '2021-10-03'
slug: dhcp-with-dnsmasq-docker-and-arp-scan
description: "dnsmasq in a docker image to easily provide static IPs using DHCP."
---

---
# Why static IP addresses?
---
I'm an avid user of everything technology, but also not an avid fan of walking between two computers in my house when I'm trying to do something between them. Or even just switching my keyboard, mouse and monitor cables between two computers. Copying files through a flash drive is slow, it would be much easier to just do it through the network. Methods of remotely controlling a computer makes EVERYTHING much more convenient. There is a problem with this however. Software like [TeamViewer](https://www.teamviewer.com/en/) isn't the best when you have a LAN connection with the computer you want to control. TeamViewer also doesn't allow you to run on computers that lack a GUI, although they do have a [Raspberry Pi version](https://www.teamviewer.com/en/solutions/remote-desktop/raspberry-pi/) interestingly enough.

Remotely controlling a computer through SSH, VNC, and RDP, are much better methods than installing third party software. Plus, I can use all of these methods when I'm out of my house through my [Wireguard VPN](https://en.wikipedia.org/wiki/WireGuard). There is one issue with this however, I've found that using hostnames are not the most reliable.

There's also another reason as to why I would want static IP addresses, port forwarding. I don't play games all that often but I do occasionally host a Minecraft server for me and my friends to play on. I find it a pain to go to my router page, logging in, just to change the IP on my port forwarding every few days. It would be easier to just never need to change the IP.

How do I go about setting a static IP address? Setting a static IP address is a pain to do on each device, but also impossible on some devices, such as smart plugs and lights.

The better way to do this is through the power of [DHCP](https://en.wikipedia.org/wiki/Dynamic_Host_Configuration_Protocol). Your home router probably already has a DHCP server, which assigns IPs to devices on your network. But in my case, I will be giving it out through a program called dnsmasq on a Raspberry Pi. Yes I know the name primarily has "DNS" in it, but dnsmasq supports more than just DNS, including being a DHCP server.

---
# dnsmasq
---

At my house, I have dozens of devices to keep track of. I won't bore you with a base dnsmasq configuration setup, but I will list my DHCP part for reference. You will need to go to your router and change the DHCP server to be the IP of the device running dnsmasq, in addition to setting a static IP on just that device.

**`dnsmasq.conf`**
```
dhcp-range=eth0,172.16.0.0,static
dhcp-range=eth0,172.16.0.40,172.16.0.99,45m
dhcp-option=eth0,option:router,172.16.0.1
dhcp-option=option:ntp-server,129.6.15.30,206.246.122.250
dhcp-option=252,"\n"
dhcp-option=vendor:MSFT,2,1i
dhcp-authoritative

# Host IP assignment
conf-file=/etc/dnsmasq.d/hosts.conf
```

In the excerpt of above configuration file, I specify the range of random IP assignments for those that I don't manually specify, and the router. However, at this point I haven't manually assigned any IPs. That's where the last line comes in, 
```
conf-file=/etc/dnsmasq.d/hosts.conf
```
This tells dnsmasq to look at an additional config file, which will be in the same format as **`dnsmasq.conf`**, just in another file. The actual IP assignment comes in with the usage of the dhcp-host option. Such as below...
**`hosts.conf`**
```
dhcp-host=88:CE:46:95:0E:EC,EdgeRouter-Lite,172.16.0.1,12h
dhcp-host=8C:EB:32:DF:2D:C0,UniFi-AP,172.16.0.2,12h
dhcp-host=65:E3:62:1B:38:CF,PI,172.16.0.3,12h
dhcp-host=A9:F2:07:3A:13:9F,Network-Switch-1,172.16.0.4,12h
dhcp-host=85:B2:D3:5B:A6:34,Personal-Cloud,172.16.0.5,12h
dhcp-host=B2:B4:36:E1:43:4E,ObiHai,172.16.0.8,12h
dhcp-host=17:59:A0:DE:2A:73,BLUE,172.16.0.20,12h
```

---
# arp-scan
---

However there's another application I want to use that also needs IPs and names, that application being [arp-scan](https://github.com/royhills/arp-scan). arp-scan sends ARP packets to all possible IPs within your specified range, and reports the responses. This unfortunately isn't the most helpful when you don't easily know which device is what.

**`Excerpt from arp-scan's man page`**
```
$ arp-scan --interface=eth0 192.168.0.0/24
Interface: eth0, datalink type: EN10MB (Ethernet)
Starting arp-scan 1.4 with 256 hosts (http://www.nta-monitor.com/tools-resources/security-tools/arp-scan/)
192.168.0.1     00:c0:9f:09:b8:db       QUANTA COMPUTER, INC.
192.168.0.3     00:02:b3:bb:66:98       Intel Corporation
192.168.0.5     00:02:a5:90:c3:e6       Compaq Computer Corporation
192.168.0.87    00:0b:db:b2:fa:60       Dell ESG PCBA Test
192.168.0.90    00:02:b3:06:d7:9b       Intel Corporation
192.168.0.153   00:10:db:26:4d:52       Juniper Networks, Inc.
192.168.0.191   00:01:e6:57:8b:68       Hewlett-Packard Company
192.168.0.251   00:04:27:6a:5d:a1       Cisco Systems, Inc.
192.168.0.196   00:30:c1:5e:58:7d       HEWLETT-PACKARD
```

arp-scan allows you to specify a file that relates the MAC addresses to names with the `--macfile file` command line argument. Unfortunately for us, arp-scan doesn't want to see dhcp-host, rather we have to use the format that it wants. Which looks like this...

**`macfile.txt`**
```
88CE46950EEC    EdgeRouter-Lite
8CEB32DF2DC0    UniFi-AP
65E3621B38CF    PI
A9F2073A139F    Network-Switch-1
85B2D35BA634    Personal-Cloud
B2B436E1434E    ObiHai
1759A0DE2A73    BLUE
```

Now when I specify the macfile, I can see a much nicer output.

```
$ sudo arp-scan --localnet --interface eth0 --macfile macfile.txt
Interface: eth0, type: EN10MB, MAC: 65:e3:62:1b:38:cf, IPv4: 172.16.0.3
Starting arp-scan 1.9.7 with 256 hosts (https://github.com/royhills/arp-scan)
172.16.0.1      88:ce:46:95:0e:ec       EdgeRouter-Lite
172.16.0.2      8c:eb:32:df:2d:c0       UniFi-AP
172.16.0.5      85:b2:d3:5b:a6:34       Personal-Cloud
172.16.0.3      65:e3:62:1b:38:cf       PI
172.16.0.20     17:59:a0:de:2a:73       BLUE
172.16.0.4      a9:f2:07:3a:13:9f       Network-Switch-1
172.16.0.20     17:59:a0:de:2a:73       BLUE (DUP: 2)
172.16.0.8      b2:b4:36:e1:43:4e       ObiHai
9 packets received by filter, 0 packets dropped by kernel
Ending arp-scan 1.9.7: 256 hosts scanned in 2.157 seconds (118.68 hosts/sec). 8 responded
```

However, the result is unsorted and contains duplicates sometimes. changing the command a bit results in a clean looking, sorted, output.

```
$ sudo arp-scan --macfile arp-scan.txt --localnet --interface eth0 --ignoredups --plain | sort -t . -k 3,3n -k 4,4n
172.16.0.1      88:ce:46:95:0e:ec       EdgeRouter-Lite
172.16.0.2      8c:eb:32:df:2d:c0       UniFi-AP
172.16.0.3      65:e3:62:1b:38:cf       PI
172.16.0.4      a9:f2:07:3a:13:9f       Network-Switch-1
172.16.0.5      85:b2:d3:5b:a6:34       Personal-Cloud
172.16.0.8      b2:b4:36:e1:43:4e       ObiHai
172.16.0.20     17:59:a0:de:2a:73       BLUE
```

---
# Automation
---

Sure I could maintain a separate list to keep between arp-scan and dnsmasq, but that's no fun. Instead I could do some simple bash scripting to generate multiple list formats from a format of my own. There's four things I need to know. Requested IP, MAC address, name, and DHCP lease time. I decided on a simple tsv format with tab delimiting the sections, in addition to making comments start with # and ignoring empty lines.

**`dhcp.tsv`**
```
#Networking     eth0 (1-19)
88CE46950EEC    EdgeRouter-Lite 172.16.0.1      12h
8CEB32DF2DC0    UniFi-AP        172.16.0.2      12h
65E3621B38CF    PI      172.16.0.3      12h
A9F2073A139F    Network-Switch-1        172.16.0.4      12h
85B2D35BA634    Personal-Cloud  172.16.0.5      12h
B2B436E1434E    ObiHai  172.16.0.8      12h

#Misc           eth0 (20-39)
1759A0DE2A73    BLUE    172.16.0.20     12h
```

**`generate.sh`**
```
#!/bin/bash

cat dhcp.tsv | while IFS="	" read -r col1 col2 col3 col4
do
    if [[ $col1 != *"#"* ]] && [[ $col1 != "" ]]; then
        echo "$col1 $col2"
    fi
done > arp-scan.txt

cat dhcp.tsv | while IFS="	" read -r col1 col2 col3 col4
do
    if [[ $col1 != *"#"* ]] && [[ $col1 != "" ]]; then
        echo "dhcp-host=${col1:0:2}:${col1:2:2}:${col1:4:2}:${col1:6:2}:${col1:8:2}:${col1:10:2},$col2,$col3,$col4"
    fi
done > /etc/dnsmasq.d/hosts.conf

systemctl restart dnsmasq.service
```

---
# Docker
---

[Docker](https://en.wikipedia.org/wiki/Docker_(software)) is containerization software, meaning each container has access to its own files, but still uses the host system's kernel. I'd recommend reading more about Docker if you don't know anything about it. They have a nice overview on docker and how it works over on the [Docker Docs Website](https://docs.docker.com/get-started/overview/).

It's fairly easy to install dnsmasq on any Linux distribution. However, in my efforts to make my "homelab" as modular as possible, I decided, why not put it in a docker container. So I did. I used alpine, which is a very light weight base docker image, installed dnsmasq and bash, modified my script above a little to start dnsmasq instead of treating it like a service, profit, dnsmasq in a docker container providing both DHCP and DNS for my home network.

**`Dockerfile`**
```
FROM alpine:latest
RUN apk --no-cache add dnsmasq bash
COPY ./startup.sh /startup.sh
ENTRYPOINT ["/bin/bash", "startup.sh"]
```

At the time of writing, I manage my docker containers across multiple docker-compose files, so I quickly made a docker-compose file for my docker image.

**`docker-compose.yml`**
```
version: "3.5"

services:
  dnsmasq:
    build: ./build
    container_name: dnsmasq
    volumes:
      - ./dnsmasq.conf:/etc/dnsmasq.conf
      - ./dhcp.tsv:/dhcp.tsv
      - ./arp-scan.txt:/arp-scan.txt
    cap_add:
      - NET_ADMIN
    network_mode: host
    restart: unless-stopped
```

After running `docker-compose up -d`, I was left with functional dnsmasq in a docker image.

---

## You can see the files mentioned in the article on my [GitHub](https://github.com/LegitMagic/misc/tree/master/dnsmasq_docker)

---

### Edit History:

10/3/21 - Initial Release
