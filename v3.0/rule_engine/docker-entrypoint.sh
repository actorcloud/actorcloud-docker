#!/bin/bash

set -e

if [[ -d /opt/actorcloud/deploy/ ]]; then
  cp -r /opt/actorcloud/deploy/rule_engine/* /opt/pulsar/rule_engine/ \
  && rm -rf /opt/actorcloud/deploy/
fi

echo "Starting rule_engine..."
/opt/pulsar/bin/pulsar-daemon start standalone
echo "rule_engine running"

exec "$@"
