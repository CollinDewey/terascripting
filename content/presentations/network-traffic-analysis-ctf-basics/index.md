---
title: Network Traffic Analysis Basics
author: Collin Dewey
date: '2025-09-11'
type: Presentation
slug: network-traffic-analysis-ctf-basics
description: "Presentation slides for Network Traffic Analysis basics for beginner level Capture The Flag style cybersecurity challenges."
marp: true
class: invert
theme: default
size: 16:9
---

{{< slides >}}

## Network Traffic Analysis Basics
<!-- _footer: By Collin Dewey-->

For CTF Competitions

---

## What is Network Traffic Analysis?

Looking through network traffic (duh)

---

## Wireshark

Tool that we'll use to look through network traffic
- Network traffic is sent through chunks of data called packets
- Decodes packet data to something we can understand
- Search packet contents, and metadata
- Filters

## Tshark

Command line version of Wireshark
- Same filters as Wireshark
- Print specific parts of packet data

---

## Wireshark

Extract images from webpages with "File -> Export Objects -> HTTP"

See contents of a TCP stream by right clicking the packet and pressing "Follow -> TCP Stream"

[Wireshark Display Filters](https://wiki.wireshark.org/DisplayFilters)

---

## Some Common Protocols

- HTTP(S)
- FTP
- SMTP/POP3/IMAP
- DNS
- ICMP
- ARP

---

## HyperText Transfer Protocol (HTTP)

This is what everthing website related uses. Most commonly you'll see GET and POST requests to GET data from the server, or to POST data to the server.

GET request
```
GET /example.txt HTTP/1.1
Host: example.com
User-Agent: ExampleUserAgent/1.0.0
```

```
HTTP/1.1 200 OK
Content-Type: text/html; charset=UTF-8
Content-Length: 13

Hello there!
```

---

POST request
```
POST /endpoint HTTP/1.1
Host: example.com
User-Agent: ExampleUserAgent/1.0.0

somedata
```

Unencrypted
   - Plaintext data sent to servers
   - HTTP**S** is encrypted

---

## File Transfer Protocol (FTP)

For file transfers

---

## E-Mail

### SMTP
Sending mail

### POP3
Receiving mail
- Mail deleted server-side

### IMAP
Receiving mail but better
- Mail kept server-side
- Metadata synced


---

## Domain Name System (DNS)

What IP is example.com at? Ask a DNS server to find out!

```sh
$ dig +noall +answer example.com
example.com.            296     IN      A       23.215.0.138
example.com.            296     IN      A       23.220.75.232
example.com.            296     IN      A       23.192.228.80
example.com.            296     IN      A       23.215.0.136
example.com.            296     IN      A       23.220.75.245
example.com.            296     IN      A       23.192.228.84
```

---

## Internet Control Message Protocol (ICMP)

Notably
- 8 – Echo Request
- 0 – Echo Reply

---

## Address Resolution Protocol (ARP)

Get a MAC address from an IP address

---

### TCP

- 3 Way Handshake
    - SYN (Synchronize)
    - SYN-ACK (Synchronize-Acknowledge)
    - ACK (Acknowledge)
- Retransmits failures

### UDP

- Just sends information
- Hope they got it
