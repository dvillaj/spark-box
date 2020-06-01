#!/bin/bash
source "/vagrant/scripts/common.sh"

function installJava {
	echo "install java"
	apt update
	apt install -y openjdk-8-jdk maven
	cp -f $RESOURCES_DIR/hadoop/config/java.sh /etc/profile.d
}

function installHadoop {
	echo "installing hadoop"

	wget --quiet http://apache.rediris.es/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz
    tar -xzf hadoop-${HADOOP_VERSION}.tar.gz -C /usr/local
    ln -s /usr/local/hadoop-${HADOOP_VERSION} /usr/local/hadoop
    rm hadoop-${HADOOP_VERSION}.tar.gz
}

function setupHadoop {
	echo "setup hadoop"

	cp -f $RESOURCES_DIR/hadoop/config/*.xml /usr/local/hadoop/etc/hadoop
	cp -f $RESOURCES_DIR/hadoop/config/hadoop.sh /etc/profile.d
}

echo "setup hadoop"
installJava
installHadoop
setupHadoop