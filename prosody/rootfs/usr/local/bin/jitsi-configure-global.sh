#!/bin/bash

echo "----custom prosody global config options start----"
if [[ $DISABLE_XMPP_WEBSOCKET -eq 0 ]]; then
cat <<EOF
consider_websocket_secure = true;
EOF
fi
if [[ $ENABLE_TURN -eq 1 ]]; then
cat <<EOF
external_service_secret = "${TURN_PASSWORD}";
external_services = {
  { type = "stun", host = "${TURN_DOMAIN}", port = 3478 },
  { type = "turn", host = "${TURN_DOMAIN}", port = 3478, transport = "udp", secret = true, ttl = 86400, algorithm = "turn" },
  { type = "turns", host = "${TURN_DOMAIN}", port = 5349, transport = "tcp", secret = true, ttl = 86400, algorithm = "turn" },
  { type = "turns", host = "${TURN_DOMAIN}", port = 443, transport = "tcp", secret = true, ttl = 86400, algorithm = "turn" }
};
EOF
fi
cat <<EOF
log = {
	{ levels = {min = "${PROSODY_LOG_LEVEL}"}, to = "console"};
}
EOF
echo "----custom prosody global config options end----"
