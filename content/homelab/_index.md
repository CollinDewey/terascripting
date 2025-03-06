---
title: "Homelab"
description: "My Homelab Setup"
toc: true
---

---
## Introduction {id="Introduction"}
My homelab is a constantly evolving endeavor. Below are the computers actively being used, their specifications, and their purposes.

---
## CYAN - Workstation {id="CYAN"}

[NixOS 25.05 (Warbler)](https://nixos.org/)

[Nix Configuration](https://github.com/CollinDewey/nix-config)

AMD Ryzen 9 7950X

Radeon RX 6800-XT / GeForce RTX 2080

96GB RAM DDR5

#### Storage
 - 1TB SSD
 - Connection to TEAL over NFS via 10GbE

#### Usage
 - Primary Computer
 - Temporary Cybersecurity Virtual Machines for Training
 - GPU Compute (Hashcat)
 - AI (Stable Diffusion / RVC / Ollama)
 - VFIO GPU Passthrough for one VM

#### Description

This is my main PC where I do most of my computing at home, including compiling and deploying updates to my NixOS machines. Having two GPUs allows me to use NVIDIA's CUDA as well as AMD's ROCm for AI workloads. I can also passthrough the GPUs to Virtual Machines using VFIO, meaning I can have a VM that performs graphically demanding tasks at the same time as my host OS. 96GB of RAM and a fast CPU is useful for running many VMs for studies or experimenting, whether studying for certifications or testing scripts for competitions.

---
## TEAL - Server {id="TEAL"}

[NixOS 24.11 (Vicuña)](https://nixos.org/)

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
 - Stores Family Photos, Backups
 - BTRFS Snapshots
 - Hosts Virtual Machines
 - Web Server, Media Server, Game Server
 - Container Host

#### Hosted Software
 - [Traefik Reverse Proxy](https://traefik.io/traefik/)
 - [jmusicbot Discord Bot](https://jmusicbot.com/)
 - [Hugo](https://github.com/klakegg/docker-hugo)
 - [Multiple NGINX instances](https://hub.docker.com/_/nginx)
 - [Error Pages](https://github.com/tarampampam/error-pages)
 - [Lancache](https://lancache.net/)
 - [Jellyfin](https://jellyfin.org/)
 - [Vaultwarden Password Safe](https://github.com/dani-garcia/vaultwarden)
 - [Adguardhome](https://github.com/AdguardTeam/AdGuardHome)
 - [Microbin](https://github.com/szabodanika/microbin)
 - [Syncthing](https://syncthing.net/)
 - [Immich](https://immich.app/)
 - [Netdata](https://github.com/netdata/netdata)

#### Description

TEAL is my server, it's running on a rather outdated Xeon processor, but due to its age, it's affordable. TEAL hosts various services, including but not limited to those above. Some of those are hosted using hardened SystemD units, some are running through SystemD-nspawn, and some are using Docker. Multiple VMs are always online, some of which are listed below. I use BTRFS as the filesystem for the drives, so I can take advantage of compression and snapshots. There are two 14TB drives in RAID 1 (mirrored), as to survive one drive failure. It stores valuable data such as family photos, backups, and VM drives. Since CYAN has limited local storage, additional storage is used over NFS over a 10G link. The GPU is split into three chunks, two vGPUs and the host. My web services are accessed through the Traefik Reverse Proxy, which handles the HTTPS certificates, as well as adding access control, headers, and compression. TEAL is the computer serving this page to you, minus any caching done by Cloudflare or your browser.

---
## OPNSense - Virtual Machine {id="OPNSENSE"}

[OPNSense](https://opnsense.org/)

3x1GbE NIC via SR-IOV

1x10GbE through X540's Virtual Function (VF)

#### Usage
 - Home Router
 - Wireguard (Road Warrior)
 - Data Traffic Analysis
 - DHCP Server
 - Static ARP Routes

#### Description

Due to restrictions put in place by AT&T, they perform 802.1x authentication on the ISP provided routers. I previously used a VyOS-based EdgeRouter Lite, using software called [eap_proxy](https://github.com/jaysoffian/eap_proxy) to forward EAP traffic to the AT&T provided router to answer. To replace the EdgeRouter Lite with my OPNSense virtual machine, I extracted the certificates from the ISPs router to authenticate directly via wpa_supplicant. This allowed me to use my /60 IPv6 block. The 10G link connects directly from TEAL to CYAN, a virtual function (VF) gives that link and the various VMs networking. The 1G LAN link goes to a 24-port gigabit switch, as well as a managed switch which tags VLAN traffic for Internet of Things (IoT) devices. I would like to use VLANs at the access point level in the future, but as of now, my Unifi AC Pro has poor range and the mesh APs used for the IoT network isn't VLAN aware. RADIUS is also something that I would like to use in the future once I have the hardware to support it.

---
## CyberL - Virtual Machine {id="CyberL"}

[Arch Linux](https://archlinux.org/)

#### Usage
 - Cybersecurity related tooling with the [Blackarch](https://blackarch.org/) package repositories
 - Use applications that require a "normal" Linux distribution
 - GPU Accelerated

#### Description

CyberL is an Arch Linux VM with vGPU acceleration. It uses [Sunshine](https://github.com/LizardByte/Sunshine) for remote desktop connections. NixOS is my distro of choice, but anything not packaged can be troublesome to run or package, leading to me picking Arch Linux for this VM. The [Blackarch](https://blackarch.org/) repo includes a large amount of cybersecurity tools, the same ones you would see on [Kali](https://www.kali.org/) or [Parrot](https://parrotsec.org/). This VM provides isolation from destroying my primary OS when testing possibly dangerous software. It connects to TEAL via NFS for a shared cybersecurity folder.

---
## CyberW - Virtual Machine {id="CyberW"}

Windows 10 Enterprise

#### Usage
 - Cybersecurity tooling specific to Windows
 - Experimenting with Windows, Batch, or Powershell
 - GPU Accelerated

#### Description

CyberW is a Windows VM with vGPU acceleration. It uses [Sunshine](https://github.com/LizardByte/Sunshine) for remote desktop connections. This VM is setup specifically for using cybersecurity tools, and for easy restoring. It connects to TEAL via NFS for a shared cybersecurity folder. It is also connected to my Active Directory domain.

---
## CERISE - Virtual Machine {id="CERISE"}

Windows 10 Enterprise

#### Usage
 - Windows Software Development
 - Run Windows Applications
 - GPU Accelerated

#### Description

CERISE is my main Windows VM with vGPU acceleration. It uses [Sunshine](https://github.com/LizardByte/Sunshine) for remote desktop connections. I use it for anything I would want to use Windows for, which thankfully isn't much. Often times it is used for school projects, or using software such as Visual Studio, Microsoft Office, Adobe CC, and Windows-only games. It is connected to my Active Directory domain.

---
## DC - Virtual Machine {id="DC"}

Windows Server 2025 Standard Insider

#### Usage
 - Learn more about Active Directory
 - Domain Controller for Windows Computers

#### Description

Going into a job where I worked on Windows computers, I wanted to supplement my knowledge of Windows, Windows Server, and Active Directory. I created an AD domain and setup Group Policies for my other Windows VMs to use.

---
## BROWN/RUBY/SCARLET - VPS {id="VPS"}

[NixOS 24.11 (Vicuña)](https://nixos.org/)

[Nix Configuration](https://github.com/CollinDewey/nix-config)

4 vCPUs

24GB RAM

#### Storage
 - 200GB Storage

#### Usage
 - Minecraft Server Hosts
 - Track Server Uptime with Uptime-Kuma
 - VPN
 - File Server

#### Containers
 - [Minecraft Servers](https://github.com/itzg/docker-minecraft-server)
 - [Minecraft Router](https://github.com/itzg/mc-router)
 - [TShock Terraria Server](https://github.com/Pryaxis/TShock)
 - [Traefik Reverse Proxy](https://github.com/traefik/traefik-library-image)
 - [Uptime-Kuma](https://github.com/louislam/uptime-kuma)

#### Description
BROWN, RUBY, and SCARLET are all aarch64 Virtual Private Servers. These host various game servers - mostly Minecraft - as well as the [uptime tracker](https://kuma.terascripting.com/) for my website using [Uptime-Kuma](https://github.com/louislam/uptime-kuma).

---
## AZUL - 3D Printer Controller {id="AZUL"}

[NixOS 25.05 (Warbler)](https://nixos.org/)

[Nix Configuration](https://github.com/CollinDewey/nix-config)

Intel N97

16GB RAM

#### Storage
 - 512GB SSD

#### Usage
 - Runs the Mainsail 3D printing interface using the Klipper 3D printing firmware
 - Hosts a [camera livestream of the printing process](https://printer.terascripting.com/)
 - Custom script to raise/lower camera with printer Z
 - Connected to an LIS2DW Accelerometer for input shaping

#### Description
One of my hobbies is my 3D printer, which I've performed all sorts of upgrades on. One of those updates is to use [Klipper](https://www.klipper3d.org/) instead of the default [Marlin](https://marlinfw.org/) firmware. This requires a computer to be connected to the printer's mainboard. Previously, I used a Raspberry Pi 3B, but encountered various power-related issues. I've now replaced it with a Mini PC, with shockingly high specs for the cost. Now I'm able to find models, and slice them directly next to the printer itself.

---
<img style="aspect-ratio: 242/28" alt="Image displaying last updated relative time" src="https://img.shields.io/date/1741248481?label=Last%20Updated&style=for-the-badge">

---

<script src="https://utteranc.es/client.js"
  repo="CollinDewey/terascripting"
  issue-term="og:title"
  theme="icy-dark"
  crossorigin="anonymous"
  async>
</script>
