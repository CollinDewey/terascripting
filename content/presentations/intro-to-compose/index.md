---
title: Introduction to Compose
author: Collin Dewey
date: '2025-02-20'
type: Presentation
slug: intro-to-compose
description: "A presentation covering Podman or Docker Compose, why you would want to use it, and an overview of how to use it"
marp: true
class: invert
theme: default
size: 16:9
---

<link rel="stylesheet" href="../presentations.css">
{{< slides >}}

## Compose
<!-- _footer: By Collin Dewey-->

Docker/Podman Compose

---

## What is Compose?

Managing multiple containers at a time.
Managing multiple networks at a time.

---

## Why use it over regular Docker or Kubernetes?

Kubernetes has lots of features that many people just don't need.
Running a bunch of different CLI commands for managing multiple containers is a pain.

---

## What is in compose.yml

YAML Formatted File with definitions of...
- Services
- Networks
- Volumes
- Secrets

---

## Services [^1]
<!-- _footer: docs.docker.com/reference/compose-file/services -->

- Name
- OCI Image
- Command
- Volumes
- Port Forwards
- Container Dependencies
- CPU/RAM Quotas
- Capabilities
- Environment Variables
- Labels

[^1]: https://docs.docker.com/reference/compose-file/services/

---

## Service Example

```yaml
services:
  hugo:
    container_name: hugo
    image: klakegg/hugo
    command: --watch --destination /dest
    environment:
     - HUGO_ENV=production
    networks:
      - internal-network
    volumes:
      - ./src:/src
      - web-build-volume:/dest
    restart: unless-stopped
```
---
```yaml
  nginx:
    container_name: nginx
    image: nginx:alpine
    mem_limit: 512m
    cpu_count: "4"
    labels:
      - are.containers.cool=true
    ports:
      - 8080:8080
    depends_on:
      - hugo
    networks:
      - web
      - internal-network
    volumes:
      - web-build-volume:/usr/share/nginx/html:ro
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
      - ./site.conf:/etc/nginx/conf.d/default.conf:ro
    restart: unless-stopped
```

---

## Networks [^2]
<!-- _footer: docs.docker.com/reference/compose-file/networks -->

Networks can be defined through Compose files

- Name
- Driver
- Labels
- Internal/External
  - Internal networks are created by compose
  - External networks are managed elsewhere (such as with Docker CLI)

---

```yaml
networks:
  web-network:
    name: web-network
    external: true
  internal-network:
    name: internal-network
    driver: bridge
```

[^2]: https://docs.docker.com/reference/compose-file/networks/

---

## Volumes [^3]
<!-- _footer: docs.docker.com/reference/compose-file/volumes -->

Persistent folders that can be used across services

- Name
- Driver
- Labels
- External

```yaml
volumes:
  web-build-volume:
```

[^3]: https://docs.docker.com/reference/compose-file/volumes/

---

## Secrets [^4]
<!-- _footer: docs.docker.com/reference/compose-file/secrets-->

Secrets are data placed into the running container

- Files
- Environment Variables

```yaml
secrets:
  cool_flag:
    file: ./flag.txt
```
Copies `flag.txt` to `/run/secrets/cool_flag` within the container.

[^4]: https://docs.docker.com/reference/compose-file/secrets/

---

## Running Compose

|docker compose|Purpose|
|---|---|
|up|Creates the containers, pulls or builds missing images|
|down|Tears down the containers, networks|
|logs|Prints STDOUT/STDERR from the container|
|pull|Downloads/Updates images, but doesn't start containers|
|top|Lists internel container processes|
|exec (...)|Run command within container|

---

### Compose Flags

|docker compose|Purpose|
|---|---|
|-f (PATH)|Use (PATH) as the compose.yml|
|up -d|Detach container, non-interactive|
|up --no-recreate|Uses existing containers|
|logs -f|Follows logs|


---

### What commands do I use most often?

```sh
docker compose pull
docker compose down
docker compose up --no-recreate -d
```

---

## Container Management Tools

|Name|Purpose|
|---|---|
|lazydocker|Look through containers, their logs, volumes, etc.|
|ctop|TUI for basic container managment.|
|dive|Looking through container layers.|

---

## Notes
Docker used to not come with compose. Instead using a package named docker-compose.
- Use `docker-compose` instead of `docker compose`
- Use `docker-compose.yml` instead of `compose.yml`

Podman Compose works as a drop-in replacment of Docker Compose