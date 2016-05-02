# mTango Dockerfile

FROM tomcat:8.5-jre8
MAINTAINER mliszcz <liszcz.michal@gmail.com>

RUN echo "deb [trusted=yes] http://mliszcz.github.io/tango-cs-build/repository/ apt/" >> /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
  libomniorb4-1 \
  libzmq3 \
  libcos4-1

RUN apt-get update && apt-get install -y \
  libtango9 \
  libtango9-dev \
  tango9-tools \
  tango9-db \
  tango9-starter \
  tango9-accesscontrol \
  tango9-test

ENV LD_LIBRARY_PATH=/usr/local/lib

EXPOSE 8080

RUN useradd -ms /bin/bash tango

# USER tango

CMD ["/bin/bash"]
