#!/bin/bash
echo "--prosody virtualhost configuration options start"
cat <<EOF
VirtualHost "meet.jitsi"
ssl = {
        key = "/etc/prosody/certs/meet.jitsi.key";
        certificate = "/etc/prosody/certs/meet.jitsi.crt";
    }
EOF
if [[ $ENABLE_AUTH -eq 1 ]]; then
  if [[ $JWT_AUTH -eq 1 ]]; then
    cat <<EOF
    authentication = "token"
    app_id = "${JWT_APP_ID}"
    app_secret = "${JWT_APP_SECRET}"
    allow_empty_token = false
EOF
  fi
fi
if [[ $ENABLE_AUTH -eq 0 ]]; then
  if [[ $DISABLE_XMPP_WEBSOCKET -eq 0 ]]; then
    cat <<EOF
    authentication = "token"
    app_id = ""
    app_secret = ""
    allow_empty_token = true
EOF
  else 
    cat <<EOF
    authentication = "anonymous"
EOF
  fi
fi
cat <<EOF
modules_enabled = {
      "bosh";
      "pubsub";
      "ping";
      "speakerstats";
      "conference_duration";
EOF
if [[ $DISABLE_XMPP_WEBSOCKET -eq 0 ]]; then
  cat <<EOF
  "websocket";
  "smacks";
EOF
fi
if [[ $ENABLE_TURN -eq 1 ]]; then
  cat <<EOF
      "external_services";
EOF
fi
if [[ $ENABLE_AUTH -eq 0 ]]; then
  cat <<EOF
      "muc_lobby_rooms";
EOF
fi
cat <<EOF
}
EOF
if [[ $ENABLE_AUTH -eq 0 ]]; then
  cat <<EOF
  main_muc = "muc.meet.jitsi";
  lobby_muc = "lobby.meet.jitsi";
  muc_lobby_whitelist = "recorder.meet.jitsi";
EOF
fi
cat <<EOF
    speakerstats_component = "speakerstats.meet.jitsi"
    conference_duration_component = "conferenceduration.meet.jitsi"
EOF

if [[ $ENABLE_AUTH -eq 1 ]]; then
  cat <<EOF
VirtualHost "guest.meet.jitsi"
    modules_enabled = {
      "muc_lobby_rooms";
EOF
  if [[ $ENABLE_TURN -eq 1 ]]; then
    cat <<EOF
      "external_services";
EOF
  fi
cat <<EOF
}
    authentication = "jitsi-anonymous"
  main_muc = "muc.meet.jitsi";
  lobby_muc = "lobby.meet.jitsi";
  muc_lobby_whitelist = "recorder.meet.jitsi";
EOF
fi

cat <<EOF
Component "focus.meet.jitsi" "client_proxy"
    target_address = "focus@auth.meet.jitsi"
EOF
echo "--prosody virtualhost configuration options end"
