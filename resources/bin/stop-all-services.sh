#/bin/bash

function stopHadoop {
    echo "Stoping historyserver ..."
    mr-jobhistory-daemon.sh stop historyserver
    
    echo "Stoping hadoop ..."
    stop-all.sh
}

function stopHive {
    echo "Stoping hiveserver2 ..."
    for i in $(ps -ef | grep hiveserver2 | awk '{ print $2 }' | head -n 1); do kill -9 $i; done

    echo "Stoping metastore ..."
    for i in $(ps -ef | grep metastore | awk '{ print $2 }' | head -n 1); do kill -9 $i; done
}

function stopSpark {
    echo "Stoping spark ..."
    pushd . > /dev/null
    cd /opt/spark-cluster
    docker-compose down
    popd > /dev/null
}

stopSpark
stopHive
stopHadoop