#!/usr/bin/env bash

set -e

docker build -t confd-config-static confd-config-static
docker build -t confd-config-dynamic confd-config-dynamic
docker build -t confd-test test
docker build -t confd confd

docker run --name confd_etcd -d -p 2379:2379 -e ETCD_LISTEN_CLIENT_URLS=http://0.0.0.0:2379 -e ETCD_ADVERTISE_CLIENT_URLS=http://$(boot2docker ip):2379 quay.io/coreos/etcd
http PUT $(boot2docker ip):2379/v2/keys/static/foo value==test
http PUT $(boot2docker ip):2379/v2/keys/dynamic/bar value==$(boot2docker ip)

docker run --name confd_config_static confd-config-static
docker run --name confd_static -v /etc/confd --volumes-from confd_config_static confd -onetime -backend etcd -node $(boot2docker ip):2379 || true
docker run --name confd_test_dummy -d confd-test
docker run --name confd_config_dynamic confd-config-dynamic
docker run --name confd_dynamic --volumes-from confd_config_dynamic -v /var/run/docker.sock:/var/run/docker.sock -d confd -backend etcd -node $(boot2docker ip):2379 -interval 120
sleep 60
http PUT $(boot2docker ip):2379/v2/keys/dynamic/bar value==127.0.0.1
docker logs -f confd_dynamic
#docker run --rm -it --volumes-from confd_static ubuntu /bin/bash
