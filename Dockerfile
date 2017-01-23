# mTango Dockerfile

FROM centos:7
MAINTAINER mliszcz <liszcz.michal@gmail.com>

ADD resources/maxiv.repo /etc/yum.repos.d/
ADD resources/supervisord.conf /etc/
ADD resources/tango_register_device /usr/local/bin/
ADD resources/wait-for-it.sh /usr/local/bin/
ADD resources/TangoRestServer /usr/local/bin/
ADD resources/tomcat-add-users.xsl /root/
ADD resources/tomcat-enable-cors.xsl /root/
ADD https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.11/bin/apache-tomcat-8.5.11.tar.gz /root/tomcat.tar.gz
ADD https://bitbucket.org/hzgwpn/mtango/downloads/mtango.server-rc3-0.1.zip /root/mtango.zip

RUN yum -y install epel-release && \
    yum -y install \
        supervisor \
        unzip \
        xmlstarlet \
        tango-starter \
        java-1.8.0-openjdk-headless

ENV CATALINA_HOME=/opt/tomcat

RUN cd /root \
    && mkdir -p $CATALINA_HOME \
    && tar xf tomcat.tar.gz -C $CATALINA_HOME --strip-components=1 \
    && unzip mtango.zip \
    && rm -rf $CATALINA_HOME/webapps/* \
    && mv tango.war $CATALINA_HOME/webapps/ROOT.war \
    && rm -f tomcat.tar.gz \
    && rm -f mtango.zip \
    && xmlstarlet tr tomcat-add-users.xsl $CATALINA_HOME/conf/tomcat-users.xml \
        | xmlstarlet fo -s 2 > tomcat-users.xml \
    && mv tomcat-users.xml $CATALINA_HOME/conf/ \
    && xmlstarlet ed -L -u "//Server/Service[@name='Catalina']/Connector[@protocol='HTTP/1.1']/@port" -v '${port.http}' $CATALINA_HOME/conf/server.xml \
    && xmlstarlet ed -L -u "//Server/@port" -v '${port.shutdown}' $CATALINA_HOME/conf/server.xml \
    && xmlstarlet ed -L -u "//Server/Service[@name='Catalina']/Connector[@protocol='AJP/1.3']/@port" -v '${port.ajp}' $CATALINA_HOME/conf/server.xml

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
