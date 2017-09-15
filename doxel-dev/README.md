## DOXEL-DEV ##

Docker container to develop and test [doxel.org](https://www.doxel.org) [backend](https://github.com/doxel/doxel-loopback) and [frontend](https://github.com/doxel/doxel-angular)

## BUILD THE CONTAINER ##

For example with:

```
DEBIAN_MIRROR=ftp.ch.debian.org NVM_VERSION=v0.33.0 NODE_VERSION=v6.9.4 build.sh 
```

## RUN THE CONTAINER ##

For example with:
```
docker run --name doxel -itp 3001:3001 doxel/dev:latest
```
This will start a server cluster using slc.

## CONNECT WITH YOUR BROWSER ##

For example with:
```
xdg-open http://127.0.0.1:3001/app/
```

## OPEN A SHELL ##

For example with:

```
docker exec -itu root doxel /bin/bash
```
## ALL IN ONE ##

Start (or reattach to) a screen session with:
1. The container running
2. A shell as root user in the container
3. A a shell as doxel user in the container

with:
```
./doxel.sh [ --inspect ]
```
* When the container exists already it is attached or restarted, to start with a fresh container, delete it before with eg 
```
docker rm doxel
```

* When using the --inspect option, the backend is launched directly using node in a single thread, and you can click on the "Open the dedicated DevTool for Node" link displayed on chrome://inspect#devices to inspect or debug the backend code.  (You need a recent Chrome or Chromium version >= 58)

* Without the --inspect option, a backend cluster is run using slc

* When the screen session already exists only step 1 is performed

