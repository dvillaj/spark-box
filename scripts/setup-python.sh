#!/bin/bash
source "/vagrant/scripts/common.sh"


function installPythonPackages {
	echo "installing python packages"

    apt update
    apt install -y python3-pip default-libmysqlclient-dev

    pip3 install jupyterlab pandas ipython-sql mysqlclient matplotlib pyspark==${SPARK_VERSION} findspark
}

function install nodejs {
    echo "installing nodejs"

    apt -y install curl dirmngr apt-transport-https lsb-release ca-certificates
    curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -

    sudo apt -y install nodejs
}

function install jupyterExtensions {
    pip3 install plotly
    jupyter labextension install jupyterlab-plotly
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
    chown -R vagrant:vagrant /home/vagrant/notebooks
}

function startJupyter {
    echo "starting jupyter service"
    cp $RESOURCES_DIR/jupyter/service/* /etc/systemd/system/
    systemctl enable jupyter.service
    systemctl daemon-reload
    systemctl start jupyter.service
}

function installToree {
    pip3 install toree
    jupyter toree install --spark_home=/opt/spark
}

function installPySparkKernel {
    mkdir -p /usr/local/share/jupyter/kernels/pyspark

    cp $RESOURCES_DIR/jupyter/kernels/pyspark/kernel.json /usr/local/share/jupyter/kernels/pyspark
    mkdir -p /home/vagrant/.ipython/profile_pyspark/startup
    cp $RESOURCES_DIR/jupyter/kernels/pyspark/*.py /home/vagrant/.ipython/profile_pyspark/startup
    chown -R vagrant:vagrant /home/vagrant/.ipython
}

function setupPython {
    echo "setting up python"

    ln -s /usr/bin/python3 /usr/bin/python
}


echo "setup python"
installPythonPackages
configureJupyter
startJupyter
installToree
installPySparkKernel
setupPython