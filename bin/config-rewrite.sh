#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

declare -a HOSTNAMES

for VHOST in $(ls -1 ${SCRIPT_DIR}/../conf/apache/*); do
    HOSTNAMES=()

    VHOST_SHORT=$(basename ${VHOST})

    HOSTNAMES+=($(grep -i ServerName ${VHOST} |awk '{print $2}'))
    for H in $(grep -i ServerAlias ${VHOST} |awk '{print $2}'); do
        HOSTNAMES+=(${H})
    done

    DOC_ROOT=$(grep -i 'DocumentRoot' ${VHOST} |sed -nr 's/^.+\/var\/www\/hotel\/html\/(.+)$/\1/p')

    CONF=""
    for H in ${!HOSTNAMES[@]}; do
        CONF+=$(echo -n "${HOSTNAMES[$H]},")
    done
    CONF=${CONF::-1}

    sed -r 's/\$\{HOSTNAMERULES\}/'"${CONF}/" ${SCRIPT_DIR}/../conf/traefik-conf.template.yml | sed -r 's~\$\{OWNERROOT\}~/var/hotel/home/'"${DOC_ROOT}~" > ${SCRIPT_DIR}/../conf/sites-available/${VHOST_SHORT}.yml
done
