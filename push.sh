#!/bin/bash
set -x
for i in 2 3 4 5 6; do
CONTAINER=CONTAINER_${i}
if [[ -f ${!CONTAINER}.push ]]; then
  docker-compose push ${!CONTAINER}
fi
done
