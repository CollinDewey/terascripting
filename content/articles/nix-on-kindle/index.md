---
title: Running Nix on a Jailbroken Kindle
author: Collin Dewey
date: '2025-05-14'
lastmod: '2025-10-12'
type: Article
slug: nix-on-kindle
description: "Installing and Running the Nix package manager on a jailbroken Amazon Kindle"
---

<br>

---

{{< img src="KindleFastFetch.jpg" alt="Fastfetch running through Nix on a jailbroken Amazon Kindle" >}}

---

## Kindle

The Amazon Kindle is an e-reader, meant for purely e-reading purposes. I've loved reading books, textbooks, and papers on it. The screen is much easier on the eyes. It's also a good way to have a distraction-free environment where I don't have a good way to get sidetracked. Let's ruin that by jailbreaking it and installing whatever software we like.

---

## Jailbreak

To get more out of your Kindle, you'll want to jailbreak it. This lets you install and run non-Amazon software. If you're interested, there's an available jailbreak at the [Kindle Modding Wiki](https://kindlemodding.org/jailbreaking/getting-started).

One of the nicest tools to install is [KOReader](https://koreader.rocks/), an e-book reading software. It also supports starting an [SSH server](https://github.com/koreader/koreader/wiki/SSH), which can make setup easier. You'll also want to install [Kterm](https://www.fabiszewski.net/kindle-terminal/) so you can use a terminal on the Kindle itself.

---

## What does Nix offer you?

Nix can be used as a package manager, allowing us to install up-to-date software on the Kindle without trampling over old libraries or accidentally bricking the Kindle's operating system. Nix allows us to effortlessly cross compile [lots of software](https://search.nixos.org/packages) on our powerful computers and move it over to the Kindle, since the Kindle isn't made to be a compilation powerhouse.

---

## TL;DR How do I install it? How do I install software?

Run the `kindle-nix-installer.sh` [script from my GitHub](https://github.com/CollinDewey/kindle-nix/releases/latest/) on your Kindle, either through Kterm, or through SSH. Here's the command.

```sh
curl -fsSLO https://github.com/CollinDewey/kindle-nix/releases/latest/download/kindle-nix-installer.sh && bash kindle-nix-installer.sh && rm kindle-nix-installer.sh
```

To install software, on a computer with Nix installed, add this as a shell alias
```sh
alias kindle-send='f(){ p=nixpkgs#pkgsCross.armv7l-hf-multiplatform.$2 && for c in $(nix build $p --no-link --print-out-paths); do nix copy --to ssh://$1 $c && ssh $1 "nix profile add $c"; done; }; f'
```
and send over software like
```sh
kindle-send root@<KINDLE_IP> htop
```

---

## How does this work?

The regular Nix installer will fail on the Kindle due to differences between how the Kindle's Linux is setup versus more traditional Linux setups. So let's set it up ourselves.

### Internal Storage

The Kindle's internal storage is setup rather strangely. There is a small root partition with the operating system, and a bigger partition for userdata (/mnt/base-us/), which is unfortunately formatted as FAT32. Nix stores all of its data in the /nix folder. Since there isn't enough space to store all of the files for the installed applications on the root partition, we need to store that data in the userdata partition. The userdata partition being formatted as FAT32 comes with some annoying restrictions, such as a filesize limit of 4GB and lacking symbolic links. Nix especially relies on symbolic links to function. This partition is also mounted with the `noexec` option, requiring a remount to be able to execute applications. While we can't easily get around the 4GB limit, we can create a file as a disk image, format that as EXT4, and mount that to /nix, giving us all of the standard EXT4 features.

```sh
# Create folders for disk location and mountpoint, create the disk, mount it
mkdir -p /mnt/base-us/system/nix /nix
fallocate -l 4095M /mnt/base-us/system/nix/nix.ext4
mkfs.ext4 /mnt/base-us/system/nix/nix.ext4
mount -o loop -t ext4 /mnt/base-us/system/nix/nix.ext4 /nix
```

### Automounting /nix

Different Linux distributions use different init systems. The init system is one of the first things run by the Linux kernel and is generally in charge of mounting desired filesystem and starting services. The Kindle uses upstart for its init manager. Upstart was created for Ubuntu in 2006, and replaced by systemd in 2014. So using upstart is a rather weird choice. The upstart configuration files are placed in `/etc/upstart`. Since we don't want to mount /nix ourselves every time, we want to do so automatically after the userstore is mounted, and unmount it when the system is shutting down. This is what an upstart service would look like to do this.

`/etc/upstart/nix-daemon.conf`
```
start on started filesystems_userstore
stop on stopping filesystems

pre-start script
    mount -o loop -t ext4 /mnt/base-us/system/nix/nix.ext4 /nix
end script

script
    /bin/nix daemon
end script

post-stop script
    umount /nix
end script
```

### Setting up the Nix folders

After we have the /nix folder mounted, we need to setup the proper folders and permissions. This can be done with the install tool, which will let us setup the permissions upon folder creations.  

```bash
# Creates folders and sets permissions, extracts store.tar
install -dv -m 0755 /nix /nix/var /nix/var/log /nix/var/log/nix /nix/var/log/nix/drvs /nix/var/nix{,/db,/gcroots,/profiles,/temproots,/userpool,/daemon-socket} /nix/var/nix/{gcroots,profiles}/per-user
install -dv -m 0555 /etc/nix
install -dv -m 1775 /nix/store
```

### Downloading Nix

Nix has pre-compiled releases located at releases.nixos.org for various architectures, including the ARMv7 architecture used on the Kindle.

So we can download and extract that. The link is formatted like below, with $release being the Nix release version and $system being the architecture and OS.

```
# Base URL
https://releases.nixos.org/nix/nix-$release/nix-$release-$system.tar.xz

# Example for Nix 2.32.0
https://releases.nixos.org/nix/nix-2.32.0/nix-2.32.0-armv7l-linux.tar.xz
```

Downloading that file with curl, we can get Nix and all the dependencies, and dump its nix store contents into /nix/store.

```bash
tar -xJf nix-2.32.0-armv7l-linux.tar.xz -C '/nix/store' --strip-components=2
```

### Nix configuation
Nix by default wants a bunch of users to be created for it to use as build users, but modern Nix has an experimental feature called "auto-allocate-uids", which will pick user IDs when needed. I had to give it a group to use, so I just picked one that already existed on the Kindle.

`/etc/nix/nix.conf`
```
extra-experimental-features = nix-command flakes auto-allocate-uids
auto-allocate-uids = true
build-users-group = javausers
```

### Putting Nix in the right spot

Now that we have Nix setup, we need to put it in the right place to invoke it. We can just create a link to where Nix is from `/bin/nix`, and then copy the links to all of the other variants of `nix-something` to `/bin/nix`.

```bash
# Links the nix binary to /bin/nix
ln -sf /nix/store/*-nix-armv7l-*/bin/nix /bin/
# Copies links for nix-build, nix-channel, nix-collect-garbage, nix-env, etc...
cp /nix/store/*-nix-armv7l-*/bin/nix-* /bin/
```

And to stop Nix from garbage collecting itself when `nix-collect-garbage` is run, let Nix know to keep itself around.

```bash
nix profile add /nix/store/*-nix-armv7l-*/
```

### Installing other applications

Nix has a binary cache for the popular platforms aarch64 and x86_64. This is not the case for ARMv7l, so software will need to be compiled from source. Nix makes this very easy to do, but the Kindle is lacking a little bit in power and RAM. So to compile software, we can do it on a powerful computer. For example, to install htop. First we need to compile it on our stronger machine, transfer over the files over SSH, and then install the package with nix to make it available to run.

```bash
# Build the application, get the full path of the package, and send it over
nix build nixpkgs#pkgsCross.armv7l-hf-multiplatform.htop --no-link --print-out-paths

# You can see the path using path-info
nix copy --to ssh://root@<KINDLE_IP> nixpkgs#pkgsCross.armv7l-hf-multiplatform.htop
```

Then SSH into the Kindle and make it available for use
```bash
nix profile add <THE_OUT_PATHS>
```

### Using Nix-installed applications

To use applications we're installing with Nix, we need to add a snippet to the shell profile to set all of the proper shell variables. The default shell is Busybox's version of ash, which doesn't look in `/etc/profile.d` by default, which is where we'd normally put this, so we need to edit `/etc/profile` instead, just adding this to the end makes the shell aware of our installed applications.

`/etc/profile`
```bash
# Put Nix stuff in the PATH
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
    . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
```

Start a new shell and now you're ready to use your newly installed applications.

> For some reason Kterm seems to not source `/etc/profile`. You can fix this by just running 
> ```
> . /etc/profile
> ```
> Every time you start the shell.

### Uninstalling Nix

Remove the part in `/etc/profile`, remove the links in /bin, remove the upstart config, unmount `/nix`, and delete the virtual drive.

### Automating all of this

I made a [script](https://github.com/CollinDewey/kindle-nix/releases) which will download the latest Nix on your Kindle. Just run the script with bash in a shell on your Kindle. It goes through creating the 4GB filesystem, downloading Nix, and putting stuff where it needs to be. It also leaves an uninstaller at `/mnt/base-us/system/nix/uninstall.sh`

Check it out on my GitHub at [CollinDewey/kindle-nix](https://github.com/CollinDewey/kindle-nix).