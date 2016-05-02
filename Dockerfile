# mTango Dockerfile

FROM java:9-jre
MAINTAINER mliszcz <liszcz.michal@gmail.com>

RUN echo "deb [trusted=yes] http://mliszcz.github.io/tango-cs-build/repository/ apt/" >> /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
  supervisor

RUN apt-get update && apt-get install -y \
  libmysqlclient18 \
  libomniorb4-1 \
  libzmq5 \
  libcos4-1

RUN apt-get update && apt-get install -y \
  libtango9 \
  libtango9-dev \
  tango9-tools \
  tango9-starter

RUN useradd -ms /bin/bash tango

ENV LD_LIBRARY_PATH=/usr/local/lib

ADD scripts/supervisord.conf /etc/supervisord.conf
ADD scripts/tango_register_device /usr/local/bin/
ADD scripts/wait-for-it.sh /usr/local/bin/

WORKDIR /home/tango

# ADD http://ftp.ps.pl/pub/apache/tomcat/tomcat-8/v8.5.0/bin/apache-tomcat-8.5.0.tar.gz /home/tango
# COPY scripts/apache-tomcat-8.5.0.tar.gz /home/tango
# COPY scripts/apache-tomcat-9.0.0.M4.tar.gz /home/tango
# COPY scripts/wildfly-servlet-10.0.0.Final.tar.gz /home/tango
COPY scripts/jetty-distribution-9.3.8.v20160314.tar.gz /home/tango

RUN chown -R tango:tango /home/tango/

# USER tango

# RUN tar -xf apache-tomcat-8.5.0.tar.gz && rm -rf apache-tomcat-8.5.0.tar.gz
# RUN tar -xf apache-tomcat-9.0.0.M4.tar.gz && rm -rf apache-tomcat-9.0.0.M4.tar.gz
# RUN tar -xf wildfly-servlet-10.0.0.Final.tar.gz && rm -rf wildfly-servlet-10.0.0.Final.tar.gz
RUN tar -xf jetty-distribution-9.3.8.v20160314.tar.gz && rm -rf jetty-distribution-9.3.8.v20160314.tar.gz

COPY scripts/mtango.war /home/tango/jetty-distribution-9.3.8.v20160314/webapps

RUN chown -R tango:tango /home/tango/

USER tango

EXPOSE 8080

CMD ["/bin/bash"]


# /usr/local/bin/tango_register_device TangoRestServer/development TangoRestServer test/rest/0

# add startup script
