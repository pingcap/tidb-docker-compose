#!/usr/bin/env bash

mysql -h tidb -P 4000 -u root < /opt/spark/data/tispark-sample-data/dss.ddl
