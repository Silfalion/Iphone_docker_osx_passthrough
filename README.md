# Iphone_docker_osx_passthrough
The scripts in here allows one to passthrough a usb controller consequently an iphone to a VM created through Docker OSX, this should work but was tested with other OSs.

This isn't something new either, the main thing that can be labelled as "different" is the unbinding script that makes it seamless to bind, start your vm, work then once its closed your usb controller(possibly iphone) will be automatically(through the unbinding script) unbinded.

In case you don't want to use the unbind right away, the binding script returns at the end of its execution the instructions to run in order to unbind the controller passed(and the devices in the same iommu_group that had to be binded to).
