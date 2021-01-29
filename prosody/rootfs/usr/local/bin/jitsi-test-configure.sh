#!/bin/bash
export ENABLE_XMPP_WEBSOCKET=0
export PUBLIC_URL='bla.nu.me'
export JICOFO_SECRET=`openssl rand -hex 16`
export ENABLE_TURN=1
export TURN_DOMAIN="turn.bla.me"
export TURN_PASSWORD=`openssl rand -hex 16`
export ENABLE_AUTH=1
./jitsi-configure-global.sh
./jitsi-configure.sh
