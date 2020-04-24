pushd . > /dev/null
cd /opt/spark-cluster
docker-compose build
docker-compose up -d --scale spark-worker=2
popd > /dev/null