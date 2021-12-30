#!/usr/bin/env bash

function process_signal()
{
    echo '[INFO] termination signal received'
    ./run_hlstats stop
    kill -TERM $cronpid
    wait $cronpid
    echo '[INFO] terminated'
    exit
}

if [ $1 = 'cron' ]
then
    echo '[INFO] HLstatsX daemon starting'
    ./run_hlstats start
    echo '[INFO] HLstatsX daemon started'

    echo '[INFO] cron starting'
    cron -f &
    cronpid=$!
    echo '[INFO] cron started'

    trap process_signal SIGTERM SIGINT SIGQUIT SIGHUP ERR
    wait $cronpid
else
    exec $@
fi
