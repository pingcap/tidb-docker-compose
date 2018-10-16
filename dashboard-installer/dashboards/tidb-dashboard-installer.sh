#!/bin/sh

url=$1
userName=${GRAFANA_USERNAME:-admin}
password=${GRAFANA_PASSWORD:-admin}
datasource_url="http://${url}/api/datasources"
echo "Adding datasource..."
until curl -s -XPOST -H "Content-Type: application/json" --connect-timeout 1 -u ${userName}:${password} ${datasource_url} -d @/datasource.json >/dev/null; do
    sleep 1
done

python grafana-config-copy.py "http://${url}/" ${userName} ${password}
