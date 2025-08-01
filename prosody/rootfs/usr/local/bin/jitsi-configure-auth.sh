#!/bin/bash
if [[ $ENABLE_AUTH -eq 1 && $JWT_AUTH -eq 1 ]]; then

  echo "--prosody virtualhost auth custom options start"
  cat <<EOF
Component "muc.meet.jitsi" "muc"
    storage = "memory"
    modules_enabled = {
        "muc_meeting_id";
        "muc_password_whitelist";
    }
    muc_room_locking = false
    muc_room_default_public_jids = true
    muc_password_whitelist = "focus@auth.meet.jitsi"
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
        "muc_password_whitelist";
    }
    muc_room_locking = false
    muc_room_default_public_jids = true
    muc_password_whitelist = "focus@auth.meet.jitsi"
EOF
  echo "--prosody virtualhost auth custom options end"
