#!/bin/bash
if [[ $ENABLE_AUTH -eq 1 && $JWT_AUTH -eq 1 ]]; then

  echo "--prosody virtualhost auth custom options start"
  cat <<EOF
Component "muc.meet.jitsi" "muc"
    storage = "memory"
    modules_enabled = {
        "muc_meeting_id";
        "token_verification";
    }
    muc_room_locking = false
    muc_room_default_public_jids = true
EOF
  echo "--prosody virtualhost auth custom options end"
  exit 0
fi
echo "--prosody virtualhost auth custom options start"
  cat <<EOF
Component "muc.meet.jitsi" "muc"
    storage = "memory"
    modules_enabled = {
        "muc_meeting_id";
    }
    muc_room_locking = false
    muc_room_default_public_jids = true
EOF
  echo "--prosody virtualhost auth custom options end"
