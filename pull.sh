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
if docker-compose pull ${CONTAINER_6}; then
  touch ${CONTAINER_6}.compare
  CONT_IMAGE="${BUILD_REGISTRY}/${PROJECT}/${CONTAINER_6}:${COTURN_VERSION}"
  docker tag ${CONT_IMAGE} ${CONTAINER_6}.previous; else
  touch ${CONTAINER_6}.scan
fi
