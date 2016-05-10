#!/bin/bash

XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.$$.xauth
XPORT=":$( echo ${DISPLAY} | cut -d':' -f2 )"

#
# create a new magic cookie for the container to access host's X
#
xauth nlist ${XPORT} | sed -e 's/^..../ffff/' | xauth -f ${XAUTH} nmerge - > /dev/null 2>&1

docker run --rm=true                            \
            -it                                 \
            -e DISPLAY=${DISPLAY}               \
            -e XAUTHORITY=${XAUTH}              \
            -v ${XSOCK}:${XSOCK}                \
            -v ${XAUTH}:${XAUTH}                \
            -P                                  \
            shifter-xclock:0.1
