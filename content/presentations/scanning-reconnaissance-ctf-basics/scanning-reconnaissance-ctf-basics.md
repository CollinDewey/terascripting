---
title: Scanning & Reconnaissance Basics
author: Collin Dewey
date: '2024-10-03'
type: Presentation
slug: scanning-reconnaissance-ctf-basics
description: "Presentation slides for scanning and reconnaissance basics for beginner level Capture The Flag style cybersecurity challenges"
marp: true
class: invert
theme: default
size: 16:9
---

# [Presentation Slides](slides.html)

# Scanning & Reconnaissance Basics

For CTF Competitions

---

# What is Scanning & Reconnaissance?

Scanning
- Probing systems to identity what data they are sending out
Reconnaissance
- Gathering information about a target

---

# What is a port?

- 65536 ports
- Data Transport
    - TCP/UDP
- Where servers "listen" for incomming connections

---

# Common Services/Ports

|Port|Service|Acronym|
|---|---|---|
|21|File Transfer Protocol|FTP|
|22|Secure Shell|SSH|
|25|Simple Mail Transfer Protocol|SMTP|
|53|Domain Name System|DNS|
|80|Hypertext Transfer Protocol|HTTP|
|110|Post Office Protocol|POP3|
|123|Network Time Protocol|NTP|
|143|Internet Message Access Protocol|IMAP|
|389|Lightweight Directory Access Protocol|LDAP|
|443|Secure Hypertext Transfer Protocol|HTTPS|
|631|Common Unix Printing System|CUPS|

---

# Scanning Computers

[nmap](https://nmap.org/)
- Scans for open ports
- `nmap -p- [target]` To Scan TCP
- `nmap -sU [target]` To Scan UDP
    - UDP scans are often unreliable



---

# nmap Script Engine

- [FTP-Brute](https://nmap.org/nsedoc/scripts/ftp-brute.html)
- [HTTP-Brute](https://nmap.org/nsedoc/scripts/http-brute.html)
- [IMAP-Brute](https://nmap.org/nsedoc/scripts/imap-brute.html)
- [SMTP-Enum-Users](https://nmap.org/nsedoc/scripts/smtp-enum-users.html)
- `nmap --script [script] -p [port] [target]`

---

# netcat/nc/ncat

- Network 
- TCP/UDP

```
nc <IP> <PORT>
nc google.com 80
nc -u 1.1.1.1 53
echo "GET /" | nc google.com 80
```

---

# Scanning Websites

- [dirbuster](https://sourceforge.net/projects/dirbuster/)/[feroxbuster](https://github.com/epi052/feroxbuster)
    - Uses a wordlist to enumerate existing folders
    - `feroxbuster -u <target> -w <wordlist>`
- [bbot](https://github.com/blacklanternsecurity/bbot)
    - Subdomain enumeration, Web Crawler
    - `bbot -t <target> -p subdomain-enum`
- Special Website Files
    - \<domain\>.\<tld\>/robots.txt
    - \<domain\>.\<tld\>/sitemap.xml

---

# [Shodan](https://www.shodan.io/)

- Search engine for IPs

---

# Wordlists for Scanning

[Common Names](https://download.weakpass.com/wordlists/1452/common-names.txt.gz )

[FTP Default User:Pass](https://github.com/danielmiessler/SecLists/blob/master/Passwords/Default-Credentials/ftp-betterdefaultpasslist.txt)

[Directory List (*buster)](https://github.com/daviddias/node-dirbuster/tree/master/lists)