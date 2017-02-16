#!/bin/bash
set -x
echo =====
echo Check and create network...
echo =====

TEST_NET=cputest
docker network ls | grep $TEST_NET
RC=$?
if [ $RC != 0 ]; then
  docker network create -d overlay --label cputest $TEST_NET
fi

docker \
  service create --name cputest \
  --mode global \
  --network $TEST_NET \
  --label com.docker.stack.namespace=cputest \
  --container-label com.docker.stack.namespace=cputest \
  -e STRESS_SYSTEM_FOR=10m \
  -e  MAX_CPU_CORES=2 \
  petarmaric/docker.cpu-stress-test
