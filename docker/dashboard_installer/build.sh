#!/bin/bash -e

VERSION=${VERSION:-v2.0.0}
REGISTRY=${REGISTRY:-uhub.ucloud.cn/pingcap}
IMAGE_NAME=${IMAGE_NAME:-tidb-dashboard-installer}
MONITOR_TPLS="overview-dashboard.json pd-dashboard.json tidb-dashboard.json tikv-dashboard.json"

### change workspace
WORKSPACE=$(cd $(dirname $0)/../..; pwd)
cd ${WORKSPACE}

for mtpl in ${MONITOR_TPLS}
do
    destFile=`echo ${mtpl}|awk -F"[-.]" '{print $1"."$3}'`
    cp config/${mtpl} docker/dashboard_installer/dashboard/${destFile}
done
cd docker/dashboard_installer && docker build -t ${REGISTRY}/${IMAGE_NAME}:${VERSION} .
