#!/bin/bash

readarray -t array <<<"$@"

echo $result

printf "\n"

echo ${array[1]}

printf "\nUnbinding\n"

unset array[-1]
for device in "$@"; do
    IFS="," read -r -a newArray <<<"$device"

    BIND_BDF=$(echo ${newArray[0]} | xargs)
    DRIVER_NAME="${newArray[1]}"
    dpath="/sys/bus/pci/devices/$BIND_BDF"

    echo $BIND_BDF
    echo $DRIVER_NAME

    echo $DRIVER_NAME >$dpath/driver_override

    echo $BIND_BDF >$dpath/driver/unbind

    echo $BIND_BDF >/sys/bus/pci/drivers_probe

done
