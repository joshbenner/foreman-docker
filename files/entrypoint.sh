#!/bin/bash -x

dockerize -template /templates/database.yml:/foreman/config/database.yml

foreman-rake db:migrate
foreman-rake db:seed

exec "$@"
