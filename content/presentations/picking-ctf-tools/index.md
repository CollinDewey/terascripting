---
title: Which CTF tool should I use?
author: Collin Dewey
date: '2025-10-23'
lastmod: '2025-10-23'
type: Presentation
slug: picking-ctf-tools
description: "Which CTF tool should I use to complete a problem? How do I start?"
marp: true
theme: default
size: 16:9
---

{{< slides >}}

## Which CTF tool should I use?
<!-- _footer: By Collin Dewey-->

---

## Open Source Intelligence - Searching

Google
- You've heard of this one before

Google "Dorking"
- Using [search filters](https://gist.github.com/sundowndev/283efaddbcf896ab405488330d1bbc06) to your advantage

---

## Open Source Intelligence - Reverse Image Search

Google Images
Yandex Images
- General Image Search

Tineye
- Exact Search
- Less likely to bring up results

---

## Open Source Intelligence - Mapping

Google Maps
- Street View
    - "See more dates"

OpenStreetMap
- Open Source Mapping Program

Overpass Turbo
- Complex Queries
- Building near building near building

---

## Open Source Intelligence - Websites

[crt.sh](https://crt.sh/)
- Certificates
- Find subdomains

[ICANN Lookup](https://lookup.icann.org/en)
- Website registrant
- Creation date
- Updated date
- Expiration date

---

## Open Source Intelligence - Where to find more tools?

[OSINT Framework.com](https://osintframework.com/)
- Tree diagram for finding websites that cover certain topics

[Awesome OSINT](https://github.com/jivoi/awesome-osint)
- Large list of OSINT tools

---

## Cryptography - ASCII

| Encoding | Example |
|----------|---------|
| [Binary](https://gchq.github.io/CyberChef/#recipe=From_Binary('Space',8)) | 01001000 01101001 |
| [Hexadecimal (Hex)](https://gchq.github.io/CyberChef/#recipe=From_Hex('Auto')) | 48 65 6c 6c 6f 20 74 68 65 72 65 |
| [Octal](https://gchq.github.io/CyberChef/#recipe=From_Octal('Space')) | 117 143 164 141 154 |
| [Decimal](https://gchq.github.io/CyberChef/#recipe=From_Decimal('Space',false)) | 79 99 116 97 108 |

---

## Cryptography - Cipher

Seeing giberish text? Probably a cipher. Some common ones

- [Morse](https://gchq.github.io/CyberChef/#recipe=From_Morse_Code('Space','Line%20feed'))
    - .... . .-.. .-.. --- -.-.--
- [Rail Fence](https://gchq.github.io/CyberChef/#recipe=Rail_Fence_Cipher_Decode(2,0))
    - HloTeeel hr
- [Atbash](https://gchq.github.io/CyberChef/#recipe=Atbash_Cipher())
    - Zgyzhs dll
- [Vigenère Cipher](https://gchq.github.io/CyberChef/#recipe=Vigen%C3%A8re_Decode(''))
    - Jxqnh yjxwg
    - Needs a key


---

- [Affine Cipher](https://gchq.github.io/CyberChef/#recipe=Affine_Cipher_Decode(3,1))
    - Bqqzon zd hrri
- [ROT13](https://gchq.github.io/CyberChef/#recipe=ROT13())
    - Uryyb gurer
- [Shift Cipher](https://gchq.github.io/CyberChef/#recipe=ROT13(true,true,false,-1))
    - Ifmmp uifsf
- [ROT8000](https://gchq.github.io/CyberChef/#recipe=ROT8000())
    - 籞籷籲籬籸籭籮 籲籼 籬籸籸籵
- [Substitution Cipher](https://quipqiup.com/)
    - Hleeo thlrl (Swaps e and l)

[dCode](https://www.dcode.fr/en)

[Rumkin](https://rumkin.com/tools/cipher/)

[CyberChef](https://gchq.github.io/CyberChef/)

---

## Cryptography - RSA

Seeing something like `e = 17`?

[RSA Calculator](https://www.tausquared.net/pages/ctf/rsa.html)
- Decode characters one number by one, then convert "from decimal"

---

## Password Cracking

Only tool you need
- [Hashcat](https://hashcat.net/hashcat/)
    - [Example Hashes](https://hashcat.net/wiki/doku.php?id=example_hashes)
    - [Name-That-Hash](https://nth.skerritt.blog/)

Datasets to make wordlists
- [Kaggle](https://www.kaggle.com/)
- [Wikidata Query Service](https://query.wikidata.org/)

See a password protected PDF/RAR/ZIP/7z/Office file?

[pdf2john](https://hashes.com/en/johntheripper/pdf2john), [rar2john](https://hashes.com/en/johntheripper/rar2john), [zip2john](https://hashes.com/en/johntheripper/zip2john), [7z2john](https://hashes.com/en/johntheripper/7z2john), [office2john](https://hashes.com/en/johntheripper/office2john)

---

## Forensics - Steganography

See an image with no other context? Maybe hidden data is inside.

[StegOnline](https://georgeom.net/StegOnline/upload)
 - [StegOnline Checklist](https://georgeom.net/StegOnline/checklist)

[Digital Invisible Ink Toolkit](https://diit.sourceforge.net/)

[Steghide](https://github.com/StegHigh/steghide)

[OpenStego](https://www.openstego.com/)

[sherloq](https://github.com/GuidoBartoli/sherloq)

Audio and not an image?
[WavSteg](https://github.com/ragibson/Steganography#WavSteg)

---

## Forensics - Binary Files/Drive Images

Look through a file

- [ImHex](https://imhex.werwolv.net/)
- `strings`

Extract files from a file (carving)

- [binwalk](https://github.com/ReFirmLabs/binwalk)
- [foremost](https://salsa.debian.org/rul/foremost/tree/debian/sid)
- [Photorec](https://www.cgsecurity.org/wiki/photoRec)
- [FTK Imager](https://www.exterro.com/digital-forensics-software/forensic-toolkit)
- [CyberChef](https://gchq.github.io/CyberChef/#recipe=Extract_Files(true,true,true,true,true,true,true,true,100))

---

## Forensics - Misc

Image Metadata?
- exiftool
- [CyberChef](https://gchq.github.io/CyberChef/#recipe=Extract_EXIF())

RAM/Memory Analysis?
- [Volatility](https://volatilityfoundation.org/)

Blurry text?
- [Unredacter](https://github.com/BishopFox/unredacter)

Other?
- [Awesome Forensics](https://github.com/cugu/awesome-forensics)

---

## Log Analysis

Log File to look through?
- [LNAV](https://github.com/tstack/lnav)

Something more complicated?
- Standard Linux Tools (cut, uniq, sort, awk)
- Ask an LLM to make you a Python script

---

## Network Traffic Analysis

General analysis
- [Wireshark](https://www.wireshark.org/)

Bulk analysis/statistics
- [TShark](https://tshark.dev/)

---

## Scanning and Reconnaissance

Need to find what ports are open? Or a service version?
- [nmap](https://nmap.org/)

Need to find subdomains?
- [dirbuster](https://sourceforge.net/projects/dirbuster/)
- [gobuster](https://github.com/OJ/gobuster)
- [feroxbuster](https://github.com/epi052/feroxbuster)

---

## Web Application Exploitation

Easy Problem?
- F12/CTRL+SHIFT+I Developer Tools
- Look through the website source
- Look through website Javascript
- Check out cookies

What tech stack is this website using?
- [Wappalyzer](https://www.wappalyzer.com/)

Need to modify a request? repeat it? intercept it? make a new one?
- [Burp Suite Community Edition](https://portswigger.net/burp/communitydownload)
- [cURL](https://curl.se/)

---

## Enumeration and Exploitation

What language is this? (text)
- Probably one of Python, Ruby, Perl, Lua
- Ask AI

What language is this? (file)
- `file`
- Open it up in [Ghidra](https://ghidra-sre.org/) and look around
    - Probably C or C++

---

## Enumeration and Exploitation - Decompilers

| Type | Language | Tool |
|----------|------|-------|
| exe/msi | .NET | [dotPeek](https://www.jetbrains.com/decompiler) |
| jar | Java |[Vineflower](https://github.com/Vineflower/vineflower) |
| pyc | Python | [uncompyle6](https://pypi.org/project/uncompyle6) |
| crx | Javascript| [crxviewer](https://robwu.nl/crxviewer) |
| ELF | ? | [Ghidra](https://ghidra-sre.org/) |
| ELF | ? | [dogbolt](https://dogbolt.org/) |

---