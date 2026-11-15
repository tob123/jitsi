#!/bin/bash
set -x
for i in 2 3 4 5; do
CONTAINER=CONTAINER_${i}
#if [[ -f ${!CONTAINER}.scan ]]; then
  CONT_IMAGE="${BUILD_REGISTRY}/${PROJECT}/${!CONTAINER}:${JITSI_VERSION}"
  docker run -v "${TRIVY_VOLUME}":/root/.cache/ -v $(pwd)/.trivyignore:/work/.trivyignore -w /work "${REGISTRY}"/aquasec/trivy:${TRIVY_VERSION} image --exit-code 1 -s "MEDIUM,HIGH,CRITICAL" --ignore-unfixed --pkg-types library,os --db-repository coreg.appelo.org/ghcr/aquasecurity/trivy-db ${CONT_IMAGE} || exit 1
  touch ${!CONTAINER}.push
done
##if [[ -f ${CONTAINER_6}.scan ]]; then
#  CONT_IMAGE="${BUILD_REGISTRY}/${PROJECT}/${CONTAINER_6}:${COTURN_VERSION}"
#  trivy image --exit-code 1 -s "MEDIUM,HIGH,CRITICAL" --vuln-type library --ignore-unfixed ${CONT_IMAGE} || exit 1
#  trivy image --exit-code 1 -s "MEDIUM,HIGH,CRITICAL" --vuln-type os --ignore-unfixed  ${CONT_IMAGE} || exit 1
#  touch ${CONTAINER_6}.push
##fi

