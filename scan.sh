#!/bin/bash
set -eo pipefail
TRIVY_VERSION="0.76.0"
TRIVY_IMAGE="${REGISTRY}"/aquasec/trivy:${TRIVY_VERSION}
IGNORE_FILE=".trivyignore"
TRIVY_CACHE_VOLUME=trivy-cache


docker run --rm \
  -v "${TRIVY_CACHE_VOLUME}:/root/.cache/trivy" \
  ${TRIVY_JAVA_DB_REPOSITORY:+-e TRIVY_JAVA_DB_REPOSITORY="$TRIVY_JAVA_DB_REPOSITORY"} \
  "$TRIVY_IMAGE" image --download-java-db-only

set -x
for i in 2 3 4 5; do
CONTAINER=CONTAINER_${i}
#if [[ -f ${!CONTAINER}.scan ]]; then
  CONT_IMAGE="${BUILD_REGISTRY}/${PROJECT}/${!CONTAINER}:cicd"
  docker run --rm \
  -v "${TRIVY_CACHE_VOLUME}:/root/.cache/trivy" \
  "$TRIVY_IMAGE" image \
  --exit-code 1 --ignore-unfixed \
  --pkg-types library,os \
  --image-src remote --server "$TRIVY_SERVICE" \
  --severity "MEDIUM,HIGH,CRITICAL" \
  --ignorefile /dev/stdin \
  "$CONT_IMAGE" < "$IGNORE_FILE"
  touch ${!CONTAINER}.push
done
#if [[ -f ${CONTAINER_6}.scan ]]; then
  CONT_IMAGE="${BUILD_REGISTRY}/${PROJECT}/${CONTAINER_6}:${COTURN_VERSION}"
  docker run --rm \
  -v "${TRIVY_CACHE_VOLUME}:/root/.cache/trivy" \
  "$TRIVY_IMAGE" image \
  --exit-code 1 --ignore-unfixed \
  --pkg-types library,os \
  --image-src remote --server "$TRIVY_SERVICE" \
  --severity "MEDIUM,HIGH,CRITICAL" \
  --ignorefile /dev/stdin \
  "$CONT_IMAGE" < "$IGNORE_FILE"
  touch ${CONTAINER_6}.push
#fi

