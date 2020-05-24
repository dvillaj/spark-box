#!/bin/bash
source "/vagrant/scripts/common.sh"

function installJava {
	echo "install java"
	apt-get update
	apt-get install -y openjdk-8-jdk
	cp -f $RESOURCES_DIR/hadoop/config/java.sh /etc/profile.d
}

function installHadoop {
	echo "install hadoop from remote file"

	wget --quiet http://apache.rediris.es/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz
    tar -xzf hadoop-${HADOOP_VERSION}.tar.gz -C /usr/local
    ln -s /usr/local/hadoop-${HADOOP_VERSION} /usr/local/hadoop
    rm hadoop-${HADOOP_VERSION}.tar.gz
}

function setupHadoop {
	echo "copying over hadoop configuration files"

	cp -f $RESOURCES_DIR/hadoop/config/*.xml /usr/local/hadoop//etc/hadoop
	cp -f $RESOURCES_DIR/hadoop/config/hadoop.sh /etc/profile.d
}

function setupHadoopCluster { 
	echo "install hadoop cluster"
  	mkdir -p /opt/hadoop-cluster
  	cp -r $RESOURCES_DIR/hadoop/cluster/* /opt/hadoop-cluster

  	sudo -H -u vagrant bash -c 'cd /opt/hadoop-cluster && docker-compose build && docker-compose up -d'
}

function configureHadoopCluster {

	echo "configuring hadoop cluster"

	echo 1
	source "/vagrant/resources/hadoop/config/hadoop.sh"
	echo 2
	source "/vagrant/resources/hadoop/config/java.sh"

	echo 3
	hadoop fs -mkdir -p /user/root

	echo 4
	hadoop fs -mkdir -p /user/vagrant

	echo 5
	hadoop fs -chown vagrant:vagrant /user/vagrant
}



echo "setup hadoop"
installJava
installHadoop
setupHadoop
setupHadoopCluster
configureHadoopCluster