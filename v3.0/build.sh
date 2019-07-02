#!/usr/bin/env bash

Tag="3.0.0"

# build actorcloud server
docker build --build-arg tag=${Tag} \
             --file ./server/Dockerfile \
             --tag actorcloud-server-${Tag}

# build actorcloud rule_engine
docker build --build-arg tag=${Tag} \
             --file ./rule-engine/ \
             --tag actorcloud-rule-engine-${Tag}
