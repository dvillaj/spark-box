#!/bin/bash
rm /tmp/*.pid

service ssh start

if [[ $1 == "-d" ]]; then
  while true; do sleep 1000; done
fi

bash