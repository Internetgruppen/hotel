#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# TODO: Do better than a simple docker run
# systemd service?
# maybe also docker-compose?
docker run -d \
  --name traefik \
  --network proxy \
  --network hotel \
  -p 8081:8081 \
  -p 80:80 \
  -p 443:443 \
  -l traefik.port=8081 \
  -l traefik.frontend.rule=Host:mysa.dds.dk \
  -v ${SCRIPT_DIR}/../conf/traefik.toml:/etc/traefik/traefik.toml \
  -v ${SCRIPT_DIR}/../acme.json:/acme.json \
  -v /var/run/docker.sock:/var/run/docker.sock \
  traefik:1.4.4-alpine --docker
