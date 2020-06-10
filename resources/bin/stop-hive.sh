
for i in $(ps -ef | grep hiveserver2 | awk '{ print $2 }' | head -n 1); do kill -9 $i; done
for i in $(ps -ef | grep metastore | awk '{ print $2 }' | head -n 1); do kill -9 $i; done