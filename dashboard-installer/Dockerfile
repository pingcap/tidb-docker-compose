FROM python:2.7-alpine

RUN apk add --no-cache ca-certificates curl

ADD dashboards /

ENTRYPOINT ["/tidb-dashboard-installer.sh"]
