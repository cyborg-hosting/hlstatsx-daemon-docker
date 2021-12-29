#!/usr/bin/env bash

function process_signal()
{
    kill -TERM $cronpid
    wait $cronpid
}

trap process_signal SIGTERM SIGINT SIGQUIT SIGHUP ERR

if [ -z $1 ]; then
    cron -f &

    cronPID=$!

    wait $cronpid
else
    exec $@
fi