#!/bin/bash
source "/vagrant/scripts/common.sh"


function setupCluster { 
	echo "install bigdata cluster"
  	mkdir -p /opt/cluster
  	cp -r $RESOURCES_DIR/hadoop/cluster/* /opt/cluster

    docker pull mysql:5.7
  	sudo -H -u vagrant bash -c 'cd /opt/cluster && docker-compose build'
	# docker-compose up --scale spark-worker=3 -d
}


echo "setup cluster"
setupCluster