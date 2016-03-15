#!/bin/sh
docker run -p 27017:27017 --name rs1_srv1 -d gustavocms/mongodb --replSet rs1
IP_1=$(docker exec -it rs1_srv1 ifconfig | perl -ne 'print $1 . "\n" if m,addr\:(\S+), && !$i++;')
docker run -p 27018:27017 --name rs1_srv2 -d gustavocms/mongodb --replSet rs1
IP_2=$(docker exec -it rs1_srv2 ifconfig | perl -ne 'print $1 . "\n" if m,addr\:(\S+), && !$i++;')

echo "members: $IP_1 $IP_2"

cat <<EOF
rs.initiate()
rs.add('$IP_2:27017')
rs.status()
cfg = rs.config()
cfg.members[0].host = '$IP_1:27017'
rs.reconfig(cfg)
EOF
