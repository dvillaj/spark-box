#!/bin/bash
source "/vagrant/scripts/common.sh"

function installDocker {
	echo "install docker"

    apt update
    apt install -y -qq apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
    apt install -y docker-ce
    usermod -aG docker vagrant
}

function installDockerCompose {
  echo "install docker"

  curl -sL https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
}

echo "setup docker"

installDocker
installDockerCompose