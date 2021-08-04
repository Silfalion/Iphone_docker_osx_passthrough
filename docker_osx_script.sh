sudo docker run -it \
        --privileged \
        --device /dev/kvm \
        --ulimit memlock=-1:-1 \
        --name $containerName \
        -p 50922:10022 \
        -v "${PWD}/output.env:/env" \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -e "DISPLAY=${DISPLAY:-:0.0}" \
        -e SMP=4 \
        -e CORES=2 \
        -e RAM=2 \
        -e GENERATE_UNIQUE=true \
        -e GENERATE_SPECIFIC=true \
        -e WIDTH=1600 \
        -e HEIGHT=900 \
        -e EXTRA="-device pcie-root-port,bus=pcie.0,multifunction=on,port=1,chassis=1,id=port.1 
        -device vfio-pci,host=$BIND_PID,bus=port.1" \
        sickcodes/docker-osx:auto
