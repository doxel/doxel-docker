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
## EASIER SHOULD BE BETTER ##

Instead of all the above, just use doxel.sh

* This method is incompatible with Docker version 17.06.2-ce as mentionned in issue#1
  Downgrade to docker version 17.05.0-ce if needed.

It will start (or reattach to) a gnu screen session with:
1. The container running
2. A doxel user shell
3. A root user shell

Then it will open the homepage in your default browser.

with:
```
./doxel.sh [ --inspect ]
```
* When the container exists already, it is attached (if running already) or it is restarted.
* To start with a fresh container, delete it before with eg 
```
docker rm doxel # !!!! you will lose all your modifications !!!!!
```

* When using the --inspect option, the backend is launched directly using node in a single thread, and you can click on the "Open the dedicated DevTool for Node" link displayed on chrome://inspect#devices to inspect or debug the backend code.  (You need a recent Chrome or Chromium version >= 58)

* Without the --inspect option, a backend cluster is run using slc

* When the screen session already exists only step 1 is performed

* It's easier, but you should read about Docker and understand how to use docker containers anyway
