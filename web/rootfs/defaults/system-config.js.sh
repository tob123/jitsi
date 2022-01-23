#!/bin/bash
WS_DOMAIN=`echo $PUBLIC_URL | awk -F '/' {'print $3'}`
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
if [[ $DISABLE_XMPP_WEBSOCKET -eq 0 ]]; then
  cat <<EOF
config.websocket = 'wss://${WS_DOMAIN}/xmpp-websocket';
EOF
fi
if [[ $DISABLE_PREJOIN_PAGE -eq 0 ]]; then
  cat <<EOF
config.prejoinPageEnabled = true;
EOF
fi
if [[ -n $TOKEN_AUTH_URL ]]; then
  cat <<EOF
config.tokenAuthUrl = '${TOKEN_AUTH_URL}';
EOF
fi
