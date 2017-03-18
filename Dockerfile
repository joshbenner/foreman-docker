FROM ruby:2.3

ENV FOREMAN_VERSION=1.14.2 \
    DOCKERIZE_VERSION=v0.3.0 \
    DB_TYPE=sqlite3 \
    DB_HOST=localhost \
    DB_NAME=/foreman.sqlite3 \
    DB_USER=foreman \
    DB_PASS= \
    DB_POOL=5

# Install dockerize
RUN wget -q https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# Install NodeJS
RUN wget -q -O - https://deb.nodesource.com/setup_7.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Foreman
RUN apt-get update && \
    apt-get install -y nodejs libpq-dev build-essential libxml2-dev \
      libxslt1-dev zlib1g-dev libssl-dev libreadline-dev libvirt-dev \
      libmysqlclient-dev libsqlite3-dev && \
    git clone https://github.com/theforeman/foreman.git --depth 1 -b $FOREMAN_VERSION && \
    cd foreman && \
    cp config/settings.yaml.example config/settings.yaml && \
    cp config/database.yml.example config/database.yml && \
    bundle install --without therubyracer test --path vendor && \
    npm install && \
    RAILS_ENV=production bundle exec rake assets:precompile locale:pack webpack:compile && \
    apt-get purge -y libpq-dev build-essential libxml2-dev libxslt1-dev \
      zlib1g-dev libssl-dev libreadline-dev libvirt-dev libmysqlclient-dev \
      libsqlite3-dev && \
    apt-get autoremove -y --purge && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY files/ /

ENTRYPOINT ["/entrypoint.sh"]
