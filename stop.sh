#!/bin/bash

ids=$(docker ps | grep ddos | awk '{print $1}')
docker kill $ids
