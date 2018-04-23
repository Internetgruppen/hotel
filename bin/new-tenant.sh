#!/usr/bin/env bash
# Creates new database and ftp-users for tenants.
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Credentials for connecting to the database
MYSQL_CONFIG="${SCRIPT_DIR}/../conf/tenant.my.cnf"
MYSQL_CMD="mysql --defaults-extra-file=${MYSQL_CONFIG}"

# Mysql database that holds the ftp useres
MYSQL_PROFTPD_DB="hotel_proftpd"

# UID to use for ftp-users (nobody)
SHARED_UID=65534

# GID to use for ftp-users (nogroup)
SHARED_GID=65534

# Hotel Network CIDR in mysql wildcard format % = match all
HOTEL_NETWORK="172.19.%"

# TODO:
# - Trap errors?
# - Create apache/docker configuration?

if [[ ! -r "$MYSQL_CONFIG" ]] ; then
  echo "Could not read mysql-configuration from ${MYSQL_CONFIG}"
  exit 1
fi

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

if [[ $# -lt 2 ]] ; then
    echo "Syntax: $0 <username> <homedirpath>"
    echo "Eg: $0 sl2022 /var/hotel/home/arr/sl2022"
    echo "Usernames must be simple alpha-numerics"
    exit 1
fi

T_USERNAME=$1
T_HOMEDIR=$2
T_DB_NAME="tenant_${T_USERNAME}"

# Get a password for the ftp-user and crypt() it
T_PASSWORD=$(pwgen -1 10)
T_PASSWORD_CRYPT=$(echo ${T_PASSWORD} | ftpasswd --hash --stdin | cut -c11-)

# Get a password for the database
T_DB_PASSWORD=$(pwgen -1 10)

# Create homedir if it does not exist
# Set permissions on dir
if [[ ! -d "${T_HOMEDIR}" ]] ; then
    echo "Creating homedir ${T_HOMEDIR}"
    mkdir -p "${T_HOMEDIR}/webroot"
    chown -R ${SHARED_UID}:${SHARED_GID} ${T_HOMEDIR}
else
  echo "Using existing homedir ${T_HOMEDIR}"
fi;

# Create mysql database
$MYSQL_CMD -e "CREATE DATABASE ${T_DB_NAME}"
$MYSQL_CMD -e "GRANT ALL PRIVILEGES ON ${T_DB_NAME}.* to '${T_USERNAME}'@'${HOTEL_NETWORK}' identified by '${T_DB_PASSWORD}'"

# Create ftp user
$MYSQL_CMD ${MYSQL_PROFTPD_DB} -e "INSERT INTO users (userid, passwd, uid, gid, homedir) VALUES ('${T_USERNAME}', '${T_PASSWORD_CRYPT}', ${SHARED_UID}, ${SHARED_GID}, '${T_HOMEDIR}')"

echo "Created user ${T_USERNAME} with ftp password ${T_PASSWORD}"
echo "Created database ${T_DB_NAME} for database user ${T_USERNAME} with password ${T_DB_PASSWORD}"
