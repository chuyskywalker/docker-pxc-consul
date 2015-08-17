#!/bin/bash

docker rm -f consulserver >/dev/null 2>&1

# Start the consul server
docker run --name consulserver \
  -d -p 8301:8300 -p 8401:8400 -p 8501:8500 -p 8601:53/udp \
  consul \
  consul agent -config-dir=/config -server -bootstrap -ui-dir /ui