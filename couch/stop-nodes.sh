#!/bin/sh

for I in 1 2 3; do 
  docker kill couch_${I}
  docker rm couch_${I}
done
