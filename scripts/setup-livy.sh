#!/bin/bash
source "/vagrant/scripts/common.sh"

function installSparkMagic {
    echo "installing sparkmagic"

    apt install -y libkrb5-dev
    pip3 install sparkmagic
}

function installNodeJS {
    echo "installing nodejs"

    apt -y install curl dirmngr apt-transport-https lsb-release ca-certificates
    curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
    apt update
    apt -y install gcc g++ make
    apt -y install nodejs
}

function setupSparkMagic {
    echo "setting up sparkmagic"

    jupyter labextension install "@jupyter-widgets/jupyterlab-manager"
    cd /usr/local/lib/python3.6/dist-packages
    jupyter-kernelspec install sparkmagic/kernels/pysparkkernel
}


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




echo "setup spark magic"
installSparkMagic
installNodeJS
setupSparkMagic
installLivy
setupLivy