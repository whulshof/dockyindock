ARG DOCKER_COMPOSE_VERSION=1.25.0-rc1-debian
FROM docker/compose:${DOCKER_COMPOSE_VERSION}
RUN apt-get update && \
    apt-get install -y python3-pip \
                        git
RUN pip3 install docky


ADD entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
