#!/bin/bash
#export JAVA_SYS_PROPS="-Dnet.java.sip.communicator.SC_HOME_DIR_LOCATION=/ -Dnet.java.sip.communicator.SC_HOME_DIR_NAME=config -Djava.util.logging.config.file=/config/logging.properties"
export JAVA_SYS_PROPS="-Djava.util.logging.config.file=/config/logging.properties -Dconfig.file=/config/jicofo.conf"
export DAEMON=/usr/share/jicofo/jicofo.sh
export DAEMON_DIR=/usr/share/jicofo/
#export DAEMON_OPTS="--domain=meet.jitsi --host=xmpp.meet.jitsi --user_name=focus --user_domain=auth.meet.jitsi"
if [[ $ENABLE_AUTH -eq 1 ]]; then
  export JICOFO_AUTH=true
else export JICOFO_AUTH=false
  if [[ $JWT_AUTH -eq 1 ]]; then
    export JICOFO_AUTH_TYPE=JWT
  else export JICOFO_AUTH_TYPE=XMPP
fi
export DAEMON_OPTS="--domain=meet.jitsi --host=xmpp.meet.jitsi --user_name=focus --user_domain=auth.meet.jitsi --user_password=$JICOFO_AUTH_PASSWORD"
exec "$@"

