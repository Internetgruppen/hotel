#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ $(id -u) -gt 0 ]]; then
	echo "You need to be root"
	exit 1
fi

COMMAND=$1

if [[ $COMMAND == "up" ]]; then
	COMMAND="up -d --build"
fi

for S in $(ls -1 ${SCRIPT_DIR}/../conf/sites-enabled/*.yml); do
	./compose.sh "${S}" ${COMMAND}
done
