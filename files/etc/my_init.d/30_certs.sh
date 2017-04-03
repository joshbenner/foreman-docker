#!/bin/sh
update-ca-certificates

# Copy mounted certs so we can set perms
mkdir /certs
cp /*.pem /certs
chmod a+r /certs/*.pem
