#!/bin/sh

cd $2
CLASSPATH=${PWD}"/conf"
for file in $(ls ./lib/ | awk '{print $1}')
do
    CLASSPATH=${CLASSPATH}":"${PWD}"/lib/"${file}
done
for file in $(ls ./lib/jetty | awk '{print $1}')
do
    CLASSPATH=${CLASSPATH}":"${PWD}"/lib/jetty/"${file}
done
CLASSPATH=${CLASSPATH}":"

case $1 in
start)
    jre/bin/java -Xms2G -Xmx6G -XX:NewSize=256m -XX:MaxNewSize=512m -Dfile.encoding=UTF-8 -classpath "${CLASSPATH}" com.topvision.console.JConsoleService;;
stop)
    jre/bin/java -classpath "$CLASSPATH" com.topvision.console.JConsoleService stop;;
*);;
esac


