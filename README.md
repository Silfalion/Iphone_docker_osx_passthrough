# Iphone docker osx usb passthrough

**IMPORTANT** The vfio binding script and the one creating through docker osx both need to be run as sudo.

The scripts in here allows one to passthrough a usb controller consequently an iphone to a VM created through Docker OSX, this should work but was tested with other OSs.

This isn't something new either, the main thing that can be labelled as "different" is the unbinding script that makes it seamless to bind, start your vm, work then once its closed your usb controller(possibly iphone) will be automatically(through the unbinding script) unbinded.

In case you don't want to use the unbind right away, the binding script returns at the end of its execution the instructions to run in order to unbind the controller passed(and the devices in the same iommu_group that had to be binded to).

# CREDIT

- https://github.com/foxlet/vmra1n/edit/master/README.md
- https://github.com/andre-richter/vfio-pci-bind

# Steps

We first need to make sure our OS can passthrough to a guest:

## Enable BIOS Features (Credit foxlet, vmra1n repo)
Boot into your firmware settings, and turn on AMD-V/VT-x, as well as iommu (also called AMD-Vi, VT-d, or SR-IOV).

## Enable Kernel Features(Credit foxlet, vmra1n repo)
The `iommu` kernel module is not enabled by default, but you can enable it on boot by passing the following flags to the kernel.

### AMD
```
iommu=pt amd_iommu=on
```

### Intel
```
iommu=pt intel_iommu=on
```

To do this permanently, you can add it to your bootloader. If you're using GRUB, for example, edit `/etc/default/grub` and add the previous lines to the `GRUB_CMDLINE_LINUX_DEFAULT` section, then run `sudo update-grub` (or `sudo grub-mkconfig` on some systems) and reboot.

## <a name="getting_usb_controller"></a> Getting the usb controller ID


Now that we know we can passthrough devices to the VM, we need to choose/get a usb controller to passthrough, run:

`lspci | grep USB`

This will return  the PCI devices with a USB in their name, these are usb controllers.

Make sure none of these are connected to usb devices you need, pick one and note down the first digists of its line, the format is `XX:XX.X`.

## Option 1: Binding and Passthrough

### **Binding**
Connect your device and run the following:

```sudo vfio-bind.sh 0000:XX:XX.X```

Replace the Xs part with the number you noted earlier.

### **Actual Passthrough**

Make sure your docker command start with sudo and add this line to it:

```
-e EXTRA="-device pcie-root-port,bus=pcie.0,multifunction=on,port=1,chassis=1,id=port.1 -device vfio-pci,host=$BIND_PID,bus=port.1" \
```

You can now start/create your container and your iphone/usb device should show up 🎉.

## Unbinding
To bind, the most straightforward approach is to copy paste into a terminal the lines outputed by the `vfio-bind.sh` script. 

They will be listed after the following text:

```
-----------------IMPORTANT-----------------"
to unbind run the following lines:

```

## Option 2: All ready script

if you want to avoid a lot of hassle for your passthrough you can change the details of your docker VM in `docker_osx_script.sh` and then run:

```
sudo ./workingMacosVm_without_image.sh 0000:XX:XX.X
```

Where XX:XX.X is the number you noted in the [Getting usb controller Id section](#getting_usb_controller).

And that's all, your VM should start normally after that and your iphone/usb device detected with trouble