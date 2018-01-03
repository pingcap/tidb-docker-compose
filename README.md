# TiDB docker-compose

## Quick start

```bash
$ git clone https://github.com/pingcap/tidb-docker-compose.git
$ cd tidb-docker-compose && docker-compose up -d
$ mysql -h 127.0.0.1 -P 4000 -u root
```

* Access monitor at http://localhost:3000

* Access [tidb-vision](https://github.com/pingcap/tidb-vision) at http://localhost:8010


## Customize TiDB Cluster

### Configuration

* config/pd.toml is copied from [PD repo](https://github.com/pingcap/pd/tree/master/conf)
* config/tikv.toml is copied from [TiKV repo](https://github.com/pingcap/tikv/tree/master/etc)
* config/tidb.toml is copied from [TiDB repo](https://github.com/pingcap/tidb/tree/master/config)

If you find these configuration files outdated or mismatch with TiDB version, you can copy these files from their upstream repos and change their metrics addr with `pushgateway:9091`

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
$ cp compose/values.yaml values.yaml
$ vi values.yaml # custom cluster size, docker image, port mapping etc
$ helm template -f values.yaml compose > generated-docker-compose.yaml
$ docker-compose up -d -f generated-docker-compose.yaml
```

If you want to build docker image from source, leave pd/tikv/tidb image value empty and specify a repo and branch of each component in the values.yaml.

[tidb-vision](https://github.com/pingcap/tidb-vision) is a visiualization page of TiDB Cluster, it's WIP project and can be disabled by leaving `tidbVision` empty.

### Access TiDB cluster

TiDB uses ports: 4000(mysql) and 10080(status) by default

```bash
$ mysql -h 127.0.0.1 -P 4000 -u root
```

And Grafana uses port 3000 by default, so open your browser at http://localhost:3000 to view monitor dashboard

If you enabled tidb-vision, you can view it at http://localhost:8010
