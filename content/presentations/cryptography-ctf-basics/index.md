---
title: Cryptography Basics
author: Collin Dewey
date: '2024-09-12'
type: Presentation
slug: cryptography-ctf-basics
description: "Presentation slides for cryptography basics for beginner level Capture The Flag style cybersecurity challenges."
marp: true
class: invert
theme: default
size: 16:9
---
{{< slides >}}

## Cryptography Basics
<!-- _footer: By Collin Dewey-->
For CTF Competitions

{{< marp >}}
![bg invert right:55%](Pigpen_cipher_key.svg)
{{< /marp >}}{{< hugo >}}
<div style="filter: invert(1);">
{{< img src="Pigpen_cipher_key.svg" alt="Pigpen Cipher" min-width="30vw">}}
</div>
{{< /hugo >}}


<!-- Logo on the right is for the Pigpen Cipher -->


---

## What is Cryptograhpy?

<!-- Cryptography is an overarching field over trying to have secure and private communications, even in the presence of prying eyes. -->

Secure Communication

<br>
<br>

## What is a cipher?

<!-- The algorithm of how we get there. -->

How we get there


---
<!-- _class: -->


{{< marp >}}
![bg contain](ASCII-Table-wide.svg)
{{< /marp >}}{{< hugo >}}
<div style="background-color: #ffffff;">
{{< img src="ASCII-Table-wide.svg" alt="ASCII Table" max-height="auto">}}
</div>
{{< /hugo >}}


<!-- There are multiple ways to represent text. -->
<!-- One of the most common ways for English is with the ASCII encoding, which all of the bellow examples are in. -->
<!-- ASCII is just a way to store our normal English language characters into data. -->

---

## Common Different Representations of Text
<!-- _footer: Convert these using https://gchq.github.io/CyberChef/-->

<!-- However, you can represent that data itself in different ways. -->
<!-- Binary, Octal, Decimal, Hexadecimal, and Base64 -->
<!-- The data is still there, just represented to us differently. So I really wouldn't consider these a cipher-->

|Base|Encoding|ASCII|Result Text|Note|
|---|---|---|---|---|
|2|Binary|Moon|01001101 01101111 01101111 01101110|Digits 0-1|
|8|Octal|Magic|115 141 147 151 143|Digits 0-7|
|10|Decimal|Sunset|83 117 110 115 101 116|Digits 0-9|
|16|Hex|Elements|45 6C 65 6D 65 6E 74 73|Digits 0-9 and A-F|
|64|Base64|Celestial!|Q2VsZXN0aWFsIQ==|a-z, A-Z, 0-9. `=` or `==` as padding|

There exist other representations such as Morse Code and Braille

---
<!-- _footer: https://gchq.github.io/CyberChef/-->

{{< marp >}}
<iframe style="aspect-ratio: 16/9; height:100%;" src="https://gchq.github.io/CyberChef/" loading="lazy"></iframe>

---

{{< /marp >}}

## Common Ciphers

Rail Fence Cipher
- Requires number of "rails", with an optional offset
- el hr,hwaeyuHloTee o r o

Atbash Cipher
- Tllw, sld ziv blf?

Shift Cipher
- J bn epjoh xfmm

---

Vigenere Cipher
- Needs a key - "CTF"
- Ihtf mt jxft, B'r ieff

ROT13
- V ubarfgyl qba'g erzrzore jung V jebgr

Affine Cipher
- Trrk ijhf ro gwn HGQ <!-- a:3 b:1 -->

Substitution Cipher
- Replace a letter with another letter
- [quipquip](https://quipqiup.com/)

<!---
# Encryption
RSA - https://www.tausquared.net/pages/ctf/rsa.html
AES

---
# Data Manipulation
Bit Shifting/Rotation
XOR-->

---
## Other Symbols

{{< marp >}}
![bg fit](ICS-flags.jpg)
{{< /marp >}}{{< hugo >}}
{{< img src="ICS-flags.jpg" alt="International Code of Signals Flags" max-height="60vh">}}
{{< /hugo >}}


---
<!-- _class: -->
## Other Symbols
- Reverse Image Search

{{< marp >}}
![](Qapla.svg)
{{< /marp >}}{{< hugo >}}
<div style="background-color: #ffffff;">
{{< img src="Qapla.svg" alt="Qapla written in pIqaD script" min-width="40vw" max-height="30vh">}}
</div>
{{< /hugo >}}

<!--
---
# Cryptography Tools
<!-- Modern cryptographic methods are much more math oriented and complicated. -->
<!-- Most of them use some sort of key or certificate, and there are tools to manager those. -->
<!--
.PEM, .KEY, .CER, .P12, ...
- OpenSSL
https://github.com/Ciphey/Ciphey
-->