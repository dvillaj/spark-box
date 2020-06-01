#!/bin/bash
source "/vagrant/scripts/common.sh"

function installPython3 {
    apt install -y python3-pip default-libmysqlclient-dev

    echo "alias python=python3" >> /home/vagrant/.bashrc
    echo "alias pip=pip3" >> /home/vagrant/.bashrc
}

function installPythonModules {
    pip3 install jupyterlab pandas ipython-sql mysqlclient matplotlib 
}

function installJupyterNotebook {
    sudo su - vagrant -c "cd; jupyter lab --generate-config"
    sed -i "s/#c.NotebookApp.ip = 'localhost'/c.NotebookApp.ip = '0.0.0.0'/" /home/vagrant/.jupyter/jupyter_notebook_config.py
    sed -i "s/#c.NotebookApp.token = '<generated>'/c.NotebookApp.token = ''/" /home/vagrant/.jupyter/jupyter_notebook_config.py
    sed -i "s/#c.NotebookApp.password = u''/c.NotebookApp.password = u''/" /home/vagrant/.jupyter/jupyter_notebook_config.py
    echo "c.NotebookApp.nbserver_extensions.append('ipyparallel.nbextension')" | tee -a /home/vagrant/.jupyter/jupyter_notebook_config.py
    chown -R vagrant:vagrant /home/vagrant/
}


function copyResources {
    mkdir -p /home/vagrant/notebooks
    cp $RESOURCES_DIR//notebooks/* /home/vagrant/notebooks
    chown -R vagrant:vagrant /home/vagrant/notebooks
}

echo "setup python"
installPython3
installPythonModules
installJupyterNotebook
copyResources