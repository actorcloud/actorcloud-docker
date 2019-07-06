#!/bin/sh

set -e

if [[ ! -f /etc/supervisor/conf.d/actorcloud_codec.conf ]]; then
    cp /opt/codec/actorcloud_codec.conf /etc/supervisor/conf.d/
fi

if ps ax | grep -v grep | grep supervisord > /dev/null
then
    echo "Supervisord running"
else
    echo "Starting supervisord..."
    rm -rf /tmp/supervisor.sock && supervisord
fi

exec "$@"
