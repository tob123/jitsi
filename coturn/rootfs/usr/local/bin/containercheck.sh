#!/bin/sh
TURN_SERVER_IP=`hostname -i`
turnutils_stunclient ${TURN_SERVER_IP} || exit 1
