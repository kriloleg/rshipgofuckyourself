#!/bin/bash

function show_stat() {
  containers=$(docker ps | grep -v tor | grep ddos-cats | awk '{print $1}')

  while IFS= read -r container; do
    docker logs --tail 500 $container 2>&1 | grep --text 'ddos-cats' | grep --text 'packet sent' | awk '{print $1}' | sort | uniq | cut -c2- | rev | cut -c3- | rev
  done <<< $containers
}

export -f show_stat

watch show_stat
