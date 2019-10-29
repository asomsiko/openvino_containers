# OpenVINO containers

Here is a container configured to use OpenVINO with Movidius VPU.
You can build it with `./script/build.sh`.

To run `benchmark_app` on Movidius device place `FP16` model at your `$HOME`
folder and run: 

`docker run -v /home/$USER:/home/$USER -v /dev/bus/usb:/dev/bus/usb --device-cgroup-rule='c 189:* rmw' movidius benchmark_app -m /home/$USER/ResNet-50_fp16.xml -d MYRIAD`

To start interactive session run:

`docker run -v /dev/bus/usb:/dev/bus/usb --device-cgroup-rule='c 189:* rmw' -it movidius`
