#!/bin/bash
export LOCAL_ADDRESS=`hostname -i`
export MUC_NICKNAME=`uuidgen`
if [[ -z $JVB_AUTH_PASSWORD ]]; then
    echo 'FATAL ERROR: JVB auth password must be set'
    exit 1
fi
export JAVA_SYS_PROPS="-Dnet.java.sip.communicator.SC_HOME_DIR_LOCATION=/ -Dnet.java.sip.communicator.SC_HOME_DIR_NAME=config -Djava.util.logging.config.file=/config/logging.properties -Dconfig.file=/config/jvb.conf"

DAEMON=/usr/share/jitsi-videobridge/jvb.sh
export LOCAL_ADDRESS=`hostname -i`
export MUC_NICKNAME=`uuidgen`

#if [[ `whoami` = "root" ]]; then
#  exec s6-setuidgid jvb /bin/bash -c "exec $DAEMON --apis=${JVB_ENABLE_APIS:="none"}"
#  else /bin/bash -c "exec $DAEMON --apis=${JVB_ENABLE_APIS:="none"}"
#fi
exec "${@}" --apis=${JVB_ENABLE_APIS:='none'}

