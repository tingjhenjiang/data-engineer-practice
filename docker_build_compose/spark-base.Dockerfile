FROM cluster-base

# -- Layer: Apache Spark
# https://www.kdnuggets.com/2020/07/apache-spark-cluster-docker.html

ARG SPARK_VERSION=3.2.0
ARG HADOOP_VERSION=3.2
ARG SCALA_VERSION=2.13

RUN apt-get update -y && \
    apt-get install -y curl wget && \
    wget --debug -O spark.tgz "https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" && \
    tar -xf spark.tgz && \
    mv "spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}" /usr/bin/ && \
    mkdir "/usr/bin/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}/logs" && \
    rm spark.tgz
#-scala${SCALA_VERSION}

ENV SPARK_HOME "/usr/bin/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}"
ENV SPARK_MASTER_HOST spark-master
ENV SPARK_MASTER_PORT 7077
ENV PYSPARK_PYTHON python3

# in case PYSPARK_PYTHON not equals to PYSPARK_DRIVER_PYTHON

# -- Runtime

WORKDIR ${SPARK_HOME}