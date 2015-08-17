#!/bin/bash

docker build -t consul ./consul
docker build -t pxc ./pxc
docker build -t pxc-consul-sidecar ./pxc-consul-sidecar
docker build -t pxcdemo ./app
