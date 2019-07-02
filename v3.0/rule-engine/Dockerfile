FROM openjdk:8-slim

ARG tag=3.0.0
COPY docker-entrypoint.sh /usr/bin/

RUN apt-get update \
    && apt-get install -y curl tar procps \
    && rm -rf /var/lib/apt/lists/* \
    && curl -L -o actorcloud.zip https://github.com/actorcloud/ActorCloud/releases/download/${tag}/ActorCloud-${tag}.zip \
    && tar -zxvf actorcloud.tar.gz -C /opt \
    && curl -L -o pulsar.tar.gz https://archive.apache.org/dist/pulsar/pulsar-2.2.0/apache-pulsar-2.2.0-bin.tar.gz \
    && tar -zxvf pulsar.tar.gz -C /opt \
    && rm -rf actorcloud.tar.gz pulsar.tar.gz \
    && mv /opt/apache-pulsar-2.2.0 /opt/pulsar

WORKDIR /opt/pulsar/

# - /opt/pulsar/data： pulsar data directory
# - /opt/actorcloud/server/instance: pulsar logs
# - /opt/pulsar/rule_engine: actorcloud rule_engine
VOLUME ["/opt/pulsar/data", "/opt/pulsar/logs", "/opt/pulsar/rule_engine"]

EXPOSE 8888 8080

ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]

CMD ["/bin/bash"]

