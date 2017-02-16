#!/bin/bash
set x
echo =====
echo Check and create network...
echo =====

MONITORING_NET=monitoring
docker network ls | grep $MONITORING_NET
RC=$?
if [ $RC != 0 ]; then
  docker network create -d overlay --label tibco $MONITORING_NET
fi

echo =====
echo Create node-exporter service...
echo =====


docker \
  service create --name node-exporter \
  --mode global \
  --network monitoring \
  --label com.docker.stack.namespace=monitoring \
  --container-label com.docker.stack.namespace=monitoring \
  --mount type=bind,source=/proc,target=/host/proc \
  --mount type=bind,source=/sys,target=/host/sys \
  --mount type=bind,source=/,target=/rootfs \
  --mount type=bind,source=/etc/hostname,target=/etc/host_hostname \
  -e HOST_HOSTNAME=/etc/host_hostname \
  basi/node-exporter:v0.1.1 \
  --collector.procfs /host/proc \
  --collector.sysfs /host/sys \
  --collector.filesystem.ignored-mount-points "^/(sys|proc|dev|host|etc)($|/)" \
  --collector.textfile.directory /etc/node-exporter/ \
  --collectors.enabled="conntrack,diskstats,entropy,filefd,filesystem,loadavg,mdadm,meminfo,netdev,netstat,stat,textfile,time,vmstat,ipvs"

echo =====
echo Create Prometheus service...
echo =====

docker \
  service create \
  --name prometheus \
  --label com.docker.stack.namespace=$MONITORING_NET \
  --container-label com.docker.stack.namespace=$MONITORING_NET \
  --network $MONITORING_NET \
  --publish 9090:9090 \
  basi/prometheus-swarm:v0.4.0

echo =====
echo Create cAdvisor service...
echo =====

docker \
  service create --name cadvisor \
  --mode global \
  --network $MONITORING_NET \
  --label com.docker.stack.namespace=$MONITORING_NET \
  --container-label com.docker.stack.namespace=$MONITORING_NET \
  --mount type=bind,src=/,dst=/rootfs:ro \
  --mount type=bind,src=/var/run,dst=/var/run:rw \
  --mount type=bind,src=/sys,dst=/sys:ro \
  --mount type=bind,src=/var/lib/docker/,dst=/var/lib/docker:ro \
  google/cadvisor:v0.24.1

echo =====
echo Create Grafana service...
echo =====

docker \
  service create \
  --name grafana \
  --network $MONITORING_NET \
  --label com.docker.stack.namespace=$MONITORING_NET \
  --container-label com.docker.stack.namespace=$MONITORING_NET \
  --publish 3000:3000 \
  -e "GF_SECURITY_ADMIN_PASSWORD=password" \
  grafana/grafana
