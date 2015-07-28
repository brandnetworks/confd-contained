#!/usr/bin/env bash

CONTAINERS="confd_etcd confd_config_static confd_static confd_test_dummy confd_config_dynamic confd_dynamic"
docker kill $CONTAINERS
docker rm $CONTAINERS
