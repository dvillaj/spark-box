# Dockerfile
FROM ubuntu:18.04

MAINTAINER dvillaj@gmail.com

RUN apt-get update && apt-get install -y openssh-server openjdk-8-jdk wget

ARG SPARK_VERSION=YOUR_SPARK_VERSION
ARG HADOOP_VERSION=2.7

RUN wget -q https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
 && tar xzf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -C / \
 && rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
 && ln -s /spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} /spark

ENV SPARK_HOME=/spark
#ENV PYSPARK_DRIVER_PYTHON=ipython
#export PYSPARK_PYTHON=/usr/bin/python
#export PYSPARK_DRIVER_PYTHON=/usr/bin/python
#export PYSPARK3_PYTHON=/usr/bin/python3
#export PYSPARK3_DRIVER_PYTHON=/usr/bin/python3
#export SPARK_MASTER_OPTS="-Dspark.deploy.defaultCores=4"

EXPOSE 8080 7077