#!/bin/bash
export JAVA_SYS_PROPS="-Dnet.java.sip.communicator.SC_HOME_DIR_LOCATION=/ -Dnet.java.sip.communicator.SC_HOME_DIR_NAME=config -Djava.util.logging.config.file=/config/logging.properties"
export DAEMON=/usr/share/jicofo/jicofo.sh
export DAEMON_DIR=/usr/share/jicofo/
export DAEMON_OPTS="--domain=meet.jitsi --host=xmpp.meet.jitsi --user_name=focus --user_domain=auth.meet.jitsi"
exec "$@"

