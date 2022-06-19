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
RUN apt-get install nasm -y
RUN apt-get install zlib1g-dev -y
RUN apt-get install zip -y

#MinGW for cross compiling
RUN apt-get install mingw-w64 -y
#RUN apt-get install g++-mingw-w64-i686 -y

#These are for CUDA library install
#RUN apt-get install software-properties-common
#RUN wget https://developer.download.nvidia.com/compute/cuda/repos/debian10/x86_64/cuda-keyring_1.0-1_all.deb
#RUN sudo dpkg -i cuda-keyring_1.0-1_all.deb
#RUN add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/debian10/x86_64/ /"
#RUN add-apt-repository contrib
#RUN apt update
#RUN apt install cuda -y

CMD ["/bin/bash"]
