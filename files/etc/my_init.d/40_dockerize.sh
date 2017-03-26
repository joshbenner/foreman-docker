#!/bin/sh

dockerize \
  -template /templates/database.yml:/etc/foreman/database.yml \
  -template /templates/encryption_key.rb:/etc/foreman/encryption_key.rb \
  -template /templates/settings.yaml:/etc/foreman/settings.yaml \
  -template /templates/nginx-foreman.conf:/etc/nginx/conf.d/foreman.conf

if [ "$DB_TYPE" = "postgresql" ]; then
  dockerize -wait tcp://$DB_HOST:5432
  echo "Connected to Postgres!"
fi
