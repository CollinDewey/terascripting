---
title: Custom UEFI boot logo in QEMU/KVM on NixOS
author: Collin Dewey
date: '2025-03-20'
lastmod: '2025-03-20'
type: Article
slug: custom-uefi-logo-qemu-kvm-on-nixos
description: "Using a NixOS overlay to set a custom UEFI logo in QEMU/KVM to replace the TianoCore logo when booting virtual machines"
---

## TianoCore

When launching virtual machines on my computer, I am greeted with the TianoCore logo in the middle of the black boot screen. [TianoCore EDK II](https://www.tianocore.org/) is a reference implementation of UEFI firmware. It's what KVM uses for its UEFI implementation. Booting a Windows VM results in this logo staying on the screen for the duration that Windows takes to load to get to the lock screen. This logo doesn't look very *cool* though. 

---

{{< img src="TianoCore.png" alt="TianoCore Logo" >}}

---

## Overriding the logo

I wanted to change that logo to have a slightly nicer thing to look at for 10-20 seconds while Windows boots. Looking up how to change the logo with KVM's UEFI, I am brought to an [article by Gary Hawkins](https://www.garyhawkins.me.uk/custom-logo-on-uefi-boot-screen/) from 2013. Their approach involves modifying the EDK II source code for its sample OVMF firmware, replacing the logo in the source. In NixOS, patching this file is relatively easy by using an overlay included in your Nix configuration. This overlay copies a local `Logo.bmp` over the one located within the package in the postPatch phase, and Nix does the work of compiling it.


```nix
nixpkgs.overlays = [
  (final: prev: {
    OVMF = prev.OVMF.overrideAttrs (old: {
      postPatch = (old.postPatch or "") + ''
        cp ${./Logo.bmp} ./MdeModulePkg/Logo/Logo.bmp
      '';
    });
  })
];
```

To setup an image for the logo, it needs to be a BMP. Once you have a suitable image to put in the center of the screen, convert your image with ImageMagick.
```
magick convert Logo.png -background black -alpha remove -define bmp:format=bmp3 Logo.bmp
```

Put your Logo.bmp along with your Nix configuration files and rebuild.

---

## Using custom OVMF firmware

When I make a VM with virt-manager, by default it uses the `edk2-x86_64-secure-code.fd` that was included along with QEMU.
```xml
<os firmware="efi">
  <type arch="x86_64" machine="pc-q35-9.2">hvm</type>
  <firmware>
    <feature enabled="no" name="enrolled-keys"/>
    <feature enabled="yes" name="secure-boot"/>
  </firmware>
  <loader readonly="yes" secure="yes" type="pflash" format="raw">/nix/store/xxxxxx-qemu-9.2.2/share/qemu/edk2-x86_64-secure-code.fd</loader>
  <nvram template="/nix/store/xxxxxx-qemu-9.2.2/share/qemu/edk2-i386-vars.fd" templateFormat="raw" format="raw">/var/lib/libvirt/qemu/nvram/virt_VARS.fd</nvram>
  <boot dev="cdrom"/>
</os>
```

The OS block can be replaced with a block similar to the below, replacing the `/nix/store` paths with `/run/libvirt/nix-ovmf/OVMF_CODE.fd` and `/run/libvirt/nix-ovmf/OVMF_VARS.fd`.

```xml
<os>
  <type arch="x86_64" machine="pc-q35-9.2">hvm</type>
  <loader readonly="yes" secure="yes" type="pflash" format="raw">/run/libvirt/nix-ovmf/OVMF_CODE.fd</loader>
  <nvram template="/run/libvirt/nix-ovmf/OVMF_VARS.fd" templateFormat="raw" format="raw">/var/lib/libvirt/qemu/nvram/virt_VARS.fd</nvram>
  <boot dev="cdrom"/>
</os>
```

---

After then, you should be able to see your custom logo in place of the TianoCore default image.

{{< vid src="Boot.mp4" alt="QEMU/KVM Booting with a modified logo" max-height="60vh" >}}