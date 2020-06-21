#!/bin/bash
source "/vagrant/scripts/common.sh"


function installFlume {
	echo "downloading flume"
    wget -q https://downloads.apache.org/flume/${FLUME_VERSION}/apache-flume-${FLUME_VERSION}-bin.tar.gz


	echo "installing flume"
    tar -C /opt -xzf apache-flume-${FLUME_VERSION}-bin.tar.gz
    ln -s /opt/apache-flume-${FLUME_VERSION}-bin /opt/flume
    rm apache-flume-${FLUME_VERSION}-bin.tar.gz

    chown -R vagrant:vagrant /opt/apache-flume-${FLUME_VERSION}-bin 

	ln -s  /opt/flume/conf /etc/flume
}

function setupFlume {
	echo "seting up flume"

 	cp -f $RESOURCES_DIR/flume/config/flume.sh /etc/profile.d
}


echo "setup flume"
installFlume
setupFlume