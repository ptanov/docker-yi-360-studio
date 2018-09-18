# docker-yi-360-studio
This is docker image for running *YI 360 VR Camera - Desktop Software* (*YI 360 Studio*) on linux machine.

Main executable is downloaded from: https://www.yitechnology.com/yi-360-vr-camera-desktopsoftware (see `Dockerfile`)

Current version is:
```
YI 360 VR Camera-Desktop Software
Product Name：YI360 Studio

Compatible Environments：Windows 7 64-bit system and above

Version：1.0.3.0

Release notes：
1.Supported stabilization video stitching
2.Optimized other functions
3.Bug fix
```

# Use
 - for the first time - you must follow the installation wizard and select the default location (C:\Program Files\YI 360 Studio) and **UNCHECK** *"Run YI 360 Studio 1.0.3.0"* checkbox in the last screen. Then press Finish and *YI 360 Studio* will start:
 - `docker run -it -e DISPLAY -v ~/.Xauthority:/root/.Xauthority -v /tmp/.X11-unix/:/tmp/.X11-unix/ -v /dev/dri/:/dev/dri/ --device=/dev/snd -v $(pwd):/yi --name=yi-360-studio ptanov/yi-360-studio`
 - you can access your host's current directory from the container using `/yi` (because of `-v $(pwd):/yi` - you can change to whatever works for you)
 - if something fails or if you want to run *YI 360 Studio* again - type:
 - `docker start yi-360-studio && docker logs -f yi-360-studio`
 - Keep in mind that drag-and-drop will not work if the host's directory is not mounted on the same path (mount, `-v` argument) in the container.

# Build
 - `docker build -t ptanov/yi-360-studio .`

# Contributions
 - thanks to https://github.com/shangmu/docker.wine for the Dockerfile snippet for running the application as a regular user
