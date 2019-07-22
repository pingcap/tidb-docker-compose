FROM anapsix/alpine-java:8

ENV SPARK_VERSION=2.3.3 \
    HADOOP_VERSION=2.7 \
    TISPARK_VERSION=2.2.0-SNAPSHOT \
    TISPARK_R_VERSION=1.1 \
    TISPARK_PYTHON_VERSION=2.0 \
    SPARK_HOME=/opt/spark \
    SPARK_NO_DAEMONIZE=true \
    SPARK_MASTER_PORT=7077 \
    SPARK_MASTER_HOST=0.0.0.0 \
    SPARK_MASTER_WEBUI_PORT=8080

ADD R /TiSparkR
ADD tispark-tests /opt/tispark-tests

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
    && cp /opt/tispark-tests/tests/session.py ${SPARK_HOME}/python/pyspark/sql/ \
	&& wget -q https://github.com/pingcap/tispark/releases/download/v2.1.1/tispark-core-2.1.1-spark_2.3-jar-with-dependencies.jar \
	&& cp tispark-core-2.1.1-spark_2.3-jar-with-dependencies.jar ${SPARK_HOME}/jars \
    && wget -q http://download.pingcap.org/tispark-sample-data.tar.gz \
    && tar zxf tispark-sample-data.tar.gz -C ${SPARK_HOME}/data/ \
    && rm -rf /opt/assembly/ spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz tispark-latest-linux-amd64.tar.gz tispark-sample-data.tar.gz

ADD conf/log4j.properties /opt/spark/conf/log4j.properties

ENV PYTHONPATH=${SPARK_HOME}/python/lib/py4j-0.10.4-src.zip:${SPARK_HOME}/python:$PYTHONPATH

WORKDIR ${SPARK_HOME}
