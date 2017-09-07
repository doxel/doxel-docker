## BUILD THE CONTAINER ##

For example with:

```
DEBIAN_MIRROR=ftp.ch.debian.org NVM_VERSION=v0.33.0 NODE_VERSION=v6.9.4 build.sh 

## RUN THE CONTAINER ##

For example with:
```
docker run --name doxel -itp 3001:3001 doxel/dev:latest

This will start a server cluster using slc.
```

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

Start (or reattach to) a screen session with (initially) 4 windows:
1. Launch/attach-to/restart the container
2. Run a shell as root user in the container
3. Run a shell as doxel user in the container
4. Open the browser

with:
```
./run.sh [ --inspect ]
`
* Without the --inspect option, a backend cluster is run using slc.

* When using the --inspect version, the backend is launched directly using node in a single thread, and you can click on the "Open the dedicated DevTool for Node" link displayed on chrome://inspect#devices to inspect or debug the backend code.  (You need a recent Chrome or Chromium version >= 58)
