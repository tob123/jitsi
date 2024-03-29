#!/bin/bash
#export LOCAL_ADDRESS=`hostname -i`
export LOCAL_ADDRESS=`getent hosts jvb.meet.jitsi | awk {'print $1'}`
export MUC_NICKNAME=`uuidgen`
if [[ -z $JVB_AUTH_PASSWORD ]]; then
    echo 'FATAL ERROR: JVB auth password must be set'
    exit 1
fi
export JAVA_SYS_PROPS="-Dnet.java.sip.communicator.SC_HOME_DIR_LOCATION=/ -Dnet.java.sip.communicator.SC_HOME_DIR_NAME=config -Djava.util.logging.config.file=/config/logging.properties -Dconfig.file=/config/jvb.conf -Dorg.ice4j.ice.harvest.NAT_HARVESTER_LOCAL_ADDRESS=${LOCAL_ADDRESS} -Dorg.ice4j.ice.harvest.NAT_HARVESTER_PUBLIC_ADDRESS=${DOCKER_HOST_ADDRESS}"

DAEMON=/usr/share/jitsi-videobridge/jvb.sh
export LOCAL_ADDRESS=`hostname -i`
export MUC_NICKNAME=`uuidgen`

export WS_DOMAIN=`echo $PUBLIC_URL | awk -F '/' {'print $3'}`
exec "${@}"

