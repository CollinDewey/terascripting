---
title: National Cyber League Tool List
author: Collin Dewey
date: '2024-10-25'
type: Article
slug: ncl-tool-list
description: "A list of tools I tend to use for the National Cyber League (NCL) Capture The Flag (CTF)"
---

# Tool List

These are the majority of the tools that I commonly use in the National Cyber League Capture the Flag challenge. If a tool is displayed like `this`, it likely came with your Linux install.

---

# OSINT
---

[OSINT Framework](https://osintframework.com/) - Lots of links to OSINT oriented websites, such as flights, weather, and public records

[Awesome OSINT](https://github.com/jivoi/awesome-osint) - Lots of links to OSINT

[TinEye](https://tineye.com/) - Reverse Image Search

[exiftool](https://exiftool.org/) - Image metadata viewer and editor

[exiftool Online](https://exif.tools/) - Online version of exiftool

[crt.sh](https://crt.sh/) - Certificate search tool

[ICANN Lookup](https://lookup.icann.org/en) - Lookup domain registration data

---
# Cryptography
---

[dCode](https://www.dcode.fr/en) - Lots of tools for cipher solving

[Rumkin](https://rumkin.com/tools/cipher/) - Lots of tools for cipher solving

[CyberChef](https://gchq.github.io/CyberChef/) - Lots of tools for data manipulation + ciphers

[RSA Calculator](https://www.tausquared.net/pages/ctf/rsa.html)/[RSA Calculator](https://www.cs.drexel.edu/~popyack/IntroCS/HW/RSAWorksheet.html) - Manual RSA calculations

[Ciphey](https://github.com/Ciphey/Ciphey) - Cipher solver tool


---
# Password Cracking
---

[Name-That-Hash](https://nth.skerritt.blog/) - Hash identification tool

[Hashcat](https://hashcat.net/hashcat/) - GPU Password Cracker ([Example Hashes](https://hashcat.net/wiki/doku.php?id=example_hashes))

[John the Ripper](https://github.com/openwall/john) - CPU Password Cracker

[ophcrack](https://ophcrack.sourceforge.io/) - LM&NTLM Cracker based on precomputed rainbow tables (Use XP Special)

[Hashcat Rules](https://github.com/n0kovo/hashcat-rules-collection) - Database of hashcat rules

[wordlistctl](https://github.com/BlackArch/wordlistctl) - CLI tool to search for wordlists

[pdf2john Online](https://hashes.com/en/johntheripper/pdf2john) - Online tool to extract the password hash from a PDF

[rar2john Online](https://hashes.com/en/johntheripper/pdf2john) - Online tool to extract the password hash from a RAR file

[zip2john Online](https://hashes.com/en/johntheripper/pdf2john) - Online tool to extract the password hash from a ZIP file

[7z2john Online](https://hashes.com/en/johntheripper/pdf2john) - Online tool to extract the password hash from a 7z file

[office2john Online](https://hashes.com/en/johntheripper/pdf2john) - Online tool to extract the password hash from a Microsoft Office document


---
# Forensics
---

[binwalk](https://github.com/ReFirmLabs/binwalk) - Extract files embedded inside other files

`strings` - List user readable strings within a file.

[Photorec](https://www.cgsecurity.org/wiki/photoRec) - File Recovery Utility

[Volatility](https://volatilityfoundation.org/) - RAM analysis tool

[WavSteg](https://github.com/ragibson/Steganography#WavSteg) - Extract data from a WAV

[Steghide](https://github.com/StegHigh/steghide) - Steganography tool

[StegOnline](https://georgeom.net/StegOnline/upload) - Steganography tool ([StegOnline Checklist](https://georgeom.net/StegOnline/checklist))

[OpenStego](https://www.openstego.com/) - Steganography tool

[Digital Invisible Ink Toolkit](https://diit.sourceforge.net/) - Steganography tool

[FTK Imager](https://www.exterro.com/digital-forensics-software/forensic-toolkit) - Disk dump analysis tool

[Unredacter](https://github.com/BishopFox/unredacter) - Depixelate text

[sherloq](https://github.com/GuidoBartoli/sherloq) - Image Forensics

---
# Log Analysis
---

`cut` - Cut strings by a delimiter and select one part

`uniq` - Deduplicates lines. `-c` can be used to count the lines. (Be sure to sort first)

`sort` - Sorts lines

[gron](https://github.com/tomnomnom/gron) - Make JSON greppable

[Python](https://www.python.org/) - Python, good for parsing JSON and custom binary data


---
# Network Traffic Analysis
---

[Wireshark](https://www.wireshark.org/) - Network Protocol Analyzer

[TShark](https://tshark.dev/) - Wireshark but CLI

[h264extractor](https://github.com/volvet/h264extractor) - Wireshark plugin to extract an H264 stream


---
# Scanning and Reconnaissance
---

[dirbuster](https://sourceforge.net/projects/dirbuster/) - Java-based website subfolder enumeration

[gobuster](https://github.com/OJ/gobuster) - Go-based website subfolder enumeration

[feroxbuster](https://github.com/epi052/feroxbuster) - Rust-based website subfolder enumeration

[crt.sh](https://crt.sh/) - Certificate search tool

---
# Web Application Exploitation
---

`curl` - Make custom network requests. (Custom POST)

[Burp Suite Community Edition](https://portswigger.net/burp/communitydownload) - Intercept and change website requests.


---
# Enumeration and Exploitation
---

[Ghidra](https://ghidra-sre.org) - Reverse Engineering Tool

[Decompiler Explorer](https://dogbolt.org) - See decompiler view from multiple tools

[Buffer Overflow Pattern Generator](https://wiremask.eu/tools/buffer-overflow-pattern-generator) - Calculate offsets of overwritten registers

[Linguist](https://github.com/github-linguist/linguist) - Language Detection Utility

[pwndbg](https://github.com/pwndbg/pwndbg) - GDB but useful

[dotPeek](https://www.jetbrains.com/decompiler) - Decompiler for .NET applications

[Vineflower](https://github.com/Vineflower/vineflower) - Decompiler for Java applications

[uncompyle6](https://pypi.org/project/uncompyle6) - Decompiler for Python Bytecode

[crxviewer](https://robwu.nl/crxviewer) - View Chrome extension source

<!---
# Linux Distro
---

There are a few different main "Cyber Security" Linux distros, with different purposes.

- Kali Linux
    - 
- ParrotOS

-->

---
# Other
---

[My Github Cyber List](https://github.com/stars/CollinDewey/lists/cyber)

---

## Good luck!