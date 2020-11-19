#!/bin/sh
set -e

if [ $# == 0 ]; then
  echo "$0: used default.conf for cgminer"
  set -- cgminer --config /etc/config/cgminer.conf
fi

if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for cgminer"
  set -- cgminer "$@"
fi

if [ "$1" = "cgminer" ]; then
  echo "run : $@ "
  exec gosu nobody "$@"
fi

echo "run some: $@"
exec "$@"
