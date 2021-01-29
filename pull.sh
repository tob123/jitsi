#!/bin/bash
set -x
for i in 2 3 4 5 6; do
CONTAINER=CONTAINER_${i}
if docker-compose pull ${!CONTAINER}; then
  touch ${!CONTAINER}.compare
  docker tag ${!CONTAINER} ${!CONTAINER}.previous; else
  touch ${!CONTAINER}.scan
fi
done
