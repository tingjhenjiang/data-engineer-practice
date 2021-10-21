FROM cluster-base

# -- Layer: Apache Spark

ARG SPARK_VERSION=3.2.0
ARG HADOOP_VERSION=3.2
ARG SCALA_VERSION=2.13

RUN apt-get update -y && \
    apt-get install -y curl wget && \
    wget --debug -O spark.tgz "https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}-scala${SCALA_VERSION}.tgz" && \
    tar -xf spark.tgz && \
    mv "spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}-scala${SCALA_VERSION}" /usr/bin/ && \
    mkdir "/usr/bin/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}-scala${SCALA_VERSION}/logs" && \
    rm spark.tgz

ENV SPARK_HOME "/usr/bin/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}-scala${SCALA_VERSION}"
ENV SPARK_MASTER_HOST spark-master
ENV SPARK_MASTER_PORT 7077
ENV PYSPARK_PYTHON python3

# -- Runtime

WORKDIR ${SPARK_HOME}