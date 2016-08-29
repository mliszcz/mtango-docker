# mTango Dockerfile

FROM ubuntu:xenial
MAINTAINER mliszcz <liszcz.michal@gmail.com>

RUN echo "deb [trusted=yes] http://mliszcz.github.io/tango-cs-build/repository/ apt/" >> /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
    openjdk-8-jre \
    supervisor \
    xmlstarlet \
    zip

RUN apt-get update && apt-get install -y \
    libmysqlclient20 \
    libomniorb4-1 \
    libzmq5 \
    libcos4-1

RUN apt-get update && apt-get install -y \
    libtango9 \
    libtango9-dev \
    tango9-tools \
    tango9-starter

ENV LD_LIBRARY_PATH=/usr/local/lib \
    JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

ADD scripts/supervisord.conf /etc/
ADD scripts/tango_register_device /usr/local/bin/
ADD scripts/wait-for-it.sh /usr/local/bin/
ADD scripts/TangoRestServer /usr/local/bin/

RUN useradd -ms /bin/bash tomcat

WORKDIR /home/tomcat

ADD https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.36/bin/apache-tomcat-8.0.36.tar.gz /home/tomcat/apache-tomcat.tar.gz
ADD https://bitbucket.org/hzgwpn/mtango/downloads/mtango.server-rc3-0.1.zip /home/tomcat/mtango.zip

ADD scripts/tomcat-add-users.xsl /home/tomcat/
ADD scripts/tomcat-enable-cors.xsl /home/tomcat/

RUN mkdir -p apache-tomcat && \
    tar xf apache-tomcat.tar.gz -C apache-tomcat --strip-components=1 && \
    rm -f apache-tomcat.tar.gz && \
    xmlstarlet tr tomcat-add-users.xsl apache-tomcat/conf/tomcat-users.xml | xmlstarlet fo -s 2 > tomcat-users.xml && \
    mv tomcat-users.xml apache-tomcat/conf/ && \
    unzip mtango.zip && \
    rm -f mtango.zip && \
    rm -rf apache-tomcat/webapps/* && \
    mv tango.war apache-tomcat/webapps/ROOT.war && \
    xmlstarlet ed -L -u "//Server/Service[@name='Catalina']/Connector[@protocol='HTTP/1.1']/@port" -v '${port.http}' apache-tomcat/conf/server.xml && \
    xmlstarlet ed -L -u "//Server/@port" -v '${port.shutdown}' apache-tomcat/conf/server.xml && \
    xmlstarlet ed -L -u "//Server/Service[@name='Catalina']/Connector[@protocol='AJP/1.3']/@port" -v '${port.ajp}' apache-tomcat/conf/server.xml

RUN chown -R tomcat:tomcat /home/tomcat/

USER tomcat

ENV PORT_AJP=8009 \
    PORT_HTTP=8080 \
    PORT_SHUTDOWN=8005 \
    REST_USER=tango \
    REST_PASSWORD=tango \
    GROOVY_USER=groovy \
    GROOVY_PASSWORD=groovy \
    ADMIN_USER=admin \
    ADMIN_PASSWORD=admin

EXPOSE 8080

CMD /usr/local/bin/wait-for-it.sh $TANGO_HOST --timeout=30 --strict -- \
    /usr/bin/supervisord -c /etc/supervisord.conf
