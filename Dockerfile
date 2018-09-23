FROM ubuntu:18.04

RUN mkdir -p /dist
WORKDIR /dist
RUN dpkg --add-architecture i386
RUN apt update
RUN apt-get install -y gnupg2 gnupg1 cabextract wget software-properties-common
RUN wget -nc https://dl.winehq.org/wine-builds/Release.key
RUN apt-key add Release.key
RUN apt-add-repository https://dl.winehq.org/wine-builds/ubuntu/
RUN apt update
RUN apt-get -y install --install-recommends winehq-devel
RUN wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
RUN chmod +x winetricks
RUN wget http://cdn.awssgp0.fds.api.mi-img.com/sportscamera/sportssns/resource/20180105023853/1/YI360Installer1.0.3.0.exe

# Changes based on https://github.com/shangmu/docker.wine
# Without them (on Ubuntu 18.04) we will need to allow root@localhost to access X (xhost +SI:localuser:root) - this generally is not a good idea!
# btw vlc does not like running as root too (and will not run under root)

# Replace 1000 with your user / group id on your host system
RUN useradd -u 1000 -d /home/developer -m -s /bin/bash developer
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    mkdir -p /etc/sudoers.d && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer

USER developer
ENV HOME /home/developer
# "sleep 5" fixes various problems, including %ProgramFiles% not staying and failing to create window in "&& xvfb-run ..."
RUN winecfg && wine cmd.exe /c echo '%ProgramFiles%' && sleep 5

WORKDIR /yi

CMD if [ ! -f ~/.wine/drive_c/Program\ Files/YI\ 360\ Studio/YI\ 360\ Studio.exe ]; then /dist/winetricks -q vcrun2015; wine64 /dist/YI360Installer1.0.3.0.exe; fi; wine64 ~/.wine/drive_c/Program\ Files/YI\ 360\ Studio/YI\ 360\ Studio.exe

