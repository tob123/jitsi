#!/bin/bash
set -e
for i in 2 3 4 5; do
CONTAINER=CONTAINER_${i}
if [[ -f ${!CONTAINER}.compare ]]; then
  CONT_IMAGE="${BUILD_REGISTRY}/${PROJECT}/${!CONTAINER}:${JITSI_VERSION}"
  container-diff diff -v info -t file -json daemon://${!CONTAINER}.previous daemon://${CONT_IMAGE} | jq '.[].Diff[] | select ((.!=null))' > contdifftmp || exit 1
  if [[ -s contdifftmp ]]; then
#    cat contdifftmp
    for j in $(cat contdifftmp | jq -r .[].Name); do  if ! grep $j comp_wl;then touch ${!CONTAINER}.scan;fi;done
  fi
fi
done
if [[ -f ${CONTAINER_6}.compare ]]; then
 CONT_IMAGE="${BUILD_REGISTRY}/${PROJECT}/${CONTAINER_6}:${COTURN_VERSION}"
  container-diff diff -v info -t file -json daemon://${CONTAINER_6}.previous daemon://${CONT_IMAGE} | jq '.[].Diff[] | select ((.!=null))' > contdifftmp || exit 1
  if [[ -s contdifftmp ]]; then
#    cat contdifftmp
    for j in $(cat contdifftmp | jq -r .[].Name); do if ! grep $j comp_wl;then touch ${CONTAINER_6}.scan;fi;done
  fi
fi
