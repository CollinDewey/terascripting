---
title: Custom UEFI boot logo in QEMU/KVM on NixOS
author: Collin Dewey
date: '2025-03-20'
lastmod: '2026-04-03'
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

I wanted to change that logo to have a slightly nicer thing to look at for 10-20 seconds while Windows boots. Looking up how to change the logo with KVM's UEFI, I am brought to an [article by Gary Hawkins](https://www.garyhawkins.me.uk/custom-logo-on-uefi-boot-screen/) from 2013. Their approach involves modifying the EDK II source code for its sample OVMF firmware, replacing the logo in the source. In NixOS, patching this file is relatively easy by using an overlay included in your Nix configuration. This overlay copies a local `Logo.bmp` over the one located within the package in the postPatch phase, and Nix does the work of compiling it. Since Nix defaults to using the EDK II package included within QEMU, we will also have to replace the EDK II package that's in QEMU with one we compile ourselves. This unfortunately does trigger a build of QEMU, which takes a little bit of time.

```nix
nixpkgs.overlays = [
  (final: prev: {
    OVMFFull = prev.OVMFFull.overrideAttrs (old: {
      postPatch =
        (old.postPatch or "")
        + ''
          cp ${./Logo.bmp} ./MdeModulePkg/Logo/Logo.bmp
        '';
    });

    qemu = prev.qemu.overrideAttrs (old: {
      postInstall =
        (old.postInstall or "")
        + ''
          cp -f ${final.OVMFFull.fd}/FV/OVMF_CODE.fd $out/share/qemu/edk2-x86_64-code.fd
          cp -f ${final.OVMFFull.fd}/FV/OVMF_CODE.ms.fd $out/share/qemu/edk2-x86_64-secure-code.fd
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

After then, you should be able to see your custom logo in place of the TianoCore default image.

{{< vid src="Boot.mp4" alt="QEMU/KVM Booting with a modified logo" max-height="60vh" >}}