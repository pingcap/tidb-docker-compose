# TiDB docker-compose

## Config

* config/pd.toml is copied from [PD repo](https://github.com/pingcap/pd/tree/master/conf)
* config/tikv.toml is copied from [TiKV repo](https://github.com/pingcap/tikv/tree/master/etc)
* config/tidb.toml is copied from [TiDB repo](https://github.com/pingcap/tidb/tree/master/config)

The above config files must be configured with metrics addr `pushgateway:9091`

And config/*-dashboard.json are copied from [TiDB-Ansible repo](https://github.com/pingcap/tidb-ansible/tree/master/scripts)


## Up

```bash
$ git clone https://github.com/tennix/tidb-docker-compose.git
$ cd tidb-docker-compose
$ docker-compose up -d
```

## Access

The services exposed by docker-compose are the followings:
* pd: 2379
* tidb: 4000, 10080
* prometheus: 9090
* grafana: 3000

### Access TiDB

```bash
$ mysql -h 127.0.0.1 -P 4000 -u root
```

### View Grafana monitor dashboard

open your browser at http://localhost:3000
