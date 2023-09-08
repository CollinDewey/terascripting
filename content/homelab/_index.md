---
title: "Homelab"
description: "My Homelab Setup"
---

---
## CYAN - Workstation

[NixOS 23.05 (Tapir)](https://nixos.org/)

[Nix Configuration](https://github.com/LegitMagic/nix-config)

AMD Ryzen 9 7950X

Radeon RX 6800-XT / GeForce RTX 2080

96GB RAM DDR5

#### Storage
 - 1TB SSD
 - Connection to TEAL over NFS via 10GbE

#### Usage
 - Compiling Linux Software
 - Brute Forcing Passwords
 - Using AI (Stable Diffusion / RVC / Llama 2)
 - Two Gamers - One Computer (VFIO GPU Passthrough)

---
## TEAL - Server

[NixOS 23.05 (Stoat)](https://nixos.org/)

[Nix Configuration](https://github.com/LegitMagic/nix-config)

AMD FX-8350

AMD ATI Xpert 128

16GB RAM DDR3

#### Storage
 - 14TB HDD (RAID1)
 - 14TB HDD (RAID1)
 - 8TB HDD
 - 1TB SSD

#### Usage
 - Stores Family Photos, Computer Backups, Phone Backups
 - Hosts Virtual Machines
 - Cache Server using [LanCache](https://lancache.net/)
 - Jellyfin Media Server

#### Containers
 - [LanCache](https://lancache.net/)
 - [PhotoPrism](https://docs.photoprism.app/getting-started/)
 - [Plex](https://github.com/linuxserver/docker-plex)
 - [Wireguard Server](https://github.com/linuxserver/docker-wireguard)
 - [OvenMediaEngine](https://airensoft.gitbook.io/ovenmediaengine/getting-started#running-with-docker)


---
## VIRIDIAN - Server

[NixOS 23.05 (Stoat)](https://nixos.org/)

[Nix Configuration](https://github.com/LegitMagic/nix-config)

Raspberry Pi 4 Model B

8GB RAM

#### Storage
 - 120GB SSD

#### Usage
 - Hosts DHCP/DNS
 - Hosts websites


### Services
 - [Navidrome](https://www.navidrome.org/docs/overview/)
 - [jmusicbot Discord Bot](https://jmusicbot.com/)
 - [CUPS Print Server](https://openprinting.github.io/cups/)
 - [netdata](https://www.netdata.cloud/)

#### Containers
 - [dnsmasq](https://github.com/LegitMagic/misc/tree/master/dnsmasq_docker)
 - [Hugo Webserver](https://github.com/klakegg/docker-hugo)
 - [Hugo NGINX](https://github.com/nginxinc/docker-nginx)
 - [Navidrome](https://www.navidrome.org/docs/installation/docker/)
 - [OvenMediaEngine NGINX](https://github.com/nginxinc/docker-nginx)
 - [Pi-hole](https://github.com/pi-hole/docker-pi-hole)
 - [Traefik Reverse Proxy](https://github.com/traefik/traefik-library-image)
 - [Unifi-Controller](https://hub.docker.com/r/linuxserver/unifi-controller)
 - [WebDav Server](https://rclone.org/install/#install-with-docker)

---
## BROWN/RUBY/SCARLET - Virtual Private Server

[NixOS 23.05 (Stoat)](https://nixos.org/)

[Nix Configuration](https://github.com/LegitMagic/nix-config)

4 CPUs

24GB RAM

#### Storage
 - 200GB Storage

#### Usage
 - Minecraft Server Hosts
 - Track Server Uptime
 - File Server

#### Continaers
 - [Minecraft Servers](https://github.com/itzg/docker-minecraft-server)
 - [Minecraft Velocity Proxy](https://github.com/itzg/docker-bungeecord)
 - [Traefik Reverse Proxy](https://github.com/traefik/traefik-library-image)
 - [Uptime-Kuma](https://github.com/louislam/uptime-kuma)
 - [Wireguard Server](https://github.com/linuxserver/docker-wireguard)
 - [NGINX](https://github.com/nginxinc/docker-nginx)

---
## KLIPPER - 3D Printer Controller

[MainsailOS](https://docs.mainsail.xyz/setup/mainsail-os)

Raspberry Pi 3 Model B

1GB RAM

#### Storage
 - 16GB Flash

#### Usage
 - Runs the Mainsail 3D printing interface using the Klipper 3D printing firmware
 - Hosts a [camera livestream of the printing process](https://printer.terascripting.com/)
 - Connected to an ADXL345 Accelerometer through GPIO for vibration tuning

---
## ERLite-3 - Router

EdgeOS v2

EdgeRouter Lite

Bypasses AT&T Fiber Residental Router Lock using [eap_proxy](https://github.com/jaysoffian/eap_proxy)

---
## OBi202 - VoIP House Phone

[OBi202](https://www.obitalk.com/info/products/obi202)

VoIP House Phone service through Google Voice for free

---
<img src="https://img.shields.io/date/1694138478?label=Last%20Updated&style=for-the-badge">

---

<script src="https://utteranc.es/client.js"
  repo="LegitMagic/terascripting"
  issue-term="og:title"
  theme="icy-dark"
  crossorigin="anonymous"
  async>
</script>
