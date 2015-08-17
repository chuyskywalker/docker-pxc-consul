#!/bin/bash

if [ -z "$1" ]; then
  echo "Please supply the first arg as the nodeid (1, 2, 3, etc)"
  exit 1
fi

docker rm -f pxc$1 >/dev/null 2>&1
docker rm -f pcs$1 >/dev/null 2>&1

# This will use DNS from consulserver, but the `dns` option only supports IPs
# so our container start script will extract the hostip for the link
# and jam it into resolv.conf instead. Bit of a hack, but...

# Start the pxc server
docker run --name pxc$1 \
  -d -p 3306 --link consulserver:consulserver \
  pxc

# Start the pxc consul sidecar for monitoring/clusterization
docker run --name pcs$1 \
  -d --link consulserver:consulserver \
  -e IP="$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' pxc$1)" \
  -e ID=$1 \
  pxc-consul-sidecar
