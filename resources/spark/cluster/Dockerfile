# Dockerfile
FROM python:3.7-alpine

ARG SPARK_VERSION=YOUR_SPARK_VERSION
ARG HADOOP_VERSION=2.7

RUN wget -q https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
 && tar xzf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -C / \
 && rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
 && ln -s /spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} /spark

RUN apk update && \
    apk add bash coreutils procps && \
    apk fetch openjdk8 && \
    apk add openjdk8 && \
    pip3 install ipython

ENV PYSPARK_DRIVER_PYTHON ipython