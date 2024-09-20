---
title: Password Cracking Basics
author: Collin Dewey
date: '2024-09-19'
type: Presentation
slug: password-cracking-basics
description: "Password Cracking Basics - For CTF Competitions"
marp: true
theme: default
class: invert
size: 16:9
---
<link rel="stylesheet" href="style.css"> <!-- Extra CSS for the presentation -->

# Password Cracking Basics
<!-- _footer: By Collin Dewey-->
![bg right:42%](https://www.kali.org/tools/hashcat/images/hashcat-logo.svg)

<!-- Logo on the right is for the Password Cracking utility Hashcat -->

For CTF Competitions

---

## Preface - Different Representations of ASCII
<!-- _footer: Convert these using https://gchq.github.io/CyberChef/-->

<!-- There are multiple ways to represent text. -->
<!-- One of the most common ways is with the ASCII encoding, which all of the bellow examples are in. -->
<!-- ASCII is just a way to store our normal English language characters into data. -->
<!-- However, you can represent that data itself in different ways. -->
<!-- Binary, Octal, Decimal, Hexadecimal, and Base64 -->
<!-- In reality, these are not <b>true</b> passwords. -->
<!-- The data is still there, just represented to us differently. -->
<!-- Some CTFs will include these in password cracking sections. -->

These are not <ins>passwords</ins>, rather different representations of the letters.

|Base|Encoding|ASCII|Result Text|Note|
|---|---|---|---|---|
|2|Binary|Moon|01001101 01101111 01101111 01101110|Digits 0-1|
|8|Octal|Magic|115 141 147 151 143|Digits 0-7|
|10|Decimal|Sunset|83 117 110 115 101 116|Digits 0-9|
|16|Hex|Elements|45 6C 65 6D 65 6E 74 73|Digits 0-9 and A-F|
|64|Base64|Celestial!|Q2VsZXN0aWFsIQ==|a-z, A-Z, 0-9. `=` or `==` as padding|

---

# Why do passwords need to be "cracked"?

<!-- People (unfortunately) tend to use the same password on multiple websites. -->
<!--Passwords are meant to be secret, even in the event of a data breach, your passwords should remain secret.-->
<!--To do this, passwords are hashed by websites.-->
<!--These are one input to one output math functions that are easy to perform one way, but hard the reverse way.-->

Passwords are hashed
- One-way function - cannot easily get password from hash
- Given the same input, always gives the same output
- No two inputs give the same output

If you hit "Forgot Password" and were emailed your password back, think again about using that service.

---

# Password Salting
<!-- _footer: Longer salts need to be used in reality -->

<!-- Passwords are often salted, which is adding a random extra data to the input password.-->
<!-- Below is an example of the same password, with different salts, resulting in different hashes.-->

Passwords are often "salted"
- Random data added as an input to the hashing algorithm
- Different salt per-password
- Salt is saved next to hash and isn't *secret*

|Algorithm|To Be Hashed|Hashed Value|
|---|---|---|
|md5("Cyber")|Cyber|046e43ea3926a2f12f416a870f995a62|
|md5("Cyber"+"hSgcC")|CyberhSgcC|79cca74badfe10909be5fd43a61e2f30|
|md5("Cyber"+"FQnJK")|CyberFQnLK|02401e65e4eb1f305e3cb6ae921198b6|

---

# Approaches

- Hash Tables
- Brute Force
- Dictionary

---

# Hash Tables

<!-- Why would people salt passwords? To prevent the usage of hash tables -->
Hash tables are precomputed lookup tables of passwords and their hashed variants which leads to near-instant decoding of hashes.

- Makes cracking common passwords trivial
- Salting would make these tables impossibly big

---

# Brute Force
Try every combination of characters for increasing lengths
- Might take a few lifetimes of the universe for longer passwords
```
abcdefghijklmnopqrstuvwxyz
ABCDEFGHIJKLMNOPQRSTUVWXYZ
0123456789
 !"#$%&'()*+,-./:;<=>?@[\]^_`{|}~
```
\+ Foreign Language Characters

---

# Dictionary Attacks
- Words are easy to remember
- People like remembering passwords

# RockYou
- Social Media Widget Maker Company
- Easy SQL Injection
- Stored 32 million user's passwords in plaintext
- This was dumb, even in 2009

---

# Common Hash Types
<!-- _footer: https://hashcat.net/wiki/doku.php?id=example_hashes-->

|Hash-Name|Example Hash|
|---|---|
|MD5|7ebc76247f2dc80d490199fad2113358|
|SHA1|2fc8f79f194c7a080bb629cf0a04f0c5cf653387|
|md5crypt|\$1\$oFJabixr\$P3CVha87xhby59qf2Hkpq/|
|NT:LM|9BC9CDAFDFDBFDF55BFA81527A37D05E:F6332EE5142AC368C401F065B6F57E69|

---

## [List of Example Hashes](https://hashcat.net/wiki/doku.php?id=example_hashes)
## [Name That Hash](https://nth.skerritt.blog/)
- There are multiple tools for identifying hashes, this is just one of them

---

# Online Hash Cracking Services
http://rainbowtables.it64.com/
- Cracks LM Hashes

https://hashes.com/en/decrypt/hash/
- Looks up MD5, SHA1, NTLM, SHA256, SHA512

https://crackstation.net/
- Looks up LM, NTLM, MD5, SHA1, SHA224, SHA256, SHA384, SHA512, whirlpool

---
<!-- _backgroundImage: "linear-gradient(45deg, #980000, #c05400, #d39b00, #347235, #0047ab, #29196f, #4f2d75);" -->
<!-- _class: invert -->
<!-- _footer: Some CTFs likes to use XP Special-->
# ophcrack
ophcrack is a free Windows (LM/NTLM) password cracker using Rainbow Tables

|Table|Charset|Length|GiB|
|---|---|---|--|
|XP Free Small|[0-9],[a-z],[A-Z]|1-14|.7
|XP Special*|[0-9],[a-z],[A-Z], !"#\$%&'()*+,-./:;<=>?@[\\]^_`{\|}~|1-14|7.5
|Vista Proba 60G|[0-9],[a-z],[A-Z], !"#\$%&'()*+,-./:;<=>?@[\\]^_`{\|}~|5-10|60
|Vista SpecialXL|[0-9],[a-z],[A-Z], !"#\$%&'()*+,-./:;<=>?@[\\]^_`{\|}~|1-7|107
|Vista eightXL|[0-9],[a-z],[A-Z], !"#\$%&'()*+,-./:;<=>?@[\\]^_`{\|}~|8|2007

---

# John The Ripper
<!-- _footer: https://hashes.com/en/johntheripper -->
![bg right:59%](https://www.kali.org/tools/john/images/john-logo.svg)

CPU Password Cracker

- 7z2john
- zip2john
- pdf2john
- office2john

---

# Hashcat
![bg right:42%](https://www.kali.org/tools/hashcat/images/hashcat-logo.svg)

GPU Accelerated Password Cracker

- Fast
- Can use multiple GPUs
- Multiple Attack Types

---

# Hashcat Attack Modes

|Mode #|Attack Type|Method|
|---|---|---|
|0|Dictionary Attack|Tries every password in the list
|1|Combinator Attack|Combines words from multiple wordlists
|3|Mask Attack|Smart brute-forcing
|6|Hybrid Attack|Wordlist + a mask
|7|Hybrid Attack|A mask + Wordlist

---

# Picking a Wordlist

- RockYou
- Find one online
- Make your own list
    - Scrape Wikipedia Articles
    - Kaggle (Dataset Website)

---

# Hashcat Arguments

Specify [hash type](https://hashcat.net/wiki/doku.php?id=example_hashes) with `-m #`
Specify attack mode with `-a #`
Speedup Arguments
- `-O` uses "optimized kernels". Limits max length.
- `-w #` sets the workload profile
    - 1 is Low
    - 2 is Normal
    - 3 is High - Will lag system GUI
    - 4 is "Nightmare" - Will lag system GUI

---

# Dictionary Attack (Mode 0)

```sh
hashcat -m 0 -a 0 MD5_Hash_File.txt wordlist.txt
```
>password

# Combinator Attack (Mode 1)

```sh
hashcat -m 0 -a 1 MD5_Hash_File.txt animal_names.txt city_names.txt
```
> WolfChicago

---

# Mask Attacks (Mode 3)

```sh
hashcat -m 0 -a 3 MD5_Hash_File.txt CTF-?u?u?u?u-?d?d?d?d
```
>CTF-AAAA-0000 through CTF-ZZZZ-9999

|Charset|Chars|Charset|Chars|
|---|---|---|---|
|?l|abcd....xyz|?u|ABCD....XYZ|
|?d|0123456789|?h|0123456789abcdef|
|?H|0123456789ABCDEF|?s| !"#$%&'()*+,-./:;<=>?@[\\]^_`{\|}~|
|?a|?l?u?d?s|?b|0x00 - 0xff|

---

# Hybrid Attacks (Mode 6)
```sh
hashcat -m 0 -a 6 MD5_Hash_File.txt wordlist.txt ?d?d?d?d
```
>password0000 through lastpassword9999

# Hybrid Attacks (Mode 7)
```sh
hashcat -m 0 -a 7 MD5_Hash_File.txt ?d?d?d?d wordlist.txt
```
>0000password through 9999lastpassword

---

# Rules
Works on Dictionary Attacks and Hybrid Attacks

- OneRuleToRuleThemAll (Universal Rule)
- Pantagrule (Universal Rule)
- toggles# (Toggles upper/lowercase of a word)
- leetspeak (l33t)

```sh
hashcat -m 0 -r leetspeak.rule -r toggles1.rule -a 0 MD5_Hash_File.txt wordlist.txt
```
> Passw0rd
> pa55woRd
---

# aircrack-ng
Crack WEP/WPA-PSK passwords

```sh
aircrack-ng -w dictionary.txt wireless.cap
```

# hcxtools
Convert wireless captures to JtR/Hashcat

---

# Useful Links
[Hashcat Example Hashes](https://hashcat.net/wiki/doku.php?id=example_hashes)

[Name That Hash](https://nth.skerritt.blog/)

[John The Ripper Tools Online](https://hashes.com/en/johntheripper)

# Wordlist Sites
[Weakpass](https://weakpass.com/)

[SecLists](https://github.com/danielmiessler/SecLists)

[`wordlistctl` CLI tool](https://github.com/BlackArch/wordlistctl)

# Hashcat Rules
[One Rule To Rule Them All](https://github.com/NotSoSecure/password_cracking_rules)

[Pantagrule](https://github.com/rarecoil/pantagrule)

[Kaonashi](https://github.com/kaonashi-passwords/Kaonashi)

[Hashcat Rules](https://github.com/hashcat/hashcat/tree/master/rules)

---