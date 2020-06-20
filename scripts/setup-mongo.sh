#!/bin/bash
source "/vagrant/scripts/common.sh"


function installMongo {

	echo "installing mongo"
    sudo apt install -y mongodb
    
}

function setupMongo {

    echo "setting up mongo"

    sed "s/bind_ip = 127.0.0.1/bind_ip = 0.0.0.0/" -i  /etc/mongodb.conf
    systemctl restart mongodb

}

echo "setup mongo"
installMongo
setupMongo