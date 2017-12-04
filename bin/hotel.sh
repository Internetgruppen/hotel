#!/bin/bash

if [[ $(id -u) -gt 0 ]]; then
	echo "You need to be root"
	exit 1
fi

COMMAND=$1

if [[ $COMMAND == "up" ]]; then
	COMMAND="up -d --build"
fi

for S in $(ls -1 /etc/hotel/sites-enabled/*.yml); do
	./compose.sh "${S}" ${COMMAND}
done
