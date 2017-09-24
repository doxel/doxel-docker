## DOXEL-DEV ##

Docker container to develop and test [doxel.org](https://www.doxel.org) [backend](https://github.com/doxel/doxel-loopback) and [frontend](https://github.com/doxel/doxel-angular)

## BUILD THE CONTAINER ##

For example with:

```
./build.sh
```

or

```
DEBIAN_MIRROR=ftp.ch.debian.org NVM_VERSION=v0.33.0 NODE_VERSION=v6.9.4 build.sh 
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

      When the container does not exists it is started (the --inspect option
      is not effective in other cases below)
      When the container is running already it is attached.
      When the container exists already it is restarted.

      To start with a fresh container, delete it before with eg:
            `docker rm doxel`

      When the local docker volume \'doxel-loopback\' does not exists (eg: the
      first time the container is started with this script), it is created and
      populated with the content of the project directory located in
      '/home/doxel/doxel-loopback', then mounted over it.

      To start with a fresh volume, AND DISCARD ALL YOUR MODIFICATIONS TO THE
      SOURCE CODE, delete the volume with eg:
            `docker volume rm doxel-loopback`


      This is the same volume that the 'doxel-atom' container will use.

      When using the --inspect option, the backend is launched directly using
      nodejs, in a single thread (with node inspector enabled).
      Then you can click on the "Open the dedicated DevTool for Node" link
      displayed on chrome://inspect#devices to inspect or debug the backend
      code. (You need a recent Chrome or Chromium version >= 58)

      -i|--inspect
               Run a single nodejs thread and start the chrome inspector.
               With this option, a backend cluster is run using slc.
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

## EDIT THE SOURCE CODE ##

After running the container and opening the homepage with your browser, you may want test some changes or debug something.

You need to build the doxel-atom docker container beforehand.
Then you can open the project in atom using:
```
./bin/doxel-atom
```

It will allow you to edit (with the doxel-atom docker container), the content of the doxel-loopback docker volume (used by the doxel container)

You may also want to run 'grunt watch' in the doxel-loopback/client directory of the doxel-container, to rebuild index.html, css files and other stuff automatically as configured in the Gruntfile.js

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

Then you must restart the server, eg with ```slc ctl restart doxel-loopback```

