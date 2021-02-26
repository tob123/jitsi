#!/bin/bash
cat <<EOF
if (!config.hasOwnProperty('hosts')) config.hosts = {};
config.hosts.domain = 'meet.jitsi';
config.focusUserJid = 'focus@auth.meet.jitsi';
EOF
if [[ $ENABLE_AUTH -eq 1 ]]; then
  cat <<EOF
config.hosts.anonymousdomain = 'guest.meet.jitsi';
config.hosts.authdomain = 'meet.jitsi';
EOF
fi
cat <<EOF
config.hosts.muc = 'muc.meet.jitsi';
config.bosh = '/http-bind';
EOF
if [[ $ENABLE_XMPP_WEBSOCKET -eq 1 ]]; then
  cat <<EOF
config.websocket = 'wss://${WS_DOMAIN}/xmpp-websocket';
EOF
fi
