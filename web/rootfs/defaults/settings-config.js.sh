#!/bin/bash
cat <<EOF
// Video configuration.
//

if (!config.hasOwnProperty('constraints')) config.constraints = {};
if (!config.constraints.hasOwnProperty('video')) config.constraints.video = {};
config.resolution = ${RESOLUTION};
config.constraints.video.height = {ideal: ${RESOLUTION}, max: ${RESOLUTION}, min: ${RESOLUTION_MIN}};
config.constraints.video.width = {ideal: ${RESOLUTION_WIDTH}, max: ${RESOLUTION_WIDTH}, min: ${RESOLUTION_WIDTH_MIN}};
config.disableSimulcast = false;
config.startVideoMuted = 10;
//audio config
config.enableNoAudioDetection = false;
config.enableTalkWhileMuted = false;
config.disableAP = true;
config.stereo = false;
config.startAudioOnly = false;
config.startAudioMuted = 10;
EOF
