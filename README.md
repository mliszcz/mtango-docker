# mtango-docker

Dockerfile for [mTango](https://bitbucket.org/hzgwpn/mtango/overview) server.

## What's included

The image is based on Ubuntu 16.04. Following packages are installed:

* OpenJDK 8
* Apache Tomcat 8.0.x
* Tango 9.2.2
* mTango rc3-0.x

## Configuration

mTango is deployed at the ROOT context path (`/`).

The database will be configured automatically for these settings:

* class: `TangoRestServer`
* instance: `development`
* device: `test/rest/0`

You may pass following variables to the container:

* `TANGO_HOST` (**mandatory**)
* `PORT_AJP`(optional, default *8009*)
* `PORT_HTTP` (optional, default *8080*)
* `PORT_SHUTDOWN` (optional, default *8005*)
* `REST_USER` (optional, default *tango*)
* `REST_PASSWORD` (optional, default *tango*)
* `GROOVY_USER` (optional, default *groovy*)
* `GROOVY_PASSWORD` (optional, default *groovy*)
* `ADMIN_USER` (optional, default *admin*)
* `ADMIN_PASSWORD` (optional, default *admin*)

## Acknowledgements

* Thanks [vishnubob](https://github.com/vishnubob) for the `wait-for-it.sh`
  script;
