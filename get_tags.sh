#!/bin/bash
#set -x
TAG_STRING=""
set_tag_mj () {
for i in 2 3 4 5; do
  CONTAINER=CONTAINER_${i}
  CONT_IMAGE_BASE="${BUILD_REGISTRY}/${PROJECT}/${!CONTAINER}"
  CONT_IMAGE="${BUILD_REGISTRY}/${PROJECT}/${!CONTAINER}:${JITSI_VERSION}"
  CONT_IMAGE_MJ="${BUILD_REGISTRY}/${PROJECT}/${!CONTAINER}:${MAJOR_TAG}"
  TAG_STRING_ADD="--set ${!CONTAINER}.tags=${CONT_IMAGE_MJ}"
  TAG_STRING="$TAG_STRING $TAG_STRING_ADD"
done
}
set_tag_min () {
for i in 2 3 4 5; do
  CONTAINER=CONTAINER_${i}
  CONT_IMAGE_BASE="${BUILD_REGISTRY}/${PROJECT}/${!CONTAINER}"
  CONT_IMAGE="${BUILD_REGISTRY}/${PROJECT}/${!CONTAINER}:${JITSI_VERSION}"
  TAG_STRING_ADD="--set ${!CONTAINER}.tags=${CONT_IMAGE}"
  TAG_STRING="$TAG_STRING $TAG_STRING_ADD"
done
}
MAJOR_TAG=$JITSI_VERSION
until [[ -z "$MAJOR_TAG"  ]];do
  if MAJOR_TAG=`echo $MAJOR_TAG | sed 's/\.[0-9]*$//'`;then
  set_tag_mj
  if [[ $MAJOR_TAG =~ ^[0-9]*+$ ]];then
    MAJOR_TAG=""
  fi
  fi
done
set_tag_min
export TAG_STRING