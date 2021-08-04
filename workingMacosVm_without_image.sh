#!/bin/bash

source vfio-bind.sh $@
rtnval=$?
if [[ $rtnval -eq 1 ]]; then
    exit 1
fi

export result=$DRIVER_DATA

printf "\n"

var=$(docker ps -aq --filter "name=iphoneDockerOSX")

containerName=iphoneDockerOSX

printf "Getting pci slot"

readarray -t array <<<"$result"

IFS="," read -r -a newArray <<<"${array[0]}"

BIND_PID="${newArray[0]/0000:/}"



if [ -z "$var" ]
then
    echo "iphoneDockerOSX contianer not found, creating a new one."
    ./docker_osx_script

else
    echo "Prexisting contianer found."
    echo "Starting container."

    docker start -ai $containerName
fi

while [ "$(docker container inspect -f '{{.State.Running}}' $containerName)" == "true" ]; do
    sleep 5
done

./unbind.sh $result

