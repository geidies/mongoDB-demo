#!/bin/sh

for I in 1 2 3; do 
  docker run -d --name couch_${I} -P couchbase:latest
  IP=$(docker exec -it couch_${I} cat /etc/hosts | head -1 | awk '{print $1}')
  echo $IP
  if [[ "${IPM}" == "" ]]; then
    IPM=${IP}
  fi
done
echo "waiting for init"
sleep 8
open http://$IPM:8091/
