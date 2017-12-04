#!/bin/bash

FILE=$1
PROJECT=$(basename -s '.yml' $FILE)
shift
docker-compose -f /etc/hotel/default.yml -f ${FILE} -p ${PROJECT} $@
