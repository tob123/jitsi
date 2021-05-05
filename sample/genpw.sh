#!/bin/bash

generatePassword() {
    openssl rand -hex 16
}

JICOFO_AUTH_PASSWORD=$(generatePassword)
JVB_AUTH_PASSWORD=$(generatePassword)
AUTHORIZED_USER_PASS=$(generatePassword)
TURN_PASSWORD=$(generatePassword)

sed -i.bak \
    -e "s#JICOFO_AUTH_PASSWORD=.*#JICOFO_AUTH_PASSWORD=${JICOFO_AUTH_PASSWORD}#g" \
    -e "s#JVB_AUTH_PASSWORD=.*#JVB_AUTH_PASSWORD=${JVB_AUTH_PASSWORD}#g" \
    -e "s#AUTHORIZED_USER_PASS=.*#AUTHORIZED_USER_PASS=${AUTHORIZED_USER_PASS}#g" \
    -e "s#TURN_PASSWORD=.*#TURN_PASSWORD=${TURN_PASSWORD}#g" \
    "$(dirname "$0")/.env"
