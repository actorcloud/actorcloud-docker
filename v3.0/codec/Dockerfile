FROM python:3.6.8-alpine3.9

COPY docker-entrypoint.sh /usr/bin/
COPY ./codec/ /opt/codec/

RUN python3 -m pip install -r /opt/codec/requirements.txt --no-cache-dir \
    # supervisor config
    && mkdir -p /etc/supervisor/conf.d \
    && pip install supervisor \
    && echo_supervisord_conf > /etc/supervisor/supervisord.conf \
    && echo -e "[include]\nfiles = /etc/supervisor/conf.d/*.conf" >> /etc/supervisor/supervisord.conf

WORKDIR /opt/codec

# actorcloud will occupy these port:
# - 7002 port for codec
EXPOSE 7002

ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]

CMD ["/bin/sh"]