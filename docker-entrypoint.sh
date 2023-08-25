#!/usr/bin/env sh

signal_handler()
{
    /scripts/run_hlstats stop
    kill -TERM "$CRON_PID"
    wait "$CRON_PID"
    exit
}

if [ "$1" = 'cron' ]; then
    /scripts/run_hlstats start
    echo 'HLstatsX daemon started'

    cron -f &
    CRON_PID=$!
    echo 'cron daemon started'

    trap signal_handler TERM INT QUIT HUP
    wait "$CRON_PID"
else
    exec "$@"
fi
