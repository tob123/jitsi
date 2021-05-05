#!/bin/bash
TARGET_DIR=/data/data1/dockervols/jitsi/coturn/certs
CONTAINER=jitsi_turn_1
SOURCE_DIR=$RENEWED_LINEAGE
FULLCHAIN_SOURCE=fullchain.pem
PRIVKEY_SOURCE=privkey.pem
FULLCHAIN_TARGET=turn.fullchain.pem
PRIVKEY_TARGET=turn.privkey.pem
cp -u ${SOURCE_DIR}/${FULLCHAIN_SOURCE} ${TARGET_DIR}/${FULLCHAIN_TARGET}
cp -u ${SOURCE_DIR}/${PRIVKEY_SOURCE} ${TARGET_DIR}/${PRIVKEY_TARGET}
if [[ `docker inspect $CONTAINER | jq .[].State.Running` = "true" ]];then
  docker restart $CONTAINER
fi
