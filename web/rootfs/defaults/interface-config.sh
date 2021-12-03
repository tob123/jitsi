#!/bin/bash
INTERFACE=/usr/share/jitsi-meet/interface_config.js
if [[ $ENABLE_JOIN_LEAVE_NOTIFICATIONS -eq 0 ]]; then
sed -i "/^\s*DISABLE_JOIN_LEAVE_NOTIFICATIONS:/ s~:.*~: true,~" $INTERFACE
fi
if [[ $ENABLE_FOCUS_INDICATOR -eq 0 ]]; then
sed -i "/^\s*DISABLE_FOCUS_INDICATOR:/ s~:.*~: true,~" $INTERFACE
fi
if [[ -n $CUSTOM_PAGE_TITLE ]]; then
sed -i "s/ APP_NAME: 'Jitsi Meet'/ APP_NAME: '${CUSTOM_PAGE_TITLE}'/" $INTERFACE
fi
if [[ -n $CUSTOM_HEADER_TITLE ]]; then
find /usr/share/jitsi-meet/lang -name '*.json' | xargs sed -i 's/"headerTitle": "Jitsi Meet"/"headerTitle": "'"${CUSTOM_HEADER_TITLE}"'"/'
sed -i 's/"headerTitle":"Jitsi Meet"/"headerTitle":"'"${CUSTOM_HEADER_TITLE}"'"/' /usr/share/jitsi-meet/libs/app.bundle.min.js
fi
if [[ -n $CUSTOM_HEADER_SUBTITLE ]]; then
find /usr/share/jitsi-meet/lang -name '*.json' | xargs sed -i 's/"headerSubtitle": "Secure [a-z ]*"/"headerSubtitle": "'"${CUSTOM_HEADER_SUBTITLE}"'"/'
sed -i 's/"headerSubtitle":"Secure [a-z ]*"/"headerSubtitle":"'"${CUSTOM_HEADER_SUBTITLE}"'"/' /usr/share/jitsi-meet/libs/app.bundle.min.js
fi
if [[ -n $CUSTOM_WM_LINK ]]; then
sed -i "s#JITSI_WATERMARK_LINK: 'https://jitsi.org'#JITSI_WATERMARK_LINK: '${CUSTOM_WM_LINK}'#" $INTERFACE
fi
if [[ $CUSTOM_LOGO -eq 1 ]]; then
sed -i "s#DEFAULT_LOGO_URL: 'images/watermark.svg'#DEFAULT_LOGO_URL: 'images/custom/watermark.svg'#" $INTERFACE
fi
if [[ $CUSTOM_LOGO_WELCOME -eq 1 ]]; then
sed -i "s#DEFAULT_WELCOME_PAGE_LOGO_URL: 'images/watermark.svg'#DEFAULT_WELCOME_PAGE_LOGO_URL: 'images/custom/watermark.svg'#" $INTERFACE
fi
