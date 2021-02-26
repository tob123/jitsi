#!/bin/bash

echo "----custom prosody global config options start----"
if [[ $ENABLE_XMPP_WEBSOCKET -eq 1 ]]; then
cat <<EOF
cross_domain_websocket = { "${PUBLIC_URL}","https://meet.jitsi" };
EOF
fi
if [[ $ENABLE_TURN -eq 1 ]]; then
cat <<EOF
turncredentials_secret = "${TURN_PASSWORD}";
turncredentials = {
  { type = "stun", host = "${TURN_DOMAIN}", port = "3478" },
  { type = "turn", host = "${TURN_DOMAIN}", port = "3478", transport = "udp" },
  { type = "turns", host = "${TURN_DOMAIN}", port = "5349", transport = "tcp" },
  { type = "turns", host = "${TURN_DOMAIN}", port = "443", transport = "tcp" }
};
EOF
fi
cat <<EOF
log = {
	{ levels = {min = "${PROSODY_LOG_LEVEL}"}, to = "console"};
}
EOF
echo "----custom prosody global config options end----"
