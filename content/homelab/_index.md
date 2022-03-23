---
title: "Homelab"
description: "My personal homelab"
---

What goes into a homelab? A bunch of unnecessary devices... and cables.

---

## ERLite-3 - Router

EdgeOS v2

EdgeRouter Lite

Makes AT&T happy with the use of [eap_proxy](https://github.com/jaysoffian/eap_proxy)

---
## OBi202 - VoIP

[OBi202](https://www.obitalk.com/info/products/obi202)

VoIP House Phone service through Google Voice for [free](https://www.youtube.com/watch?v=DRmv6vmFHjo)

Connected to [Amazon Echos](https://www.youtube.com/watch?v=IRmGZSdH2qY) through an [Echo Connect](https://www.amazon.com/dp/B076ZRFP6Y)

---
## BLUE - Workstation

[Windows](https://youtu.be/Zu0l-Ac7fTU) 10 Professional

HP Stream 200-010

Intel Celeron 2957U

6GB RAM

#### Usage
 - Banking software
 - RDP Server

---
## TEAL - Workstation/Server

NixOS 22.05 (Quokka)

[AMD](https://youtu.be/zAEXuONMJCQ?t=45) FX-8350

NVIDIA GTX 970

16GB RAM

#### Storage
 - 1TB HDD
 - 2TB HDD
 - 1TB SSD

#### Usage
 - SSHFS Storage Server
 - Duplicati Backup
 - Docker Containers

#### Containers
 - [Plex](https://github.com/linuxserver/docker-plex)
 - Multiple [Minecraft Servers](https://github.com/itzg/docker-minecraft-server)

---
## PI - Server

NixOS 21.11 (Porcupine)

Raspberry Pi 4 Model B

8GB RAM

#### Storage
 - 3TB HDD
 - 120GB SSD

#### Usage
 - SSHFS Storage
 - Many Docker Containers
 - Netdata

#### Containers
 - [CUPS Print Server](https://github.com/chuckcharlie/cups-avahi-airprint)
 - [ddclient](https://github.com/linuxserver/docker-ddclient)
 - [diun](https://crazymax.dev/diun/install/docker/)
 - [dnsmasq](https://github.com/LegitMagic/misc/tree/master/dnsmasq_docker)
 - [Firefly III](https://docs.firefly-iii.org/firefly-iii/installation/docker/)
 - [Home Assistant](https://www.home-assistant.io/installation/generic-x86-64#install-home-assistant-container)
 - [Hugo Webserver](https://github.com/klakegg/docker-hugo)
 - [Hugo NGINX](https://github.com/nginxinc/docker-nginx)
 - [jmusicbot](https://github.com/craumix/jmb-container)
 - [Librespeed](https://github.com/librespeed/speedtest/blob/master/doc_docker.md)
 - Cuberite Minecraft Lobby
 - [Minecraft Velocity Proxy](https://github.com/itzg/docker-bungeecord)
 - [Navidrome](https://www.navidrome.org/docs/installation/docker/)
 - [OvenMediaEngine](https://airensoft.gitbook.io/ovenmediaengine/getting-started#running-with-docker)
 - [OvenMediaEngine NGINX](https://github.com/nginxinc/docker-nginx)
 - [Paperless-ng](https://paperless-ng.readthedocs.io/en/latest/setup.html#setup-docker-hub)
 - [h5ai on PHP](https://github.com/docker-library/php)
 - [Pi-hole](https://github.com/pi-hole/docker-pi-hole)
 - [Traefik Reverse Proxy](https://github.com/traefik/traefik-library-image)
 - [Unifi-Controller](https://hub.docker.com/r/linuxserver/unifi-controller)
 - [Watchtower](https://github.com/containrrr/watchtower)
 - [WebDav Server](https://rclone.org/install/#install-with-docker)
 - [Wireguard Server](https://github.com/linuxserver/docker-wireguard)

---
## OracleVPS - Virtual Private Server

NixOS 21.11 (Porcupine)

Oracle Cloud [(Always Free)](https://www.oracle.com/cloud/free/) VM.Standard.A1.Flex

24GB RAM

#### Storage
 - 50GB SSD

#### Usage
 - Track Server Uptime

#### Continaers
 - [Traefik Reverse Proxy](https://github.com/traefik/traefik-library-image)
 - [Uptime-Kuma](https://github.com/louislam/uptime-kuma)
 - [Watchtower](https://github.com/containrrr/watchtower)

---
<img src="https://img.shields.io/date/1648041873?label=Last%20Updated&style=for-the-badge">
