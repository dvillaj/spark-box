#/bin/bash

source /etc/profile.d/hadoop.sh 

jupyter lab \
    --no-browser \
    --notebook-dir=/home/vagrant/notebooks \
    --port 8888