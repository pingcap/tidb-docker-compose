# TiDB docker-compose

## Config

* config/pd.toml is copied from [PD repo](https://github.com/pingcap/pd/tree/master/conf)
* config/tikv.toml is copied from [TiKV repo](https://github.com/pingcap/tikv/tree/master/etc)
* config/tidb.toml is copied from [TiDB repo](https://github.com/pingcap/tidb/tree/master/config)

The above config files must be configured with metrics addr `pushgateway:9091`

And config/*-dashboard.json are copied from [TiDB-Ansible repo](https://github.com/pingcap/tidb-ansible/tree/master/scripts)

## Install Helm

[Helm](https://helm.sh) is used as a template render engine

```
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash
```

Or if you use Mac, you can use homebrew to install Helm by `brew install kubernetes-helm`

## Bring up TiDB cluster

```bash
$ git clone https://github.com/tennix/tidb-docker-compose.git
$ cd tidb-docker-compose
$ cp compose/values.yaml values.yaml
$ vi values.yaml # custom cluster size, docker image, port mapping etc
$ helm template -f values.yaml compose > docker-compose.yaml
$ docker-compose up -d
```

## Access TiDB cluster

TiDB uses ports: 4000(mysql) and 10080(status) by default

```bash
$ mysql -h 127.0.0.1 -P 4000 -u root
```

And Grafana uses port 3000 by default, so open your browser at http://localhost:3000 to view monitor dashboard
