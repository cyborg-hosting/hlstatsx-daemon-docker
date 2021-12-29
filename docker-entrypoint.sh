#!/usr/bin/env bash

function process_signal()
{
    kill -TERM $cronPID
    wait $cronPID
}

trap process_signal SIGTERM SIGINT SIGQUIT SIGHUP ERR

cron -f &

cronPID=$!

wait $cronPID