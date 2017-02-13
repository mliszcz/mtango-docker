# Supported tags and respective `Dockerfile` links

* [`rc3-0.1`, `latest` (*Dockerfile*)](https://github.com/mliszcz/mtango-docker/blob/master/Dockerfile)

# mTango

> mTangoSDK (mobile Tango Software Development Kit)'s main goal is to give
> developers tools for rapid development of web/mobile tango applications.

For more information please visit [bitbucket.org/hzgwpn/mtango/overview](https://bitbucket.org/hzgwpn/mtango/overview).

# How to use this image

A running instance of Tango is required to use this image. Pass the mandatory
`TANGO_HOST` variable during container creation:

```console
docker run -it --rm --name tango_mtango \
  -e TANGO_HOST=172.18.0.3:10000 \
  mliszcz/mtango:latest
```

The database will be configured automatically for these settings:

* class: `TangoRestServer`
* instance: `development`
* device: `test/rest/0`

mTango is deployed at the ROOT context path (`/`). By default the server
listens on port 8080. Visit following url in your browser
<http://{container-ip}:8080/rest/rc3>. You should see:

```json
{"hosts":"http://172.18.0.5:8080/rest/rc3/hosts","x-auth-method":"basic"}
```

You may pass following variables to the container:

* `PORT_AJP` (default *8009*)
* `PORT_HTTP` (default *8080*)
* `PORT_SHUTDOWN` (default *8005*)
* `REST_USER` (default *tango*)
* `REST_PASSWORD` (default *tango*)
* `GROOVY_USER` (default *groovy*)
* `GROOVY_PASSWORD` (default *groovy*)
* `ADMIN_USER` (default *admin*)
* `ADMIN_PASSWORD` (default *admin*)

# Acknowledgements

* Thanks [vishnubob](https://github.com/vishnubob) for the `wait-for-it.sh`
  script;
