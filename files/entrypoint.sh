#!/bin/bash -x

dockerize \
  -template /templates/database.yml:/etc/foreman/database.yml \
  -template /templates/encryption_key.rb:/etc/foreman/encryption_key.rb

foreman-rake db:migrate
foreman-rake db:seed

exec "$@"
