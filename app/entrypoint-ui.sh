#!/bin/sh
set -e

socat TCP4-LISTEN:$API_PORT,fork TCP4:api:$API_PORT &
node ui/dist/server

