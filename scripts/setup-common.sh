#!/bin/bash
source "/vagrant/scripts/common.sh"

function installBinaries {
    echo "installing binaries"

    cp $RESOURCES_DIR/bin/*.sh /usr/local/bin
    chmod a+x /usr/local/bin/*.sh
}

function updateSystem {
    echo "update system"

    apt update
    apt upgrade -y
    #reboot
}

echo "setup common"
installBinaries
updateSystem