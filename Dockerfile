FROM python:3.6.8-alpine3.9

COPY docker-entrypoint.sh /usr/bin/

RUN apk add --no-cache \
            postgresql-libs \
            curl \
            libstdc++ \
            unzip \
    && curl -L -o actorcloud.zip https://github.com/actorcloud/ActorCloud/releases/download/v3.0.0-rc.2/ActorCloud-v3.0.0-rc.2.zip \
    && unzip -o -q actorcloud.zip  -d /opt/ && rm -rf actorcloud.zip \
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
    && touch /opt/tmp/logs/actorcloud.log \
    && ln -sf /dev/stderr /opt/tmp/logs/actorcloud.log \
    && pip install supervisor \
    && echo_supervisord_conf > /etc/supervisor/supervisord.conf \
    && echo -e "[include]\nfiles = /etc/supervisor/conf.d/*.conf" >> /etc/supervisor/supervisord.conf \
    # nginx config
    && apk add --no-cache nginx \
    && mkdir -p /run/nginx \
    && cp -r /opt/actorcloud/deploy/nginx/* /etc/nginx/ \
    && rm -rf /opt/actorcloud/rule-engine deploy docs ui \
    && cp /opt/actorcloud/server/config/config.yml /opt/actorcloud/server/instance/config.yml

WORKDIR /opt/actorcloud/server

# - /opt/actorcloud/server/static： actorcloud static
# - /opt/actorcloud/server/instance: actorcloud custom config and certs
# - /opt/tmp/logs: actorcloud logs
# - /etc/nginx: nginx config
VOLUME ["/opt/actorcloud/server/static", "/opt/actorcloud/server/instance", "/opt/tmp/logs", "/etc/nginx"]

# actorcloud will occupy these port:
# - 80 port for nginx proxy
# - 7000 port for actorcloud backend
# - 7001 port for async tasks
EXPOSE 80 7000 7001

ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]

CMD ["/bin/sh"]