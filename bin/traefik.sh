#!/bin/bash

# TODO: Do better than a simple docker run
# systemd service?
# maybe also docker-compose?
docker run -d --name traefik --network proxy --network hotel -p 8081:8081 -p 80:80 -p 443:443 -l traefik.port=8081 -l traefik.frontend.rule=Host:mysa.dds.dk -v /etc/traefik/traefik.toml:/etc/traefik/traefik.toml -v /etc/traefik/acme.json:/acme.json -v /var/run/docker.sock:/var/run/docker.sock traefik:1.4.4-alpine --docker
