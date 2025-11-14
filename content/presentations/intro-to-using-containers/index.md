---
title: Introduction to Using Containers
author: Collin Dewey
date: '2025-11-09'
type: Presentation
slug: intro-to-using-containers
description: "A hands-on presentation with a quick overview on Docker and Podman, how to install them on both Windows and Linux, and some examples using compose."
marp: true
class: invert
theme: default
size: 16:9
---

{{< slides >}}

## Introduction to Using Containers
<!-- _footer: By Collin Dewey-->

{{< marp >}}
![bg right:40% 90%](docker.svg)
{{< /marp >}}{{< hugo >}}
{{< img src="docker.svg" alt="Docker Engine Logo" min-width="40vw" max-height="30vh">}}
{{< /hugo >}}

---

## Machine in a Machine
<!-- Normally done with a VM, but using a bunch of kernel features, we can get most the way there with less of a performance penalty-->

- Can run temporary software
- Can easily use hyper-specific setups
    - Works on my machine
- Don't need to deal with distro specifics


---

## Install Docker - Linux

### Docker
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh
```

### Podman
```sh
sudo dnf install podman
sudo apt install podman
```

---

## Install Docker - Windows
<!-- _footer: To install Winget - Admin Pwsh - `irm winget.pro | iex`-->

### Install WSL (reboot if needed)
`wsl --install`

### Docker
```sh
winget install Docker.DockerDesktop
```
### Podman
```sh
winget install RedHat.Podman Docker.DockerCompose
podman machine init
podman machine start
```

---

## docker run

Download and run a container
```sh
docker run hello-world
```

---

`-it`
- --interactive
- --tty

```sh
docker run -it debian
cat /etc/os-release
```

---

`Image:Tag`

```sh
docker run -it debian:11
cat /etc/os-release
```

---

## Where to find images

[Docker Hub](https://hub.docker.com/)

[GitHub](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)

---

`--publish [HOST PORT]:[CONTAINER PORT]`
`-p`

```sh
docker run -p 8080:80 httpd
```

---

`--detach`
`-d`

```sh
docker run -p 8080:80 -d httpd
```

---

## List and manage containers

Lists containers

|Command|Action|
|---|---|
|docker ps|Lists running containers|
|docker ps -a|Lists running and stopped containers|
|docker stop [CONTAINER]|Stops an existing container|
|docker start [CONTAINER]|Starts an existing container|
|docker rm [CONTAINER]|Deletes an existing container|
|docker logs [CONTAINER]|Views the logs of a container|
|docker logs -f [CONTAINER]|Follow the logs of a container|


---

`--name` to name a container
`--volume [HOST PATH]:[CONTAINER PATH]`

```sh
docker run --name web-server -v ./:/usr/local/apache2/htdocs -p 8080:80 -d httpd
```

---

```sh
docker exec -it [CONTAINER] [CMD]
docker exec -it web-server bash
```

---

## Some cleanup

```
docker container prune
docker image prune
docker network prune
```

Usually just use
```
docker system prune -a
```

---

## Compose

Define multiple containers in YAML

`compose.yml` or `docker-compose.yml`
```yaml
services:
  mc:
    image: itzg/minecraft-server:latest
    ports:
      - "25565:25565"
    environment:
      EULA: "TRUE"
    volumes:
      - ./data:/data
```

---

## Using Compose

```sh
docker compose up -d
docker compose down
docker compose logs
```

`--file`
```sh
docker compose -f ./folder/compose-file.yml up -d
```

---

## Let's run a search engine

[SearXNG](https://docs.searxng.org/)
```yaml
services:
  searxng:
    image: searxng/searxng
    container_name: searxng
    ports:
      - "8080:8080"
    volumes:
      - ./config:/etc/searxng
      - ./data:/var/cache/searxng
    restart: unless-stopped
```

---

## Media Server

[Jellyfin](https://jellyfin.org/docs/general/installation/container/)
```yaml
services:
  jellyfin:
    image: jellyfin/jellyfin
    container_name: jellyfin
    ports:
      - 8096:8096/tcp
      - 7359:7359/udp
    volumes:
      - ./config:/config
      - ./cache:/cache
      - ./media:/media
    restart: unless-stopped
```

---

## Ad Blocking DNS Server

[AdGuardHome](https://github.com/AdguardTeam/AdGuardHome)

Needs rootful docker/podman
```yaml
services:
  adguardhome:
    image: adguard/adguardhome
    ports:
      - 53:53/tcp
      - 53:53/udp
      - 8080:80/tcp
      - 3000:3000/tcp
    volumes:
      - ./config:/opt/adguardhome/conf
      - ./work:/opt/adguardhome/work
```