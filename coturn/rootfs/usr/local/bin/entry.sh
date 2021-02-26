#!/bin/sh

# If command starts with an option, prepend with turnserver binary.
# find ip addresses for xmpp server, jvb server and coturn server
set -e
export XMPP_SERVER_IP=`getent hosts xmpp.meet.jitsi | awk '{print $1}'`
export JVB_SERVER_IP=`getent hosts jvb.meet.jitsi | awk '{print $1}'`
export TURN_SERVER_IP=`hostname -i`
turnadmin -s ${TURN_PASSWORD} -r ${TURN_DOMAIN}
if [ $TURN_VERBOSE -eq 1 ]; then
  export TURN_CONFIG="/etc/coturn/turnserver-verbose.conf"
else
  export TURN_CONFIG="/etc/coturn/turnserver.conf"
fi

if [ "${1:0:1}" == '-' ]; then
  set -- turnserver "$@"
fi

exec $(eval "echo $@")
