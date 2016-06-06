FROM anapsix/alpine-java:jdk8

MAINTAINER zhouyq <zhouyq@goodrain.com>

ENV JAVA_MAJOR=8
ENV JAVA_UPDATE=77
ENV JAVA_BUILD=03

ENV JAVA_HOME=/opt/jdk1.${JAVA_MAJOR}.0_${JAVA_UPDATE}
ENV MAVEN_VER=3.3.9
ENV ZKUI_DIR=/opt/zkui
ENV ZKUI_CFG="${ZKUI_DIR}/conf/config.cfg"

# timezone
RUN apk add --no-cache tzdata && \
       cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
       echo "Asia/Shanghai" >  /etc/timezone && \
       date && apk del --no-cache tzdata

# add bash and git
RUN apk add --no-cache bash git && \
    sed -i -e "s/bin\/ash/bin\/bash/" /etc/passwd
    
RUN mkdir -p /tmp && \
    cd /tmp && \
    wget http://ftp.riken.jp/net/apache/maven/maven-3/${MAVEN_VER}/binaries/apache-maven-${MAVEN_VER}-bin.tar.gz && \
    tar xvzf apache-maven-${MAVEN_VER}-bin.tar.gz && \
    git clone https://github.com/DeemOpen/zkui.git && \
    cd /tmp/zkui && \
    /tmp/apache-maven-${MAVEN_VER}/bin/mvn clean install && \
    mv target/zkui-2.0-SNAPSHOT-jar-with-dependencies.jar ${ZKUI_DIR} && \
    mv config.cfg ${ZKUI_DIR}
    
# clean
RUN cd /tmp/ && \
    rm -fr /tmp/* /root/.mvn2 
    
RUN apk add --no-cache wget curl netcat-openbsd && apk del git tzdata

ADD docker-entrypoint.sh /usr/bin/

RUN chmod +x /usr/bin/docker-entrypoint.sh 

WORKDIR $ZKUI_DIR

EXPOSE 9000

ENTRYPOINT ["docker-entrypoint.sh"]