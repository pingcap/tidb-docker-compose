FROM anapsix/alpine-java:8

ENV SPARK_VERSION=2.1.1 \
    HADOOP_VERSION=2.7 \
    TISPARK_VERSION=0.1.0-SNAPSHOT \
    SPARK_HOME=/opt/spark \
    SPARK_NO_DAEMONIZE=true \
    SPARK_MASTER_PORT=7077 \
    SPARK_MASTER_HOST=0.0.0.0 \
    SPARK_MASTER_WEBUI_PORT=8080

# base image only contains busybox version nohup and ps
# spark scripts needs nohup in coreutils and ps in procps
# and we can use mysql-client to test tidb connection
RUN apk --no-cache add coreutils procps mysql-client

RUN wget -q https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
    && tar zxf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -C /opt/ \
    && ln -s /opt/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} ${SPARK_HOME} \
    && wget -q http://download.pingcap.org/tispark-${TISPARK_VERSION}-jar-with-dependencies.jar -P ${SPARK_HOME}/jars \
    && wget -q http://download.pingcap.org/tispark-sample-data.tar.gz \
    && tar zxf tispark-sample-data.tar.gz -C ${SPARK_HOME}/data/ \
    && rm -rf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz tispark-sample-data.tar.gz

WORKDIR ${SPARK_HOME}
