#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

FILE=$1
PROJECT=$(basename -s '.yml' $FILE)
shift
docker-compose -f "${SCRIPT_DIR}/../conf/default.yml" -f ${FILE} -p ${PROJECT} $@
