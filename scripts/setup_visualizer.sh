#!/bin/bash
set -x
echo =====
echo Install Docker Swarm Mode Visualizer with external port 8087
echo =====
docker service create \
  --name=viz \
  --publish=8087:8080/tcp \
  --constraint=node.role==manager \
  --mount=type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
  manomarks/visualizer
