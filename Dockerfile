FROM anapsix/alpine-java:jdk8

MAINTAINER zhouyq <zhouyq@goodrain.com>

ENV JAVA_HOME=/opt/jdk
ENV MAVEN_VER=3.3.9
ENV ZKUI_DIR=/opt/zkui
ENV ZKUI_CFG="${ZKUI_DIR}/config.cfg"

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
    
RUN apk add --no-cache wget curl netcat-openbsd && apk del --no-cache git tzdata

ADD docker-entrypoint.sh /usr/bin/

RUN chmod +x /usr/bin/docker-entrypoint.sh 

WORKDIR /opt/zkui

EXPOSE 9090

ENTRYPOINT ["docker-entrypoint.sh"]
