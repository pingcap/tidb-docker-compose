# TiDB dashboard installer

This image is used to configure Grafana datasource and dashboards for TiDB cluster. It is used in [tidb-docker-compose](https://github.com/pingcap/tidb-docker-compose) and [tidb-operator](https://github.com/pingcap/tidb-operator).

The JSON files in dashboards are copied from [tidb-ansible](https://github.com/pingcap/tidb-ansible/tree/master/scripts).

Grafana version prior to v5.0.0 can only use import API to automate datasource and dashboard configuration. So this image is needed to run in docker environment. It runs only once in this environment.

With Grafana v5.x, we can use [provisioning](http://docs.grafana.org/administration/provisioning) feature to statically provision datasources and dashboards. No need to use scripts to configure Grafana.

But currently, the dashboards in [tidb-ansible](https://github.com/pingcap/tidb-ansible/tree/master/scripts) repository are incompatible with Grafana v5.x and cannot be statically provisioned. So this image is still required.

In the future, we can use [grafonnet](https://github.com/grafana/grafonnet-lib) to migrate old dashboards and make dashboard updating reviewable.
