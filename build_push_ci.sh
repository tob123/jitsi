#/bin/bash
set -x
for i in 2 3 4 5; do
CONTAINER=CONTAINER_${i}
#if [[ -f ${!CONTAINER}.scan ]]; then
  CONT_IMAGE_TAG_CI="${BUILD_REGISTRY}/${PROJECT}/${!CONTAINER}:cicd"
  docker tag "${BUILD_REGISTRY}/${PROJECT}/${!CONTAINER}:${JITSI_VERSION}" ${CONT_IMAGE_TAG_CI}
  docker push ${CONT_IMAGE_TAG_CI}
done