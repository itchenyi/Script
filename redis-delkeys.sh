#!/bin/sh
#
# Usage: ./redis-delkeys.sh [-h host] [-p port] [-n db] pattern
#
# Matches keys with the KEYS command matching pattern
#   and deletes them from the specified Redis DB.

set -e

HOST="localhost"
PORT="6379"
DB="0"
while getopts "h:p:n:" opt; do
    case $opt in
        h)  HOST=$OPTARG;;
        p)  PORT=$OPTARG;;
        n)  DB=$OPTARG;;
        \?) echo "invalid option: -$OPTARG" >&2; exit 1;;
    esac
done
shift $(( $OPTIND -1 ))
PATTERN="$@"
if [ -z "$PATTERN" ]; then
    echo "pattern required" >&2
    exit 2
fi

redis-cli -h $HOST -p $PORT -n $DB --raw keys $PATTERN |
    xargs redis-cli -h $HOST -p $PORT -n $DB del
