FROM debian:buster-slim


RUN apt-get update

# Install Build Essentials
RUN apt-get install build-essential -y

#MinGW for cross compiling
RUN apt-get install gcc-mingw-w64-i686 -y


CMD ["/bin/bash"]
