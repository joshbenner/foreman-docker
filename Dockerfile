FROM ubuntu:16.04

ENV FOREMAN_RELEASE=1.14 \
    FOREMAN_PACKAGE_VERSION=1.14.2-1 \
    DOCKERIZE_VERSION=v0.3.0 \
    DB_TYPE=sqlite3 \
    DB_HOST=localhost \
    DB_NAME=/foreman.sqlite3 \
    DB_USER=foreman \
    DB_PASS= \
    DB_POOL=5

# Install dockerize
RUN apt-get update && \
    apt-get install -y ca-certificates wget && \
    wget -q https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Foreman
RUN wget -q https://deb.theforeman.org/pubkey.gpg -O- | apt-key add - && \
    echo "deb http://deb.theforeman.org/ xenial $FOREMAN_RELEASE" > /etc/apt/sources.list.d/foreman.list && \
    echo "deb http://deb.theforeman.org/ plugins $FOREMAN_RELEASE" >> /etc/apt/sources.list.d/foreman.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
      foreman=$FOREMAN_PACKAGE_VERSION \
      foreman-sqlite3 foreman-mysql2 foreman-postgresql && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY files/ /

ENTRYPOINT ["/entrypoint.sh"]
