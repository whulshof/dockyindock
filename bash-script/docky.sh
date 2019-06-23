#!/bin/bash
#
# Run docky in a container
#
# This script will attempt to mirror the host paths by using volumes for the
# following paths:
#   * $(pwd)
#   * $(dirname $COMPOSE_FILE) if it's set
#   * $HOME if it's set
#
#


set -e

VERSION="1.0"
IMAGE="magnuscolors/dockyindock:latest"
VD_USER="docky"
VD_SCRIPT="/opt/bin/docky"
DOCKERID=$(id -g "docker")

if [ "$USER" == "$VD_USER" ]; then
   echo "user is $VD_USER"
else 
  echo "user is NOT $VD_USER"
  if [ $(grep -c $VD_USER "/etc/passwd") -ne 0 ]; then
     echo "$VD_USER exists"
  else
     echo "$VD_USER does not exist"
     if [ $(grep -c "$VD_USER" "/etc/group") -ne 0 ]; then
        echo "$VD_USER group exists"
     else
	 echo "$VD_USER group does not exist"
      	sudo groupadd -g 1001 "$VD_USER"
     fi
     sudo useradd -u 1001 -g "$VD_USER" "$VD_USER"
     sudo passwd -d "$VD_USER"
     sudo usermod -a -G docker "$VD_USER"
     echo "user $VD_USER added as member of group $VD_USER and docker"

  fi
  echo "restarting as $VD_USER"
  exec su "$VD_USER" "$VD_SCRIPT" "$@"	
fi

# Setup options for connecting to docker host
if [ -z "$DOCKER_HOST" ]; then
    DOCKER_HOST="/var/run/docker.sock"
fi
if [ -S "$DOCKER_HOST" ]; then
    DOCKER_ADDR="-v $DOCKER_HOST:$DOCKER_HOST -e DOCKER_HOST"
else
    DOCKER_ADDR="-e DOCKER_HOST -e DOCKER_TLS_VERIFY -e DOCKER_CERT_PATH"
fi


# Setup volume mounts for compose config and context
if [ "$(pwd)" != '/' ]; then
    VOLUMES="-v $(pwd):$(pwd)"
fi

if [ -n "$HOME" ]; then
    VOLUMES="$VOLUMES -v $HOME:$HOME" # mount $HOME in $HOME[/root] to share docker.config and the docky files
fi

# Only allocate tty if we detect one
if [ -t 1 ]; then
    DOCKER_RUN_OPTIONS="-t"
fi
if [ -t 0 ]; then
    DOCKER_RUN_OPTIONS="$DOCKER_RUN_OPTIONS -i"
fi
DOCKER_RUN_OPTIONS="$DOCKER_RUN_OPTIONS -e USERID=$UID -e USERNAME=$USER -e DOCKERID=$DOCKERID"
exec docker run --rm $DOCKER_RUN_OPTIONS $DOCKER_ADDR $VOLUMES -w "$(pwd)" $IMAGE "$@"
