## BUILD THE CONTAINER ##

For example with:

```
DEBIAN_MIRROR=ftp.ch.debian.org NVM_VERSION=v0.33.0 NODE_VERSION=v6.9.4 build.sh 
```

## RUN THE CONTAINER ##

For example with:
```
docker run -itp 3001:3001 doxel/dev:latest
```

## CONNECT WITH YOUR BROWSER ##

For example with:
```
xdg-open http://127.0.0.1:3001
```

## OPEN A SHELL ##

For example with:

```
docker exec -itu root $(docker ps -a -q | head -n 1) /bin/bash
```

