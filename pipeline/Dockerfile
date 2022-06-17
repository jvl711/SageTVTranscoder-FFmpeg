FROM debian:buster-slim


RUN apt-get update

# Install dependencies
RUN apt-get install build-essential -y
RUN apt-get install autoconf -y
RUN apt-get install automake -y
RUN apt-get install cmake -y
RUN apt-get install git-core -y
RUN apt-get install libass-dev -y
RUN apt-get install libfreetype6-dev -y
RUN apt-get install libgnutls28-dev -y
RUN apt-get install libmp3lame-dev -y
RUN apt-get install libsdl2-dev -y
RUN apt-get install libtool -y
RUN apt-get install libva-dev -y
RUN apt-get install libvdpau-dev -y
RUN apt-get install libvorbis-dev -y
RUN apt-get install libxcb1-dev -y
RUN apt-get install libxcb-shm0-dev -y
RUN apt-get install libxcb-xfixes0-dev -y
RUN apt-get install meson -y
RUN apt-get install ninja-build -y
RUN apt-get install pkg-config -y
RUN apt-get install texinfo -y
RUN apt-get install wget -y
RUN apt-get install yasm -y
#RUN apt-get install nasm -y
RUN apt-get install zlib1g-dev -y

#MinGW for cross compiling
RUN apt-get install mingw-w64 -y
#RUN apt-get install g++-mingw-w64-i686 -y

CMD ["/bin/bash"]
