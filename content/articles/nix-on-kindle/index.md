---
title: Running Nix on a Jailbroken Kindle
author: Collin Dewey
date: '2025-05-14'
lastmod: '2025-05-14'
type: Article
slug: nix-on-kindle
description: "Installing and Running the Nix package manager on a jailbroken Amazon Kindle"
---

<br>

---

{{< img src="KindleFastFetch.jpg" alt="Fastfetch running through Nix on a jailbroken Amazon Kindle" >}}

---

## Kindle

The Amazon Kindle is an e-reader, meant for e-reading purposes. I've loved getting to read books, textbooks, and papers on it. Much easier on my eyes. It's also a good way to have a distraction-free environment where I don't have a good way to get sidetracked. Let's ruin that by jailbreaking it and installing software.

---

## Jailbreak

To get more out of your Kindle, you'll want to jailbreak it. This lets you install and run non-Amazon software. If you're interested, there's an available jailbreak at the [Kindle Modding Wiki](https://kindlemodding.org/jailbreaking/getting-started).

One of the nicest tools to install is [KOReader](https://koreader.rocks/), an ebook reading software. It also supports starting an [SSH server](https://github.com/koreader/koreader/wiki/SSH), which can make setup easier. You'll also want to install [Kterm](https://www.fabiszewski.net/kindle-terminal/) so you can use a terminal on the Kindle itself.

---

## What does Nix offer you?

Nix can be used as a package manager, allowing us to install up-to-date software on the Kindle without trampling over old libraries or accidently bricking the Kindle's operating system. It also lets us easily cross compile [lots of software](https://search.nixos.org/packages), since the Kindle isn't made to be a compilation power-house.

---

## TL;DR How do I install it? How do I install software?

Run the `kindle-nix-installer.sh` script from my GitHub on your Kindle, either through Kterm or through SSH. Here's the command.

```sh
curl -fsSLO https://github.com/CollinDewey/kindle-nix/releases/latest/download/kindle-nix-installer.sh && bash kindle-nix-installer.sh && rm kindle-nix-installer.sh
```

To install software, on a computer with Nix installed, add this as a shell alias
```sh
alias kindle-send='f(){ p=nixpkgs#pkgsCross.armv7l-hf-multiplatform.$2 && nix build $p && for c in $(nix path-info $p); do nix-copy-closure --to $1 $c && ssh $1 "nix-env -i $c"; done; }; f'
```
and send over software like
```sh
kindle-send root@<KINDLE_IP> htop
```

---

## How does this work?

The regular Nix installer will fail on the Kindle due to missing features in bash and user management tools. So let's install it ourselves.

### Preparing files to transfer over

The Kindle's processor architecture is not one with a lot of support - armv7l-hf. Because of this, we need to cross compile the packages to be installed over onto the Kindle, including Nix itself and it's dependencies.

```bash
# Compiles Nix for the armv7l-hf architecture
nix build nixpkgs#pkgsCross.armv7l-hf-multiplatform.nixVersions.latest
```

This will give us a folder called `result` that has the files for the latest Nix on armv7l. However, it does not have all of the dependencies, you can see that list if you query the Nix store for that.

```bash
nix-store --query --requisites result
```
Which gives you an output of the many files that need to be copied over.
```
/nix/store/g1y29dris8086r03fbpx4yb9p9icv1yf-glibc-armv7l-unknown-linux-gnueabihf-2.40-66
/nix/store/29mvl137lnza2kkv177w8394r0da50jh-armv7l-unknown-linux-gnueabihf-gcc-14.2.1.20250322-lib
/nix/store/q982119q5fdcmja5idjg5fnw9xbjh3cv-bzip2-armv7l-unknown-linux-gnueabihf-1.0.8
/nix/store/zf0v7yc6nrjdjrk317mf4dj6qygkj4md-zlib-armv7l-unknown-linux-gnueabihf-1.3.1
/nix/store/kzrykpkyyrb500blfrniz41i46x26diy-aws-sdk-cpp-armv7l-unknown-linux-gnueabihf-1.11.448
/nix/store/vijan3j8kyw12n7x3nn1sg3zp1p187zv-sqlite-armv7l-unknown-linux-gnueabihf-3.48.0
/nix/store/yvqsjp82nc56zrd8xm1im2lk68hk5jvf-editline-armv7l-unknown-linux-gnueabihf-1.17.1
/nix/store/480ql4g8prnq39lvbw4x9nm7ajpq1avp-nix-armv7l-unknown-linux-gnueabihf-2.28.3
```

All of these folders need to be placed into a tarball to be sent over and extracted on the Kindle itself once the Nix store is ready.

### Internal Storage

The Kindle's internal storage is setup rather strangely. There is a small root partition with the operating system, and a bigger partition for userdata (/mnt/base-us/), which is formatted as FAT32. FAT32 comes with some annoying restrictions, such as a filesize limit of 4GB and lacking symbolic links. This partition is also mounted with the `noexec` option, requiring a remount to be able to execute applications. Since there isn't enough space to store the Nix store elsewhere, we need to store it in this userdata partition. While we still have the limit of 4GB, we can create a file, format it as ext4, and mount that, getting past some of the FAT32 restrictions.

```sh
# Create folders for disk location and mountpoint, create the disk, mount it
mkdir -p /mnt/base-us/system/nix /nix
fallocate -l 4095M /mnt/base-us/system/nix/nix.ext4
mkfs.ext4 /mnt/base-us/system/nix/nix.ext4
mount -o loop -t ext4 /mnt/base-us/system/nix/nix.ext4 /nix
```

### Automounting /nix

Different Linux distributions use different init systems. The init system is one of the first things run by the Linux kernel and is generally in charge of mounting desired filesystem and starting services. The Kindle uses upstart for it's init manager. Upstart was created for Ubuntu in 2006, and replaced by systemd in 2014. So using upstart is a rather weird choice. The upstart configuration files are placed in `/etc/upstart`. We want to mount the filesystem after the userstore is mounted, and unmount it when the system is shutting down. 

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

### Setting up the Nix store

After we have the store mounted, we need to set the permissions and extract the files needed to go in the store for the nix binary.

```bash
# Creates folders and sets permissions, extracts store.tar
install -dv -m 0755 /nix /nix/var /nix/var/log /nix/var/log/nix /nix/var/log/nix/drvs /nix/var/nix{,/db,/gcroots,/profiles,/temproots,/userpool,/daemon-socket} /nix/var/nix/{gcroots,profiles}/per-user
install -dv -m 0555 /etc/nix
install -dv -m 1775 /nix/store
tar -xf ./store.tar -C /
```

### Nix configuation
Nix by default wants a bunch of users to be created for it to use as build users, but modern Nix has an experimental feature called "auto-allocate-uids", which will create users when needed. I had to give it a group to use, so I just picked one.

`/etc/nix/nix.conf`
```
extra-experimental-features = nix-command flakes auto-allocate-uids
auto-allocate-uids = true
build-users-group = javausers
```

### Putting Nix in the right spot

Now that we have Nix setup, we need to put it in the right place to invoke it. We can just create a link to where Nix is from `/bin/nix`, and then all of the other variants of `nix-something` to `/bin/nix`.

```bash
ln -sf /nix/store/XXXXXXXXXXX-nix-armv7l-unknown-linux-gnueabihf-2.28.3/bin/nix /bin/nix
ln -sf /bin/nix /bin/nix-build
ln -sf /bin/nix /bin/nix-channel
ln -sf /bin/nix /bin/nix-collect-garbage
ln -sf /bin/nix /bin/nix-copy-closure
ln -sf /bin/nix /bin/nix-daemon
ln -sf /bin/nix /bin/nix-env
ln -sf /bin/nix /bin/nix-hash
ln -sf /bin/nix /bin/nix-instantiate
ln -sf /bin/nix /bin/nix-prefetch-url
ln -sf /bin/nix /bin/nix-shell
ln -sf /bin/nix /bin/nix-store
```

And to stop Nix from garbage collecting itself when `nix-collect-garbage` is run, let Nix know to keep itself around.

```bash
nix-env -i /nix/store/XXXXXXXXXXX-nix-armv7l-unknown-linux-gnueabihf-2.28.3
```

### Installing other applications

Nix has a binary cache for the populat platforms aarch64 and x86_64. This is not the case for armv7l, so software will need to be compiled from source. Nix makes this very easy to do, but the Kindle is lacking a little bit in power and RAM. So to compile software, we can do it on a computer similar to how we compiled Nix itself earlier. For example, let's install htop. First we need to compile it on our stronger machine, transfer over the files over SSH, and then install the package with nix-env to make it available to run.

```bash
# Build the application, get the full path of the package, and send it over
nix build nixpkgs#pkgsCross.armv7l-hf-multiplatform.htop

# You can see the path using path-info
nix path-info nixpkgs#pkgsCross.armv7l-hf-multiplatform.htop
nix-copy-closure --to root@<KINDLE_IP> <THE_PATH_FROM_PATH_INFO>
```

Then SSH into the Kindle and install it with nix-env
```bash
nix-env -i <THE_PATH_FROM_PATH_INFO>
```

But we still can't run the application when typing in htop.

### Using Nix-installed applications

To use applications we're installing with Nix, we need to add a snippet to the shell profile to set all of the proper shell variables. The default shell is Busybox's version of ash, which doesn't look in `/etc/profile.d` by default, so we need to edit `/etc/profile` instead, just adding this to the end.

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

Remove the part in `/etc/profile`, remove the upstart config, unmount `/nix` and delete the virtual drive.

### Automating all of this

I used a tool called [makeself](https://makeself.io/) to pack all of the files into one file which you can just run on the Kindle which includes all of the files you need. It's similar to one of those self-extracting archive Windows software installers. It goes through the process of preparing all of the files to be put in the Nix store, and to pack all of the scripts. The files get extracted into `/mnt/base-us/system/nix-installer`, which includes an uninstaller script if you wish to use that. Check it out on my GitHub at [CollinDewey/kindle-nix](https://github.com/CollinDewey/kindle-nix).