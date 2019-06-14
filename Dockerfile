FROM python:3.6.8-alpine3.9

RUN apk add --no-cache \
            postgresql-libs \
            curl \
            libstdc++ \
            unzip \
    && curl -L -o actorcloud.zip https://github.com/actorcloud/ActorCloud/files/3289782/actorcloud.zip \
    && unzip -o -d /opt/actorcloud.zip && rm -rf actorcloud.zip \
    && apk add --no-cache --virtual .build-deps \
               gcc \
               g++ \
               make \
               musl-dev \
               libffi-dev \
               libxslt-dev \
               postgresql-dev \
    && python3 -m pip install -r /opt/actorcloud/server/requirements.txt --no-cache-dir \
    && apk --purge del .build-deps \
    # supervisor config
    && mkdir -p /etc/supervisor/conf.d /opt/tmp/logs \
    && pip install supervisor \
    && echo_supervisord_conf > /etc/supervisor/supervisord.conf \
    && echo -e "[include]\nfiles = /etc/supervisor/conf.d/*.conf" >> /etc/supervisor/supervisord.conf \
    # nginx config
    && apk add --no-cache nginx \
    && cp -r /opt/actorcloud/deploy/nginx/* /etc/nginx/ \
    && rm -rf /opt/actorcloud/rule-engine deploy docs ui


VOLUME ["/opt/actorcloud/server/static", "/opt/actorcloud/server/instance", "/opt/tmp/logs", "/etc/nginx"]


CMD ["/bin/sh"]