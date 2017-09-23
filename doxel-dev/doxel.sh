#!/bin/bash
#
# doxel.sh - Start or restart the doxel container in a screen session.
#            Open a shell as root and as user doxel.
#            Open the homepage in the default browser.
#
# Author(s):
#
#      Luc Deschenaux <luc.deschenaux@freesurf.ch>
#
# This file is part of the DOXEL project <http://doxel.org>.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Additional Terms:
#
#      You are required to preserve legal notices and author attributions in
#      that material or in the Appropriate Legal Notices displayed by works
#      containing it.
#
#      You are required to attribute the work as explained in the "Usage and
#      Attribution" section of <http://doxel.org/license>.
#/

set -e
set -x

PORT=3001
NAME=doxel
IMAGE=doxel/dev:latest
SRCDIR=/home/doxel/doxel-loopback

usage() {
  cat << EOF
  $(basename $0) [-h|--help] [-i|--inspect]
EOF
  exit 1
}

while [ $# -gt 0 ] ; do
  case "$1" in
    --inspect) INSPECT=true shift ;;
    --help|-h) usage ;;
    *) usage
  esac
done

progress() {
  echo "=== $@" >&2
}

error() {
  echo "*** $@" >&2
}

container() {
  docker ps $1 -q --no-trunc --filter name=^/$NAME$
}

if [[ "$TERM" =~ ^screen ]] ; then
  error Cannot run from inside a screen session
  exit 1
fi

# check for screen session
if screen -S $NAME -X vbell on > /dev/null ; then
  progress WARNING: reusing existion screen session, you should get rid of it first.
  SCREEN_EXISTS=yes
fi

# check for running container

if [ -n "$(container)" ] ; then

  progress WARNING: container is already running

  if [ -n "$SCREEN_EXISTS" ] ; then
    progress Trying to resume screen session
    sleep 3
    screen -S $NAME -rd -p0
    error Screen exited with status $?
    exit

  else
    progress Starting a new screen session
    progress Attaching to existing container
    screen -S $NAME -dm bash -l -c "\
      docker attach $NAME ;\
      exec bash \
    "
  fi

else
  if [ -n "$SCREEN_EXISTS" ] ; then
    progress Use existing screen session
    OPTIONS="-x -X screen"
  else 

    progress Starting a new screen session
    OPTIONS="-dm"
  fi

  if [ -n "$(container -a)" ] ; then
    progress Restarting existing container
    screen -S $NAME $OPTIONS bash -l -c "\
      docker start -ai $NAME ; \
      exec bash \
    " || exit
  
  else
    if [ -n "$INSPECT" ] ; then
      progress Starting a new container with inspector enabled
      screen -S $NAME $OPTIONS bash -l -c "\
        docker run \
           --name $NAME \
           -it \
           --mount source=doxel-loopback,destination=$SRCDIR \
           -p 3001:$PORT \
           -p 9229:9229 \
           $IMAGE /root/debug.sh ; \
        \
        exec bash \
      " || exit

    else
      progress Starting a new container
      screen -S $NAME $OPTIONS bash -l -c "\
        docker run \
          --name $NAME \
           --mount source=doxel-loopback,destination=$SRCDIR \
          -it \
          -p 3001:$PORT \
          $IMAGE ; \
        \
        exec bash \
      " || exit
    fi
  fi
fi

if [ -z "$SCREEN_EXISTS" ] ; then

  # start a root shell
  CMD="docker exec -itu root $NAME /bin/bash"
  screen -S $NAME -x -X screen bash -l -c "\
    echo === waiting for container $NAME
    while [ -z \"\$(docker ps -q --no-trunc --filter name=\^/$NAME$)\" ] ; do
      sleep 3 ; \
    done ; \
    echo $CMD ; \
    $CMD ;\
    exec bash \
  "

  # start a doxel shell
  CMD="docker exec -itu doxel $NAME /bin/bash"
  screen -S $NAME -x -X screen bash -l -c "\
    echo === waiting for container $NAME
    while [ -z \"\$(docker ps -q --no-trunc --filter name=\^/$NAME$)\" ] ; do
      sleep 3 ; \
    done ; \
    echo $CMD ; \
    $CMD ; \
    exec bash \
  "

  # open in browser
  screen -S $NAME -x -X screen bash -l -c "\
    echo === Waiting for server ;\
    while ! wget -q --spider http://127.0.0.1:$PORT/app/index.html; do \
      sleep 1 ;\
    done ;\
    xdg-open http://127.0.0.1:$PORT/app/ ;\
    exec bash \
  "

fi

# attach to screen session
sleep 3
screen -S $NAME -p0 -rd 
