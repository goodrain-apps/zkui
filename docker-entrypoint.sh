#!/bin/bash

[ $DEBUG ] && set -x

sed -i -r "s/(zkServer)=.*/\1=${ZK_HOST}:${ZK_PORT}/"  $ZKUI_CFG
sed -i -r "s#(\"password\"):\"manager\"#\1:\"${ZKUI_PASS}\"#" $ZKUI_CFG

sleep ${PAUSE:-0}

cd $ZKUI_DIR
java -jar zkui-2.0-SNAPSHOT-jar-with-dependencies.jar
