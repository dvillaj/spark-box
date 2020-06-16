#/bin/bash

#source /home/vagrant/.environment

#export PGHOST=localhost
#export PGUSER=postgres
#export PGPASSWORD=postgres

#alias postgres="docker-compose -f /opt/compose/compose-postgres/docker-compose.yml"
#alias riak="docker-compose -f /opt/compose/compose-riak/docker-compose.yml"
#alias riak-admin="docker exec -it compose-riak_coordinator_1 riak-admin"
#alias cassandra="docker-compose -f /opt/compose/compose-cassandra/docker-compose.yml"
#alias mongo="docker-compose -f /opt/compose/compose-mongodb/docker-compose.yml"
#alias neo4j="docker-compose -f /opt/compose/compose-neo4j/docker-compose.yml"
#alias python=python3

jupyter lab \
    --no-browser \
    --notebook-dir=/home/vagrant/notebooks \
    --port 8888