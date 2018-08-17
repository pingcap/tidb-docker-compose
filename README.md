# TiDB docker-compose

[![Build Status](https://travis-ci.org/pingcap/tidb-docker-compose.svg?branch=master)](https://travis-ci.org/pingcap/tidb-docker-compose)

## Requirements

* Docker >= 17.03
* Docker Compose >= 1.6.0

> **Note:** [Legacy Docker Toolbox](https://docs.docker.com/toolbox/toolbox_install_mac/) users must migrate to [Docker for Mac](https://store.docker.com/editions/community/docker-ce-desktop-mac), since it is tested that tidb-docker-compose cannot be started on Docker Toolbox and Docker Machine.

## Quick start

```bash
$ git clone https://github.com/pingcap/tidb-docker-compose.git
$ cd tidb-docker-compose && docker-compose pull # Get the latest Docker images
$ docker-compose up -d
$ mysql -h 127.0.0.1 -P 4000 -u root
```

* Access monitor at http://localhost:3000

Default user/password: admin/admin

* Access [tidb-vision](https://github.com/pingcap/tidb-vision) at http://localhost:8010

* Access Spark Web UI at http://localhost:8080
  and access [TiSpark](https://github.com/pingcap/tispark) through spark://127.0.0.1:7077

## Customize TiDB Cluster

### Configuration

* config/pd.toml is copied from [PD repo](https://github.com/pingcap/pd/tree/master/conf)
* config/tikv.toml is copied from [TiKV repo](https://github.com/pingcap/tikv/tree/master/etc)
* config/tidb.toml is copied from [TiDB repo](https://github.com/pingcap/tidb/tree/master/config)

If you find these configuration files outdated or mismatch with TiDB version, you can copy these files from their upstream repos and change their metrics addr with `pushgateway:9091`. Also `max-open-files` are configured to `1024` in tikv.toml to simplify quick start on Linux, because setting up ulimit on Linux with docker is quite tedious.

And config/*-dashboard.json are copied from [TiDB-Ansible repo](https://github.com/pingcap/tidb-ansible/tree/master/scripts)

You can customize TiDB cluster configuration by editing docker-compose.yml and the above config files if you know what you're doing.

But edit these files manually is tedious and error-prone, a template engine is strongly recommended. See the following steps

### Install Helm

[Helm](https://helm.sh) is used as a template render engine

```
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash
```

Or if you use Mac, you can use homebrew to install Helm by `brew install kubernetes-helm`

### Bring up TiDB cluster

```bash
$ git clone https://github.com/pingcap/tidb-docker-compose.git
$ cd tidb-docker-compose
$ vi compose/values.yaml # custom cluster size, docker image, port mapping etc
$ helm template compose > generated-docker-compose.yaml
$ docker-compose -f generated-docker-compose.yaml pull # Get the latest Docker images
$ docker-compose -f generated-docker-compose.yaml up -d
```

You can build docker image yourself for development test.

* Build from binary

  For pd, tikv and tidb, comment their `image` and `buildPath` fields out. And then copy their binary files to pd/bin/pd-server, tikv/bin/tikv-server and tidb/bin/tidb-server.

  These binary files can be built locally or downloaded from https://download.pingcap.org/tidb-latest-linux-amd64.tar.gz

  For tidbVision, comment its `image` and `buildPath` fields out. And then copy tidb-vision repo to tidb-vision/tidb-vision.

* Build from source

  Leave pd, tikv, tidb and tidbVision `image` field empty and set their `buildPath` field to their source directory.

  For example, if your local tikv source directory is $GOPATH/src/github.com/pingcap/tikv, just set tikv `buildPath` to `$GOPATH/src/github.com/pingcap/tikv`

  *Note:* Compiling tikv from source consumes lots of memory, memory of Docker for Mac needs to be adjusted to greater than 6GB

[tidb-vision](https://github.com/pingcap/tidb-vision) is a visiualization page of TiDB Cluster, it's WIP project and can be disabled by commenting `tidbVision` out.

[TiSpark](https://github.com/pingcap/tispark) is a thin layer built for running Apache Spark on top of TiDB/TiKV to answer the complex OLAP queries.

#### Host network mode (Linux)

*Note:* Docker for Mac uses a Linux virtual machine, host network mode will not expose any services to host machine. So it's useless to use this mode.

When using TiKV directly without TiDB, host network mode must be enabled. This way all services use host network without isolation. So you can access all services on the host machine.

You can enable this mode by setting `networkMode: host` in compose/values.yaml and regenerate docker-compose.yml. When in this mode, prometheus address in configuration files should be changed from `prometheus:9090` to `127.0.0.1:9090`, and pushgateway address should be changed from `pushgateway:9091` to `127.0.0.1:9091`.

These modification can be done by:
```bash
# Note: this only needed when networkMode is `host`
sed -i 's/pushgateway:9091/127.0.0.1:9091/g' config/*
sed -i 's/prometheus:9090/127.0.0.1:9090/g' config/*
```

After all the above is done, you can start tidb-cluster as usual by `docker-compose -f generated-docker-compose.yml up -d`

### Debug TiDB/TiKV/PD instances
Prerequisites:

Pprof: This is a tool for visualization and analysis of profiling data. Follow [these instructions](https://github.com/google/pprof#building-pprof) to install pprof.

Graphviz: [http://www.graphviz.org/](http://www.graphviz.org/), used to generate graphic visualizations of profiles.

* debug TiDB or PD instances

```bash
### Use the following command to starts a web server for graphic visualizations of golang program profiles
$ ./tool/container_debug -s pd0 -p /pd-server -w
```
The above command will produce graphic visualizations of profiles of `pd0` that can be accessed through the browser.

* debug TiKV instances

```bash
### step 1: select a tikv instance(here is tikv0) and specify the binary path in container to enter debug container
$ ./tool/container_debug -s tikv0 -p /tikv-server

### after step 1, we can generate flame graph for tikv0 in debug container
$ ./run_flamegraph.sh 1  # 1 is the tikv0's process id

### also can fetch tikv0's stack informations with GDB in debug container
$ gdb /tikv-server 1 -batch -ex "thread apply all bt" -ex "info threads"
```

### Access TiDB cluster

TiDB uses ports: 4000(mysql) and 10080(status) by default

```bash
$ mysql -h 127.0.0.1 -P 4000 -u root
```

And Grafana uses port 3000 by default, so open your browser at http://localhost:3000 to view monitor dashboard

If you enabled tidb-vision, you can view it at http://localhost:8010

### Access Spark shell and load TiSpark

Insert some sample data to the TiDB cluster:

```bash
$ docker-compose exec tispark-master bash
$ cd /opt/spark/data/tispark-sample-data
$ mysql -h tidb -P 4000 -u root < dss.ddl
```

After the sample data is loaded into the TiDB cluster, you can access Spark Shell by `docker-compose exec tispark-master /opt/spark/bin/spark-shell`.

```bash
$ docker-compose exec tispark-master /opt/spark/bin/spark-shell
...
Spark context available as 'sc' (master = local[*], app id = local-1527045927617).
Spark session available as 'spark'.
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /___/ .__/\_,_/_/ /_/\_\   version 2.1.1
      /_/

Using Scala version 2.11.8 (Java HotSpot(TM) 64-Bit Server VM, Java 1.8.0_172)
Type in expressions to have them evaluated.
Type :help for more information.

scala> import org.apache.spark.sql.TiContext
...
scala> val ti = new TiContext(spark)
...
scala> ti.tidbMapDatabase("TPCH_001")
...
scala> spark.sql("select count(*) from lineitem").show
+--------+
|count(1)|
+--------+
|   60175|
+--------+
```

You can also access Spark with Python or R using the following commands:

```
docker-compose exec tispark-master /opt/spark/bin/pyspark
docker-compose exec tispark-master /opt/spark/bin/sparkR
```

More documents about TiSpark can be found [here](https://github.com/pingcap/tispark).
