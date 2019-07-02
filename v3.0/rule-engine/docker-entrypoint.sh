#!/bin/bash

set -e

if [[ "$1" = '/bin/bash' ]]; then
     cp -r  /opt/actorcloud/deploy/rule_engine/* ./rule_engine/ \
  && rm -rf /opt/actorcloud/deploy/
fi

exec "$@"
