---
title: "Homelab"
description: "My Homelab Setup"
---

---
## CYAN - Workstation

[NixOS 24.11 (Vicuña)](https://nixos.org/)

[Nix Configuration](https://github.com/CollinDewey/nix-config)

AMD Ryzen 9 7950X

Radeon RX 6800-XT / GeForce RTX 2080

96GB RAM DDR5

#### Storage
 - 1TB SSD
 - Connection to TEAL over NFS via 10GbE

#### Usage
 - Primary Computer
 - Temporary Cyber Security Virtual Machines
 - GPU Compute (Hashcat)
 - AI (Stable Diffusion / RVC / Text-Generation)
 - VFIO GPU Passthrough for one VM

---
## TEAL - Server

[NixOS 24.05 (Uakari)](https://nixos.org/)

[Nix Configuration](https://github.com/CollinDewey/nix-config)

Intel Xeon E5-2696 v3

GeForce RTX 2070 Super

128GB RAM DDR4 ECC

#### Storage
 - 14TB HDD (RAID1)
 - 14TB HDD (RAID1)
 - 8TB HDD
 - 2x256GB SSD (Cache Drives)
 - 1TB SSD (Boot)

#### Usage
 - Stores Family Photos, Computer Backups, Phone Backups
 - BTRFS Snapshots
 - Hosts Virtual Machines (Many with NVIDIA vGPUs)
 - Web Server, Media Server

#### Hosted Software
 - [Wireguard](https://github.com/linuxserver/docker-wireguard)
 - Traefik Reverse Proxy
 - [jmusicbot Discord Bot](https://jmusicbot.com/)
 - [Hugo](https://github.com/klakegg/docker-hugo)
 - Error Pages
 - Lancache
 - Jellyfin
 - Vaultwarden
 - Adguardhome

---
## OPNSense - Virtual Machine - TEAL

[OPNSense](https://opnsense.org/)

4x1GbE NIC via VFIO PCIe Passthrough

#### Usage
 - Home Router
 - Data Traffic Analysis
 - DHCP Server
 - Static ARP Routes

---
## CyberL - Virtual Machine - TEAL

[Arch Linux](https://archlinux.org/)

#### Usage
 - Cyber Security related tooling with the ([Blackarch](https://blackarch.org/)) package repositories
 - Use applications that require a "normal" Linux distribution

---
## CyberW - Virtual Machine - TEAL

Windows 10

#### Usage
 - Cyber Security tooling specific to Windows
 - Experimenting with Windows, Batch, or Powershell

---
## DC - Virtual Machine - TEAL

Windows Server 2025 Standard

#### Usage
 - Learn more about Active Directory
 - Domain Controller for Windows computers

---
## BROWN/RUBY/SCARLET - Virtual Private Server

[NixOS 24.05 (Uakari)](https://nixos.org/)

[Nix Configuration](https://github.com/CollinDewey/nix-config)

4 CPUs - Each

24GB RAM - Each

#### Storage
 - 200GB Storage - Each

#### Usage
 - Minecraft Server Hosts
 - Track Server Uptime with Uptime-Kuma
 - VPN
 - File Server

#### Containers
 - [Minecraft Servers](https://github.com/itzg/docker-minecraft-server)
 - [Minecraft Router](https://github.com/itzg/mc-router)
 - [Traefik Reverse Proxy](https://github.com/traefik/traefik-library-image)
 - [Uptime-Kuma](https://github.com/louislam/uptime-kuma)

---
## AZUL - 3D Printer Controller

[NixOS 24.11 (Vicuña)](https://nixos.org/)

[Nix Configuration](https://github.com/CollinDewey/nix-config)

Intel N97

16GB RAM

#### Storage
 - 512GB SSD

#### Usage
 - Runs the Mainsail 3D printing interface using the Klipper 3D printing firmware
 - Hosts a [camera livestream of the printing process](https://printer.terascripting.com/)
 - Connected to an LIS2DW Accelerometer for input shaping

---
<img src="https://img.shields.io/date/1724528292?label=Last%20Updated&style=for-the-badge">

---

<script src="https://utteranc.es/client.js"
  repo="CollinDewey/terascripting"
  issue-term="og:title"
  theme="icy-dark"
  crossorigin="anonymous"
  async>
</script>
