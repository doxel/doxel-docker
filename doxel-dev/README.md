## DOXEL-DEV ##

Docker container to develop and test [doxel.org](https://www.doxel.org) [backend](https://github.com/doxel/doxel-loopback) and [frontend](https://github.com/doxel/doxel-angular)

## BUILD THE CONTAINER ##

For example with:

```
make
```

or

```
DEBIAN_MIRROR=ftp.ch.debian.org NVM_VERSION=v0.33.0 NODE_VERSION=v6.9.4 make
```

## RUN THE CONTAINER ##

Use ```bin/doxel-container```:
```
NAME
      doxel-container

SYNOPSIS
      doxel-container [-h|--help] [-i|--inspect]

DESCRIPTION
      Start, attach to, or restart the doxel docker container.

      * When the container does not exists it is started (the --inspect option
      is not effective in other cases below)
      * When the container is running already it is attached.
      * When the container exists already it is restarted.

      To start with a fresh container, delete it before with eg:
            `docker rm doxel`

      The first time the container is started with this script, a docker
      volume named 'doxel-loopback' is created and populated with the
      content of the project directory located in '/home/doxel/doxel-loopback'
      then mounted over it.

      This volume is exposed on the host filesystem at:
       `/var/lib/docker/volumes/doxel-loopback/_data`

      This is the same volume that the 'doxel-atom' script will use for
      editing purposes.

      To start with a fresh volume, AND DISCARD ALL YOUR MODIFICATIONS TO THE
      SOURCE CODE, delete the volume with:
            `docker volume rm doxel-loopback`

      -i|--inspect
               Run a single nodejs thread and start the chrome inspector.

               Then you can click on the "Open the dedicated DevTool for Node"
               link displayed on chrome://inspect#devices to debug the backend
               (You need a recent Chrome or Chromium version >= 58)

               Without this option, a backend cluster is run using slc.
               Specifying/omitting this option when the container is already
               running has no effect.

```

## CONNECT WITH YOUR BROWSER ##

For example with:


```
./bin/doxel-browser
```

or

```
xdg-open http://127.0.0.1:3001/app/
```

## OPEN A SHELL ##

For example with:

```
./bin/doxel-shell -u doxel
```

or

```
docker exec -itu root doxel /bin/bash
```

## ALL IN ONE ##
For example with gnu-screen:
```
screen -S doxel -dm doxel-container -i
screen -S doxel -dmx -X screen doxel-watch
screen -S doxel -dmx -X screen doxel-shell -u doxel
screen -S doxel -dmx -X screen doxel-browser
screen -S doxel -rdp0
```

## EDIT THE SOURCE CODE ##

When applicable, you can either edit files directly in '/var/lib/docker/volumes/doxel-loopback/_data' or using 'bindfs' to map the file owner.
Or you have to use the 'docker-atom' script (or take a leaf out of it to build a docker container for your favourite IDE that will mount the doxel-loopback docker volume).

To use the doxel-atom script you need to build the [docker-atom](https://github.com/doxel/docker-atom-editor) docker container beforehand.
Then you can open the project in atom using:
```
./bin/doxel-atom
```

You may also want to run 'grunt watch' in the doxel-loopback/client directory of the doxel-container, to rebuild index.html, css files and other stuff automatically and enable livereload as configured in the Gruntfile.js

You can do this with:
```
./bin/doxel-watch
```
To work with the un-minimized scripts and css/html files, you must set cookie debug=true in your browser.

You can rebuild the minimized scripts and css/html with 'grunt build' or
```
./bin/doxel-build
```

After modifying the API (common/models), you must rebuild the angular services with ``lb-ng server/server.js client/app/lb-services.js``` in the container doxel-loopback directory or with:
```
./bin/doxel-lbng
```

Then you must restart the server, eg with ```slc ctl restart doxel-loopback``` or by removing and restarting the doxel container.
