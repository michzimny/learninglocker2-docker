#!/bin/bash
set -e

# substitute env variables in configuration
export DOLLAR='$'
envsubst < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

exec "$@"

