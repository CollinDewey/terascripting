---
title: Forensics Basics
author: Collin Dewey
date: '2024-10-03'
type: Presentation
slug: forensics-ctf-basics
description: "Forensics Basics - For CTF Competitions"
marp: true
class: invert
theme: default
size: 16:9
---
# [Presentation Slides](/slides/forensics-ctf-basics.html)


# Forensics Basics

For CTF Competitions

---

# What is forensics?

Identify/Obtain Evidence

---

# Carving

binwalk

- Scans a file for files within the data
- `binwalk --dd='.*' <file>`

strings

- Shows you possibly strings within a binary file
- `strings -n 6 <file>`

photorec

- Data Recovery Tool

---

# Filesystem Forensics

RAW Image - A copy of the raw bytes that are stored on a hard drive.

- NTFS Master File Table (NT File System)
    - List of files & their metadata
    - MFT-Parsers
- Tools
    - FTKImager (Windows)
    - Autopsy (Windows)

---

# Windows Registry

Where Windows stores a lot of configuration

- RegRipper
    - Dump/Parse Registry

---

# RAM Forensics

Volatility

- Image Information
- Process List
- Process Dump
- Memory Dump
- Handle Info
- Registry Dump
- File Dump

---

# Steganography

- Hide special data within seemingly innocent data (Not metadata)
- Usually images or audio
    - Lossless formats

---

# Steganography Methods
- BlindHide
    - Changes the Least Significant Bit of Colors, and uses them for data
    - Starts at top left, works its way right, then down
    - Not secure
- HideSeek
    - Uses a password to generate a seed for where the first part of the data is
    - Continues to pick random spots based on that seed
    - BlindHide but "secure"
- FilterFirst
- BattleSteg

---

# Steganography Tools

Any advanced photo editor (Paint.NET, Krita, GIMP, Photoshop, Photopea)

[Digital Invisible Ink Toolkit](https://diit.sourceforge.net/)

[OpenStego](https://www.openstego.com/)

[Sherloq](https://github.com/GuidoBartoli/sherloq)

[StegOnline Checklist](https://georgeom.net/StegOnline/checklist)

---

# Unredacter

De-pixelate Text
- Specific font
- Specific blur block size
- Specific pixelation filter

![bg right contain](https://github.com/BishopFox/unredacter/blob/main/img/wow_such_secrets.gif?raw=true)