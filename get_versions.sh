#!/bin/bash
JITSI_VERSION_LIST=`curl -s https://download.jitsi.org/stable/ | grep jitsi-meet_ | sort -n | awk -F'"' {'print $2'} | awk -F_ {'print $2'}`
JITSI_VERSION_LATEST=`echo -ne "$JITSI_VERSION_LIST" | tail -1`
JITSI_VERSION_GITHUB_LATEST=`echo $JITSI_VERSION_LATEST | sed 's/-[0-9]*$//' | awk -F . {'print $NF'}`
JITSI_SEM_LATEST=`echo $JITSI_VERSION_LATEST | sed s/-/./`
JITSI_LATEST_MJ=`echo $JITSI_SEM_LATEST | sed 's/\.[0-9]$//'`
COTURN_VERSION=`curl -s https://git.alpinelinux.org/aports/plain/community/coturn/APKBUILD?h=3.18-stable | grep ^pkgver | awk -F '=' {'print $2'}`
COTURN_VERSION_MJ=`echo $COTURN_VERSION | awk -F . {'print $1"."$2'}`
