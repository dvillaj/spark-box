#!/bin/bash
source "/vagrant/scripts/common.sh"

function installJava {
	echo "installing java"
	apt update
	apt install -y openjdk-8-jdk maven
	cp -f $RESOURCES_DIR/java/config/java.sh /etc/profile.d
}

function generateSshKeys {
	echo "seting up ssh keys"

	sudo -H -u vagrant bash -c 'cd; cat /dev/zero | ssh-keygen -q -N ""'
	cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
}

function installHadoop {
	echo "installing hadoop"

	wget -q https://downloads.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz
	tar -C /opt -xzf hadoop-${HADOOP_VERSION}.tar.gz
	ln -s /opt/hadoop-${HADOOP_VERSION} /opt/hadoop
	rm hadoop-${HADOOP_VERSION}.tar.gz

	mkdir -p /app/hadoop/tmp
	mkdir -p /app/hadoop/dfs/namenode
  	mkdir -p /app/hadoop/dfs/datanode

	chown -R vagrant:vagrant /app/hadoop
	chmod a+rw -R /app/hadoop/tmp
}

function setupHadoop {
	echo "seting up hadoop"

	cp -f $RESOURCES_DIR/hadoop/config/*.xml /opt/hadoop/etc/hadoop
	sed -i "s/YOUR_IP/$LOCAL_IP/" /opt/hadoop/etc/hadoop/core-site.xml

	echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/" >> /opt/hadoop/etc/hadoop/hadoop-env.sh


 	cp -f $RESOURCES_DIR/hadoop/config/hadoop.sh /etc/profile.d
}

echo "setup hadoop"
installJava
installHadoop
generateSshKeys
setupHadoop