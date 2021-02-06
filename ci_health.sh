#!/bin/bash
HEALTH="notok" && counter=0
while [[ -n ${HEALTH} ]] && [ $counter -le 120 ]; do
  HEALTH=$(docker ps -q --filter health=starting --filter health=unhealthy --filter health=none)
  sleep 1
  counter=$(( $counter + 1 ))
  echo $counter
  docker ps ---filter health=starting --filter health=unhealthy --filter health=none
  if [ $counter -eq 120 ]; then
    echo $counter
    docker-compose logs
    exit 1
  fi
done
set +x

