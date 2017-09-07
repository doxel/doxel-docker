#!/bin/bash
PORT=3001
NAME=doxel
IMAGE=doxel/dev:latest
if [ "$1" = "--inspect" ] ; then
  INSPECT=true
fi

set +x
# check for screen session
if screen -S $NAME -X vbell on > /dev/null ; then
  echo WARNING: reusing existion screen session
  SCREEN_EXISTS=yes
fi

# check for running container
CONTAINER=$(docker ps -q --no-trunc --filter name=^/$NAME$)

if [ -n "$CONTAINER" ] ; then

  echo WARNING: container is already running

  if [ -n "$SCREEN_EXISTS" ] ; then
    echo Trying to resume screen session
    screen -S $NAME -rd
    echo screen exited with status $?
    exit

  else
    echo Starting a new screen session
    echo Attaching to existing container
    screen -S $NAME -dm bash -l -c "docker attach $NAME ; exec bash" || exit
  fi

else
 
  # check for exited container 
  CONTAINER=$(docker ps -aq --no-trunc --filter name=^/$NAME$)
 
  if [ -n "$SCREEN_EXISTS" ] ; then
    echo Use existing screen session
    OPTIONS="-x -X screen"
  else 

    echo Starting a new screen session
    OPTIONS="-dm"
  fi

  if [ -n "$CONTAINER" ] ; then
    echo Restarting existing container
    screen -S $NAME $OPTIONS bash -l -c "docker start -ai $NAME ; exec bash" || exit
  
  else
    echo Starting a new container 
    if [ -n "$INSPECT" ] ; then
      screen -S $NAME $OPTIONS bash -l -c "docker run --name $NAME -itp 3001:$PORT -p 9229:9229 $IMAGE /root/debug.sh ; exec bash" || exit
    else
      screen -S $NAME $OPTIONS bash -l -c "docker run --name $NAME -itp 3001:$PORT $IMAGE ; exec bash" || exit
    fi

  fi


fi


if [ -z "$SCREEN_EXISTS" ] ; then
  # start a root shell
  screen -S $NAME -x -X screen bash -l -c "docker exec -itu root $NAME /bin/bash ; exec bash"
  # start a doxel shell
  screen -S $NAME -x -X screen bash -l -c "docker exec -itu doxel $NAME /bin/bash ; exec bash"
  # open in browser
  screen -S $NAME -x -X screen bash -l -c "while ! wget --spider http://127.0.0.1:$PORT/app/index.html; do sleep 1 ; done ; xdg-open http://127.0.0.1:$PORT/app/ ; exec bash"
fi

# attach to screen session
screen -S $NAME -p0 -rd 
