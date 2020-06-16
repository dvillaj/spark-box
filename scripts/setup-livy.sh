#!/bin/bash
source "/vagrant/scripts/common.sh"


function installLivy {
	echo "installing livy"

	apt install -y unzip

    wget -q  http://archive.apache.org/dist/incubator/livy/${LIVY_VERSION}-incubating/apache-livy-${LIVY_VERSION}-incubating-bin.zip
    unzip apache-livy-${LIVY_VERSION}-incubating-bin
    mv apache-livy-${LIVY_VERSION}-incubating-bin /opt
    ln -s /opt/apache-livy-${LIVY_VERSION}-incubating-bin /opt/livy
    rm apache-livy-${LIVY_VERSION}-incubating-bin.zip

    chown -R vagrant:vagrant /opt/apache-livy-${LIVY_VERSION}-incubating-bin
}

function setupLivy {
    echo "setting up livy"

    cp $RESOURCES_DIR/livy/config/* /opt/livy/conf

    mkdir /home/vagrant/.sparkmagic
    cp $RESOURCES_DIR/livy/sparkmagic/* /home/vagrant/.sparkmagic
    chown -R vagrant:vagrant /home/vagrant/.sparkmagic
}


echo "setup livy"
installLivy
setupLivy