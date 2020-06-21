#!/bin/bash
source "/vagrant/scripts/common.sh"


function installZookeeper {
	echo "downloading zookepper"
    wget -q https://downloads.apache.org/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz


	echo "installing zookepper"
    tar -C /opt -xzf apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz
    ln -s /opt/apache-zookeeper-${ZOOKEEPER_VERSION}-bin /opt/zookeeper
    rm apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz

    chown -R vagrant:vagrant  /opt/apache-zookeeper-${ZOOKEEPER_VERSION}-bin


	mkdir -p /app/zookeeper
	chmod -R 755 /app/zookeeper
	chown -R vagrant:vagrant /app/zookeeper

   	ln -s  /opt/zookeeper/conf /etc/zookeeper
}


function setupZookeeper {
	echo "seting up zookeeper"

	cp -f $RESOURCES_DIR/zookeeper/config/*.cfg /opt/zookeeper/conf
 	cp -f $RESOURCES_DIR/zookeeper/config/zookeeper.sh /etc/profile.d
}


function installKafka {
	echo "downloading kafka"
    wget -q https://downloads.apache.org/kafka/${KAFKA_VERSION}/kafka_2.12-${KAFKA_VERSION}.tgz


	echo "installing kafka"
    tar -C /opt -xzf kafka_2.12-${KAFKA_VERSION}.tgz
    ln -s /opt/kafka_2.12-${KAFKA_VERSION} /opt/kafka
    rm kafka_2.12-${KAFKA_VERSION}.tgz

    chown -R vagrant:vagrant /opt/kafka_2.12-${KAFKA_VERSION}


   	ln -s  /opt/kafka/config /etc/kafka
}

function setupKakfa {
	echo "seting up kafka"

 	cp -f $RESOURCES_DIR/kafka/config/kafka.sh /etc/profile.d
}

echo "setup kafka"
installZookeeper
setupZookeeper
installKafka
setupKakfa