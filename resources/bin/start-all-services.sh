#/bin/bash

function startHadoop {
    echo "Starting hadoop ..."
    start-all.sh

    echo "Starting historyserver ..."
    mr-jobhistory-daemon.sh start historyserver
}

function startHive {
    echo "Starting hiveserver2 ..."
    hive --service hiveserver2  > /opt/hive/logs/hive2.log 2>&1 &

    echo "Starting metastore ..."
    hive --service metastore  > /opt/hive/logs/metastore.log 2>&1 &
}

function startSpark {
    echo "Starting spark ..."
    pushd . > /dev/null
    cd /opt/spark-cluster
    docker-compose build
    docker-compose up -d --scale spark-worker=2
    popd > /dev/null
}

function startZookeeper {
    echo "Starting zookeper ..."

    zkServer.sh start
}

startHadoop
startHive
startSpark
startZookeeper