#!/bin/bash
set -e

# substitute env variables in configuration
envsubst < /opt/learninglocker/.env.template > /opt/learninglocker/.env

exec "$@"

