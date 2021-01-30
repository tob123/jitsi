#!/bin/bash
if [[ $VERSION = "LATEST" ]]; then
  export JITSI_VERSION=$JITSI_SEM_LATEST
  export VERSION_MAJOR=$JITSI_LATEST_MJ
  export JITSI_DEB_VERSION='*'
  export JICOFO_DEB_VERSION='*'
  export JVB_DEB_VERSION='*'
  export COTURN_VERSION
  export COTURN_VERSION_MJ
fi
