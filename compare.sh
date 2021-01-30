#!/bin/bash
set -x
for i in 2 3 4 5; do
CONTAINER=CONTAINER_${i}
if [[ -f ${!CONTAINER}.compare ]]; then
  CONT_IMAGE="${BUILD_REGISTRY}/${PROJECT}/${!CONTAINER}:${JITSI_VERSION}"
  container-diff diff -v info -t file -json daemon://${!CONTAINER}.previous daemon://${CONT_IMAGE} | jq '.[].Diff[] | select ((.!=null))' > contdifftmp || exit 1
  if [[ -s contdifftmp ]]; then
    cat contdifftmp
    for j in $(cat contdifftmp | jq -r .[].Name); do echo $j; if ! grep $j comp_wl;then echo push;touch ${!CONTAINER}.scan;fi;done
  fi
fi
done
