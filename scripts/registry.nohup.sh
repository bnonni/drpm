#!/usr/bin/env bash

set -e

REGISTRY_PID=0
REGISTRY_PID_FILE="registryd.pid"

# If build missing, run build
if [[ ! -d "dist" ]]; then
    echo "Building registry ..."
    npm run build
fi

# If registryd.pid file exists, read pid and set var
if [[ -f "$REGISTRY_PID_FILE" ]]; then
    echo "Found registryd.pid file"
    REGISTRY_PID="$(cat $REGISTRY_PID_FILE 2>/dev/null)"
else
    echo "No registryd.pid file found, starting registry ..."
    nohup node ./dist/esm/registry/bin/www.js > registryd.nohup.out 2>&1 &
    REGISTRY_PID=`echo $!`
    echo "$REGISTRY_PID" > "registryd.pid"
fi
echo "Registry running on process id $REGISTRY_PID"
exit 1