#!/bin/bash
set -x
echo =====
echo Install Docker Swarm Mode Visualizer
echo '('Requires \"local\" docker daemon if run on Swarm Master and needs to attach on docker0')'
echo =====
DOCKER0=172.17.0.1 
docker \
  run -it -d -p 8180:8080 \
  -e HOST=$DOCKER0 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  manomarks/visualizer