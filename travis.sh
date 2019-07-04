#!/bin/bash  
set -ev

HUBNAME=soniab/glassfish;
docker pull $HUBNAME || true
docker build  --cache-from $HUBNAME  -t $HUBNAME .
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin 
docker push $HUBNAME  