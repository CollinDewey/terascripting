---
title: Introduction to Managing systemd
author: Collin Dewey
date: '2025-11-23'
type: Presentation
slug: intro-to-managing-systemd
description: ""
marp: true
class: invert
theme: default
size: 16:9
---


{{< slides >}}

## Introduction to Managing systemd
<!-- _footer: By Collin Dewey-->

{{< marp >}}
![bg right:40% 90%](systemd-dark-mono.svg)
{{< /marp >}}{{< hugo >}}
{{< img src="systemd-dark-mono.svg" alt="systemd Logo" min-width="40vw" max-height="30vh">}}
{{< /hugo >}}

---

## What is systemd

- Magages
  - Services
  - Logging
  - Scheduled Tasks

---

## How do I know if I'm running systemd?

```bash
systemctl --version
```
```
systemd 258 (258)
+PAM +AUDIT -SELINUX +APPARMOR +IMA +IPE +SMACK +SECCOMP +GCRYPT -GNUTLS +OPENSSL +ACL +BLKID +CURL +ELFUTILS +FIDO2 +IDN2 -IDN -IPTC +KMOD +LIBCRYPTSETUP
+LIBCRYPTSETUP_PLUGINS +LIBFDISK +PCRE2 +PWQUALITY +P11KIT +QRENCODE +TPM2 +BZIP2 +LZ4 +XZ +ZLIB +ZSTD +BPF_FRAMEWORK -BTF -XKBCOMMON +UTMP -SYSVINIT +LIBARCHIVE
```

---

## [systemd units](https://www.freedesktop.org/software/systemd/man/latest/systemd.unit.html)

Commonly
- [`.service`](https://www.freedesktop.org/software/systemd/man/latest/systemd.service.html#) - Services (Background Applications)
- [`.socket`](https://www.freedesktop.org/software/systemd/man/latest/systemd.socket.html#) - Sockets
- [`.timer`](https://www.freedesktop.org/software/systemd/man/latest/systemd.timer.html#) - Scheduled Tasks

---

Can also be

[`.device`](https://www.freedesktop.org/software/systemd/man/latest/systemd.device.html#) - Information about a device (Typically autopopulated)

[`.mount`](https://www.freedesktop.org/software/systemd/man/latest/systemd.mount.html#)

[`.automount`](https://www.freedesktop.org/software/systemd/man/latest/systemd.automount.html#)

[`.swap`](https://www.freedesktop.org/software/systemd/man/latest/systemd.swap.html#) - Swapfile/Pagefile

[`.target`](https://www.freedesktop.org/software/systemd/man/latest/systemd.target.html#) - Synchronization point for units

[`.path`](https://www.freedesktop.org/software/systemd/man/latest/systemd.path.html#) - Path to be monitored, needs service to run upon changes within the path

[`.scope`](https://www.freedesktop.org/software/systemd/man/latest/systemd.scope.html#) - Encapsulate multiple processes into a group

[`.slice`](https://www.freedesktop.org/software/systemd/man/latest/systemd.slice.html#) - Group services and scopes together


---

## Let's take a look at your units

```
systemctl list-units
systemctl list-units --type=service
systemctl list-units --type=timer
```
Down/Up arrow scrolls

View the status of a service

```
systemctl status [SERVICE]
```

---

## Status/Stop/Start/Restart

```
systemctl status [SERVICE]
systemctl stop [SERVICE]
systemctl start [SERVICE]
systemctl restart [SERVICE]
```

---

## Automatically start service
```
systemctl enable [SERVICE]
systemctl disable [SERVICE]
systemctl is-enabled [SERVICE]
```

---

## Disable service from ever running
```
systemctl mask [SERVICE]
systemctl unmask [SERVICE]
```

---

## Viewing logs

`journalctl -f` - Follows all logs
`journalctl -b` - Logs from this boot
```
journalctl --since "30 min ago"
journalctl -xeu [SERVICE]
```

---
## Properties

```
systemctl show [SERVICE]
```

---

## [Resource Control](https://www.freedesktop.org/software/systemd/man/latest/systemd.resource-control.html#) 

Use `systemd-cgtop` to view slice resource usage

`CPUQuota=20` - % of CPU on one CPU thread

`AllowedCPUs=1,3` - Specify specific CPU threads to use

`MemoryMax=2G` - Hard-max RAM limit


`IPAddressAllow=127.0.0.0/8` - Allow contacting certain IPs (IP or any)

`IPAddressDeny=any` - Deny contacting certain IPs (IP or any)


`RestrictNetworkInterfaces=eth0` - Allow only using eth0

`RestrictNetworkInterfaces=~eth0` - Allow any except eth0


---

## Security Settings
```
systemd-analyze security [SERVICE]
```

---

## Editing a unit

### Temporary/Runtime
```
systemctl set-property [SERVICE/SLICE] ProtectSystem=strict
```

## Permanent
```
systemctl edit [SERVICE]
```
```ini
### Editing /etc/systemd/system/service.service.d/override.conf
### Anything between here and the comment below will become the contents of the drop-in file

[Service]
PrivateTmp=yes
ProtectHome=yes
ProtectSystem=strict
NoNewPrivileges=yes

### Edits below this comment will be discarded
```
