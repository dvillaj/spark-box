#!/bin/bash
source "/vagrant/scripts/common.sh"


function installPythonPackages {
	echo "installing python packages"

    apt update
    apt install -y python3-pip default-libmysqlclient-dev

    pip3 install jupyterlab pandas ipython-sql mysqlclient matplotlib pyspark==${SPARK_VERSION}
}

function configureJupyter {
    echo "setting up jupyter"

    sudo su - vagrant -c "cd; jupyter lab --generate-config"
    sed -i "s/#c.NotebookApp.ip = 'localhost'/c.NotebookApp.ip = '0.0.0.0'/" /home/vagrant/.jupyter/jupyter_notebook_config.py
    sed -i "s/#c.NotebookApp.token = '<generated>'/c.NotebookApp.token = ''/" /home/vagrant/.jupyter/jupyter_notebook_config.py
    sed -i "s/#c.NotebookApp.password = u''/c.NotebookApp.password = u''/" /home/vagrant/.jupyter/jupyter_notebook_config.py
    echo "c.NotebookApp.nbserver_extensions.append('ipyparallel.nbextension')" | tee -a /home/vagrant/.jupyter/jupyter_notebook_config.py

    mkdir -p /home/vagrant/notebooks
    cp $RESOURCES_DIR/notebooks/* /home/vagrant/notebooks
    chown vagrant:vagrant /home/vagrant/notebooks
}

function startJupyter {
    echo "starting jupyter service"
    cp $RESOURCES_DIR/jupyter/service/* /etc/systemd/system/
    systemctl enable jupyter.service
    systemctl daemon-reload
    systemctl start jupyter.service
}

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


echo "setup python"
installPythonPackages
configureJupyter
startJupyter
installSparkMagic
installNodeJS
setupSparkMagic