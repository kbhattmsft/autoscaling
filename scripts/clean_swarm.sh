#!/bin/bash
set -x
down=$(docker node ls|grep Down|awk '{print $1}')
echo =====
echo Cleaning up agent nodes with STATUS=Down...
echo =====
docker node rm --force $down
echo Done! Active nodes:
docker node ls
