#!/usr/bin/env bash

set -e

docker build -t brandnetworks/confd-data confd-data
docker build -t brandnetworks/confd confd

docker push brandnetworks/confd-data
docker push brandnetworks/confd
