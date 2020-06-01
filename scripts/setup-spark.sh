#!/bin/bash
source "/vagrant/scripts/common.sh"

function installSpark {
	echo "installing spark"

    wget -q https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${SPARK_HADOOP_VERSION}.tgz
    tar -C /usr/local -xzf spark-${SPARK_VERSION}-bin-hadoop${SPARK_HADOOP_VERSION}.tgz
    ln -s /usr/local/spark-${SPARK_VERSION}-bin-hadoop${SPARK_HADOOP_VERSION} /usr/local/spark
    rm spark-${SPARK_VERSION}-bin-hadoop${SPARK_HADOOP_VERSION}.tgz
}

function setupSpark {
	echo "setup Spark"

	cp -f $RESOURCES_DIR/spark/config/*.xml /usr/local/spark/conf
	cp -f $RESOURCES_DIR/spark/config/*.sh /etc/profile.d
}

function setupPython {
    pip3 install pyspark==${SPARK_VERSION}
}


echo "setup spark"
installSpark
setupSpark
setupPython