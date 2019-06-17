#!/bin/sh

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
    supervisord
fi

# flask app init
export FLASK_APP=manage.py
