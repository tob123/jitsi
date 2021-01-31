#!/bin/bash
set -x
for i in 2 3 4 5; do
CONTAINER=CONTAINER_${i}
if docker-compose pull ${!CONTAINER}; then
  touch ${!CONTAINER}.compare
  CONT_IMAGE="${BUILD_REGISTRY}/${PROJECT}/${!CONTAINER}:${JITSI_VERSION}"
  docker tag ${CONT_IMAGE} ${!CONTAINER}.previous; else
  touch ${!CONTAINER}.scan
fi
done
