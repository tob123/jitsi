#!/bin/sh
TURN_SERVER_IP=`hostname -i`
timeout 15 turnutils_stunclient ${TURN_SERVER_IP} || exit 1
