#!/bin/sh

foreman-rake db:migrate
foreman-rake db:seed
