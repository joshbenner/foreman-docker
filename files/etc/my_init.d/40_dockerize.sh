#!/bin/sh

mkdir -p /etc/ansible
dockerize \
  -template /templates/database.yml:/etc/foreman/database.yml \
  -template /templates/encryption_key.rb:/etc/foreman/encryption_key.rb \
  -template /templates/settings.yaml:/etc/foreman/settings.yaml \
  -template /templates/nginx-foreman.conf:/etc/nginx/conf.d/foreman.conf \
  -template /templates/foreman.ini:/etc/ansible/foreman.ini

if [ "$DB_TYPE" = "postgresql" ]; then
  dockerize -wait tcp://$DB_HOST:5432
  echo "Connected to Postgres!"
fi

if [ "$ANSIBLE_ENABLED" != "true" ]; then
  rm /etc/cron.d/ansible
fi
