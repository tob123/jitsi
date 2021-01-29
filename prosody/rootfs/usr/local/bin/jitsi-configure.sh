#!/bin/bash
echo "--prosody virtualhost configuration options start"
cat <<EOF
VirtualHost "meet.jitsi"
ssl = {
        key = "/etc/prosody/certs/meet.jitsi.key";
        certificate = "/etc/prosody/certs/meet.jitsi.crt";
    }
EOF
if [[ $ENABLE_AUTH -eq 0 ]]; then
  if [[ $ENABLE_XMPP_WEBSOCKET -eq 1 ]]; then
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
if [[ $ENABLE_XMPP_WEBSOCKET -eq 1 ]]; then
  cat <<EOF
  "websocket";
  "smacks";
EOF
fi
if [[ $ENABLE_TURN -eq 1 ]]; then
  cat <<EOF
      "turncredentials";
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
      "turncredentials";
EOF
  fi
cat <<EOF
}
EOF
  if [[ $ENABLE_XMPP_WEBSOCKET -eq 1 ]]; then
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
  cat <<EOF
  main_muc = "muc.meet.jitsi";
  lobby_muc = "lobby.meet.jitsi";
  muc_lobby_whitelist = "recorder.meet.jitsi";
EOF
fi

if [[ -z $JICOFO_SECRET ]]; then
   1>&2 echo 'FATAL ERROR: Jicofo component secret and auth password must be set'
   exit 1
fi
cat <<EOF
Component "focus.meet.jitsi"
    component_secret = "${JICOFO_SECRET}"
EOF
echo "--prosody virtualhost configuration options end"
