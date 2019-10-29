# OpenVINO containers

Here is a container configured to use OpenVINO with Movidius VPU.

Prepare your application at `/home` folder and run:

```
./script/build.sh && \
docker run -v /home:/home -v /dev/bus/usb:/dev/bus/usb --device-cgroup-rule='c 189:* rmw' -it movidius
```
