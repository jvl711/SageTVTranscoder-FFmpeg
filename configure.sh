#!/bin/sh

#pacman -S cmake
#pacman -S msys/make
#pacman -S msys/autoconf
#pacman -S msys/automake1.15
#pacman -S msys/automake-wrapper
#pacman -S msys/libtool
#pacman -S mingw32/mingw-w64-i686-gcc
#pacman -S mingw64/mingw-w64-x86_64-gcc
#pacman -S mingw32/mingw-w64-i686-yasm
#pacman -S mingw64/mingw-w64-x86_64-yasm
#pacman -S mingw32/mingw-w64-i686-freetype
#pacman -S mingw64/mingw-w64-x86_64-freetype
#pacman -S mingw32/mingw-w64-i686-harfbuzz
#pacman -S mingw64/mingw-w64-x86_64-harfbuzz
#pacman -S mingw32/mingw-w64-i686-libpng 
#pacman -S mingw64/mingw-w64-x86_64-libpng
#pacman -S mingw32/mingw-w64-i686-graphite2
#pacman -S mingw64/mingw-w64-x86_64-graphite2
#pacman -S mingw32/mingw-w64-i686-zlib
#pacman -S mingw64/mingw-w64-x86_64-zlib
#pacman -S mingw64/nasm
#pacman -S mingw64/git
#pacman -S mingw-w64-x86_64-libc++

#rm -R x264

#if [[ -d x264 ]]; then
#    echo "x264 exists"
#else
#	echo "x264 does not exist. Cloning library from videolan git"
#	git clone https://code.videolan.org/videolan/x264.git
#	git checkout stable 
#fi

#cd x264

#./configure --enable-static --disable-cli --disable-opencl --enable-pic --prefix="x264"

#make -j$(nproc)
#make install 

#cd -

#rm x265 -R -f

#if [[ -d x265 ]]; then
#	echo 'x265 exists'
#else
#	git clone https://github.com/videolan/x265.git
#fi

#cd x265/build/linux
#git checkout stable

#git pull

#/c/Users/jvl711.CORE/Documents/code/FFmpeg/x265/build
#SET(CMAKE_C_COMPILER x86_64-w64-mingw32-gcc)
#SET(CMAKE_CXX_COMPILER x86_64-w64-mingw32-g++)

#rm CMakeCache.txt
#rm -Rf CMakeFiles/
#rm CopyOfCMakeCache.txt
#rm  Makefile
#rm -Rf cmake/
#rm cmake_install.cmake
#rm -Rf common/
#rm -Rf encoder/
#rm libx265.a
#rm libx265.so
#rm x265.def
#rm x265.exe
#rm x265.pc
#rm x265_config.h


#cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="../../../pkgconfig" \
#-DENABLE_SHARED=OFF -DCMAKE_EXE_LINKER_FLAGS="-static" -DCMAKE_CXX_COMPILER=g++ ../../source \

#make -j$(nproc)
#make install
#cd -


#cd ffmpeg
#CFLAGS=-I../pkgconfig/include
#LDFLAGS=-L../pkgconfig/lib
#export LD_LIBRARY_PATH=./pkgconfig/lib:./pkgconfig/lib/include
export PKG_CONFIG_PATH=./pkgconfig/lib/pkgconfig 
#export PKG_CONFIG_LIBDIR=./pkgconfig/lib/include
./configure --disable-ffplay --disable-ffprobe --pkg-config-flags='--static' --enable-gpl --enable-static --disable-shared --disable-devices --disable-bzlib --disable-demuxer=msnwc_tcp --enable-libx264 "--extra-cflags=-static -I./pkgconfig/include" "--extra-ldflags=-static -L./pkgconfig/lib"

#make clean
#make -j$(nproc)


#--enable-libx264 --disable-ffplay --disable-ffprobe --enable-gpl --enable-static --disable-shared --disable-devices --disable-bzlib --disable-demuxer=msnwc_tcp "--extra-cflags=-static" "--extra-ldflags=-static"
