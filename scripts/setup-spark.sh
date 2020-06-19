#!/bin/bash
source "/vagrant/scripts/common.sh"


function installSpark {
	echo "downloading spark"  
    wget -q https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${SPARK_HADOOP_VERSION}.tgz


	echo "installing spark"
    tar -C /opt -xzf spark-${SPARK_VERSION}-bin-hadoop${SPARK_HADOOP_VERSION}.tgz
    ln -s /opt/spark-${SPARK_VERSION}-bin-hadoop${SPARK_HADOOP_VERSION} /opt/spark
    rm spark-${SPARK_VERSION}-bin-hadoop${SPARK_HADOOP_VERSION}.tgz  
}

function setupSpark {
    echo "setting up spark"

    cp /opt/hadoop/etc/hadoop/core-site.xml /opt/spark/conf/
    cp /opt/hadoop/etc/hadoop/hdfs-site.xml /opt/spark/conf/

    cp $RESOURCES_DIR/spark/config/* /opt/spark/conf
    sed -i "s/YOUR_IP/$LOCAL_IP/" /opt/spark/conf/hive-site.xml
    
	cp -f $RESOURCES_DIR/spark/config/spark.sh /etc/profile.d
}


function installSparkCluster {
	echo "installing spark cluster"
    mkdir -p /opt/spark-cluster
    cp $RESOURCES_DIR/spark/cluster/* /opt/spark-cluster

    sed -i "s/YOUR_SPARK_VERSION/$SPARK_VERSION/" /opt/spark-cluster/Dockerfile

    sudo -H -u vagrant bash -c 'cd /opt/spark-cluster && docker-compose build'
}


echo "setup spark"
installSpark
setupSpark
installSparkCluster