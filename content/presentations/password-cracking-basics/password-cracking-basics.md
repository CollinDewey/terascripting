---
title: Password Cracking Basics (WIP)
author: Collin Dewey
date: '2024-07-03'
type: Presentation
slug: password-cracking-basics
description: "Password Cracking Basics - For CTF Competitions"
marp: true
theme: default
class: invert
size: 16:9
---
<link rel="stylesheet" href="style.css"> <!-- Extra CSS for the presentation -->

# Password Cracking Basics (WIP)
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
|2|Binary|Luna|01001100 01110101 01101110 01100001|Digits 0-1|
|8|Octal|Magic|115 141 147 151 143|Digits 0-7|
|10|Decimal|Sunset|83 117 110 115 101 116|Digits 0-9|
|16|Hex|Shimmer|53 68 69 6D 6D 65 72|Digits 0-9 and A-F|
|64|Base64|Celestia|Q2VsZXN0aWE=|a-z, A-Z, 0-9. `=` or `==` as padding|

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

If you hit "Forgot Password" and were emailed your password back - **RUN**

---

# Password Salting
<!-- _footer: Longer salts need to be used in reality -->

<!-- Passwords are often salted, which is adding a little random extra text to the input password.-->
<!-- Below is an example of the same password, with different salts, resulting in different hashes.-->

Passwords are often "salted"
- Random data added as an input to the hashing algorithm
- Different salt per-password
- Salt is saved next to hash and isn't *secret*

|Algorithm|To Be Hashed|Hashed Value|
|---|---|---|
|md5("Cyber")|Cyber|046e43ea3926a2f12f416a870f995a62|
|md5("Cyber"+"hSgcC")|CyberhSgcC|79cca74badfe10909be5fd43a61e2f30
|md5("Cyber"+"FQnJK")|CyberFQnLK|02401e65e4eb1f305e3cb6ae921198b6

---

# Hash Tables

<!-- Why would people salt passwords? To prevent the usage of hash tables -->
Hash tables are precomputed lookup tables of passwords and their hashed variants which leads to near-instant decoding of hashes

Precomputed lookup table of plaintext passwords and their hashed variants
Makes cracking common passwords trivial
Salting would make these tables impossibly big

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

#### [Name That Hash](https://nth.skerritt.blog/) - What is `48c/R8JAv757A`?
<!-- _footer: https://github.com/HashPals/Name-That-Hash-->
<iframe src="https://nth.skerritt.blog/"></iframe>

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
# ophcrack
ophcrack is a free Windows (LM/NTLM) password cracker using Rainbow Tables

---

# Hashcat

---

# John The Ripper


zip2john
pdf2john
docx2john

---

# Wordlists
(Rockyou)

Aircrack-ng
wlanpmk2hcx