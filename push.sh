#!/bin/bash
set -x
for i in 2 3 4 5 6; do
CONTAINER=CONTAINER_${i}
if [[ -f ${!CONTAINER}.push ]]; then
#  docker-compose push ${!CONTAINER}
  docker buildx bake --set *.platform=${BUILDX_ARCH} $TAG_STRING --progress plain --push ${!CONTAINER}
fi
done
