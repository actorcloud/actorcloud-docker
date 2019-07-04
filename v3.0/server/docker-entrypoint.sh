#!/bin/sh

set -e

if [[ -d /opt/actorcloud/deploy/ ]]; then
     cp -r /tmp/stash/nginx/* /etc/nginx \
  && cp -r /tmp/stash/static/* /opt/actorcloud/server/static \
  && cp -r /opt/actorcloud/deploy/nginx/* /etc/nginx/ \
  && cp /opt/actorcloud/server/config/config.yml /opt/actorcloud/server/instance \
  && touch /opt/tmp/logs/actorcloud.log \
  && ln -sf /dev/stderr /opt/tmp/logs/actorcloud.log \
  && rm -rf /tmp/stash/ /opt/actorcloud/deploy/
fi

if ps ax | grep -v grep | grep nginx > /dev/null
then
    echo "Nginx running"
else
    echo "Starting nginx..."
    nginx
fi

if ps ax | grep -v grep | grep supervisord > /dev/null
then
    echo "Supervisord running"
else
    echo "Starting supervisord..."
    rm -rf /tmp/supervisor.sock && supervisord
fi

exec "$@"
