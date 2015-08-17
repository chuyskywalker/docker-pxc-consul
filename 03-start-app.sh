#!/bin/bash

docker rm -f pxcdemo >/dev/null 2>&1

# Start the application
docker run --name pxcdemo \
  -d -p 32875:80 \
  --link consulserver:consulserver \
  pxcdemo
