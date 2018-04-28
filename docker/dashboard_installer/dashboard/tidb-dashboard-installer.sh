#!/bin/sh

url=$1
datasource_url="http://${url}/api/datasources"
echo "Adding datasource..."
until curl -s -XPOST -H "Content-Type: application/json" --connect-timeout 1 -u admin:admin ${datasource_url} -d @/datasource.json >/dev/null; do
    sleep 1
done

python grafana-config-copy.py "http://${url}/"
