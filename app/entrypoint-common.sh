#!/bin/bash
set -e

# substitute env variables in configuration
envsubst < /opt/learninglocker/.env.template > /opt/learninglocker/.env

# fill up storage directory if it's an empty volume
if [ -z "$(ls -A /opt/learninglocker/storage)" ]; then
    cp -r /opt/learninglocker/storage.template/* /opt/learninglocker/storage/
fi

exec "$@"

