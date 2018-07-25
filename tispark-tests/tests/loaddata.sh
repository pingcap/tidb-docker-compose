#!/usr/bin/env bash

cd /opt/spark/data/tispark-sample-data

mysql -h tidb -P 4000 -u root < dss.ddl
