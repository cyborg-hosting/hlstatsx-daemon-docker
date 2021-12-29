#!/usr/bin/env bash

function process_signal()
{
    kill -TERM $cronpid
    wait $cronpid
}

trap process_signal SIGTERM SIGINT SIGQUIT SIGHUP ERR

if [ $1 -eq 'cron' ]; then
    cron

    cronpid=$!

    wait $cronpid
else
    exec $@
fi