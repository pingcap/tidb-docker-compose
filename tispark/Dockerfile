FROM anapsix/alpine-java:8

ENV SPARK_VERSION=2.1.1 \
    HADOOP_VERSION=2.7 \
    TISPARK_VERSION=1.0.1 \
    TISPARK_R_VERSION=1.1 \
    TISPARK_PYTHON_VERSION=1.0.1 \
    SPARK_HOME=/opt/spark \
    SPARK_NO_DAEMONIZE=true \
    SPARK_MASTER_PORT=7077 \
    SPARK_MASTER_HOST=0.0.0.0 \
    SPARK_MASTER_WEBUI_PORT=8080

ADD R /TiSparkR

# base image only contains busybox version nohup and ps
# spark scripts needs nohup in coreutils and ps in procps
# and we can use mysql-client to test tidb connection
RUN apk --no-cache add \
        coreutils \
        mysql-client \
        procps \
        python \
        py-pip \
        R \
    && pip install --no-cache-dir pytispark==${TISPARK_PYTHON_VERSION} \
    && R CMD build TiSparkR \
    && R CMD INSTALL TiSparkR_${TISPARK_R_VERSION}.tar.gz \
    && rm -rf /TiSparkR_${TISPARK_R_VERSION}.tar.gz /TiSparkR

RUN wget -q https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
    && tar zxf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -C /opt/ \
    && ln -s /opt/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} ${SPARK_HOME} \
    && wget -q https://github.com/pingcap/tispark/releases/download/${TISPARK_VERSION}/tispark-core-${TISPARK_VERSION}-jar-with-dependencies.jar -P ${SPARK_HOME}/jars \
    && wget -q http://download.pingcap.org/tispark-sample-data.tar.gz \
    && tar zxf tispark-sample-data.tar.gz -C ${SPARK_HOME}/data/ \
    && rm -rf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz tispark-sample-data.tar.gz

ENV PYTHONPATH=${SPARK_HOME}/python/lib/py4j-0.10.4-src.zip:${SPARK_HOME}/python:$PYTHONPATH

WORKDIR ${SPARK_HOME}
