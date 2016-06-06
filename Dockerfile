FROM anapsix/alpine-java:jdk8

MAINTAINER zhouyq <zhouyq@goodrain.com>

ENV JAVA_HOME=/opt/jdk
ENV ZKUI_DIR=/opt/zkui
ENV ZKUI_CFG="${ZKUI_DIR}/config.cfg"

# timezone
RUN apk add --no-cache tzdata && \
       cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
       echo "Asia/Shanghai" >  /etc/timezone && \
       date && apk del --no-cache tzdata

# add bash and git
RUN apk add --no-cache bash && \
    sed -i -e "s/bin\/ash/bin\/bash/" /etc/passwd
    
RUN mkdir -p /tmp $ZKUI_DIR && \
    cd /tmp && \
    wget https://github.com/goodrain-apps/zkui/releases/download/v20160606/zkui.tar.gz && \
    tar xvzf zkui.tar.gz -C $ZKUI_DIR 
    
# clean
RUN rm -fr /tmp/* 
    
RUN apk add --no-cache wget curl netcat-openbsd && apk del --no-cache tzdata

ADD docker-entrypoint.sh /usr/bin/

RUN chmod +x /usr/bin/docker-entrypoint.sh 


EXPOSE 9090

ENTRYPOINT ["docker-entrypoint.sh"]
