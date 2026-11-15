#!/bin/bash
JITSI_VERSION_LIST=`curl -x http://vondelaar.appelo.org:3128 --cacert ca.crt -s http://download.jitsi.org/stable/ | grep jitsi-meet_ | sort -V | awk -F'"' {'print $2'} | awk -F_ {'print $2'}`
JITSI_VERSION_LATEST=`echo -ne "$JITSI_VERSION_LIST" | tail -1`
JITSI_VERSION_GITHUB_LATEST=`echo $JITSI_VERSION_LATEST | sed 's/-[0-9]*$//' | awk -F . {'print $NF'}`
JITSI_SEM_LATEST=`echo $JITSI_VERSION_LATEST | sed s/-/./`
JITSI_LATEST_MJ=`echo $JITSI_SEM_LATEST | sed 's/\.[0-9]$//'`
COTURN_VERSION="alpine-3.24"
COTURN_VERSION_MJ="alpine"
