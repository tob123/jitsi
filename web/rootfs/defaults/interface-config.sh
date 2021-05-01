#!/bin/bash
INTERFACE=/usr/share/jitsi-meet/interface_config.js
if [[ $ENABLE_JOIN_LEAVE_NOTIFICATIONS -eq 0 ]]; then
sed -i "/^\s*DISABLE_JOIN_LEAVE_NOTIFICATIONS:/ s~:.*~: true,~" $INTERFACE
fi
if [[ $ENABLE_FOCUS_INDICATOR -eq 0 ]]; then
sed -i "/^\s*DISABLE_FOCUS_INDICATOR:/ s~:.*~: true,~" $INTERFACE
fi

