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
if [[ $ENABLE_TURN -eq 1 ]]; then
  cat <<EOF
config.useStunTurn = true;
EOF
fi
if [[ $ENABLE_TURN_P2P -eq 1 ]]; then
  cat <<EOF
config.p2p.useStunTurn = true;
EOF
fi
