#!/bin/sh

#Install prereqs to build linux variant
#sudo apt-get update -qq && sudo apt-get -y install \
#  autoconf \
#  automake \
#  build-essential \
#  cmake \
#  git-core \
#  libass-dev \
#  libfreetype6-dev \
#  libgnutls28-dev \
#  libsdl2-dev \
#  libtool \
#  libva-dev \
#  libvdpau-dev \
#  libvorbis-dev \
#  libxcb1-dev \
#  libxcb-shm0-dev \
#  libxcb-xfixes0-dev \
#  meson \
#  ninja-build \
#  pkg-config \
#  texinfo \
#  wget \
#  yasm \
#  zlib1g-dev \
#  zip
#
# Maybe: sudo apt-get install libnuma-dev


#These are what I believe are the package requirements
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



#Get version number
#version=$(<SageTVTranscoderSettings)
version=`cat SageTVTranscoderSettings`
echo "Building SageTVTranscoder version: $version"

#Cross compiler gcc-mingw-w64-i686, sudo apt-get install mingw-w64-tools

    #export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:./pkgconfig/lib/pkgconfig:./pkgconfig/lib:/usr/local/lib/pkgconfig
    #echo PKG_CONFIG_PATH=$PKG_CONFIG_PATH

	#echo "Updating ffversion.h with current build version"
	#cp -rf ffversion.h.template libavutil/ffversion.h
	#sed -i "s/@VERSION@/$version/g" libavutil/ffversion.h

	#./configure --arch=x86 --target-os=mingw32 --cross-prefix=i686-w64-mingw32-
	#./configure --disable-ffplay --disable-ffprobe --pkg-config-flags='--static' --enable-gpl --enable-static --disable-shared --disable-devices --disable-bzlib --disable-demuxer=msnwc_tcp --arch=x86 --target-os=mingw32 --cross-prefix=i686-w64-mingw32- "--extra-cflags=-static -I./pkgconfig/include -lstdc++ -lpthread" "--extra-ldflags=-static -L./pkgconfig/lib -static-libgcc -static-libstdc++"
	#make

    #exit

if [ -z "$1" ]; then

    echo "Action was not provided and is required build.sh [build, buildall, buildlibs, rebuild] [Winx64, Winx32]"
    exit

fi

if [ -z "$2" ]; then

    echo "Building target was not provided"
    buildTarget="Winx64"

else

    if [ $2 = "Winx64" ]; then

            buildTarget="Winx64"

    elif [ $2 = "Winx32" ]; then

            buildTarget="Winx32"

    elif [ $2 = "Linux" ]; then

            buildTarget="Linux"

    else

            buildTarget="Winx64"

    fi

fi

echo "Setting build target to: " $buildTarget

if [ $1 = "clean" ]; then
	
    echo "Cleaning files and liraries"

    if [ -d x264 ]; then
            echo "Removing x264 directory"
            rm -Rf x264
    fi

    if [ -d x265 ]; then
            echo "Removing x265 directory"
            rm -Rf x265
    fi

    if [ -d output ]; then
            echo "Removing outout directory"
            rm -Rf output
    fi

    if [ -d pkgconfig ]; then
            echo "Removing pkgconfig directory"
            rm -Rf pkgconfig
    fi

    rm SageTVTranscoder.log

    echo "Running ffmpeg clean"
    make clean

fi

if [ $1 = "buildlibs" ] || [ $1 = "buildall" ] || [ $1 = "buildx265" ]; then

    if [ $buildTarget = "Winx32" ] || [ $buildTarget = "Winx64" ]; then

	    echo "Building x265"

			if [ -d x265  ]; then
			echo "x265  already exists..."
			cd x265 
			git reset --hard
			git checkout Release_3.4
			else
			echo "x265 does not exist. Cloning library from videolan git"
			#git clone https://github.com/videolan/x265.git
			git clone https://bitbucket.org/multicoreware/x265_git
			mv x265_git x265
			cd x265
			git checkout Release_3.5
			fi

			cmake -DWIN32=1 \
			-DCMAKE_SYSTEM_NAME=Windows \
			-D CMAKE_SYSTEM_PROCESSOR="x86" \
			-D CMAKE_RC_COMPILER="/usr/bin/i686-w64-mingw32-windres" \
			-D CMAKE_C_COMPILER="/usr/bin/i686-w64-mingw32-gcc" \
			-D CMAKE_CXX_COMPILER="/usr/bin/i686-w64-mingw32-g++" \
			-D CMAKE_INSTALL_PREFIX="../pkgconfig" \
			-DCMAKE_EXE_LINKER_FLAGS="-static" \
		    -DENABLE_SHARED=OFF source

			echo "Running build of x265"

			make -j$(nproc)
			
			if [ $? -eq 0 ]; then
				echo "Compiliing x265 completed: " $?
			else	
				echo "Error compiling: " $?
				exit
			fi

			echo "Installing x265"

			make install

			if [ $? -eq 0 ]; then
			echo "Installing x265 completed: " $?
			else	
			echo "Error installing: " $?
			exit
			fi

	    cd -

    fi

fi

if [ $1 = "buildlibs" ] || [ $1 = "buildall" ] || [ $1 = "buildx264" ]; then
	
	echo "Building x264"

	if [ -d x264 ]; then
	    echo "x264 already exists..."
		cd x264
		git reset --hard
		git checkout remotes/origin/stable
	else
		echo "x264 does not exist. Cloning library from videolan git"
		git clone https://code.videolan.org/videolan/x264.git
		cd x264
		git checkout remotes/origin/stable
	fi

	if [ $buildTarget = "Winx32" ]; then
	
		echo "Configuring x264 library for Winx32"
		
		#./configure --host=mingw32 --enable-static --disable-cli --disable-opencl --enable-pic --prefix="../pkgconfig"
		#--arch=x86 --target-os=mingw32 --cross-prefix=i686-w64-mingw32-
		./configure --host=mingw32 --cross-prefix=i686-w64-mingw32- --enable-static --disable-cli --disable-opencl --enable-pic --prefix="../pkgconfig"		

		if [ $? -eq 0 ]; then
			echo "Configuring completed: " $?
		else	
			echo "Error configuring: " $?
			exit
		fi
		
	else
	
		echo "Configuring x264 library"
		./configure --enable-static --disable-cli --disable-opencl --enable-pic --prefix="../pkgconfig/"
		
		if [ $? -eq 0 ]; then
			echo "Configuring completed: " $?
		else	
			echo "Error configuring: " $?
			exit
		fi
		
	fi

	echo "Running build of x264"
	
	make -j$(nproc)
	
	if [ $? -eq 0 ]; then
		echo "Compiliing x264 completed: " $?
	else	
		echo "Error compiling: " $?
		exit
	fi
	
	echo "Installing x264"
	
	make install
	
	if [ $? -eq 0 ]; then
		echo "Installing x264 completed: " $?
	else	
		echo "Error installing: " $?
		exit
	fi
	
	cd -

fi


if [ $1 = "build" ] || [ $1 = "buildall" ]; then

	echo "Updating ffversion.h with current build version"
	cp -rf ffversion.h.template libavutil/ffversion.h
	sed -i "s/@VERSION@/$version/g" libavutil/ffversion.h
	
	echo "Configuring build for SageTVTranscoder/FFmpeg"
	
        export PKG_CONFIG_PATH=./pkgconfig/lib:./pkgconfig/lib/pkgconfig
        echo PKG_CONFIG_PATH=$PKG_CONFIG_PATH
	
        #export PKG_CONFIG_PATH=$./pkgconfig/lib/pkgconfig


	if [ $buildTarget = "Winx32" ]; then
	
		echo "Configuring SageTVTranscoder/FFmpeg for Winx32"

		./configure \
		--arch=x86 \
		--target-os=mingw32 \
		--cross-prefix=i686-w64-mingw32- \
		--enable-libx265 \
		--enable-libx264 \
		--disable-ffplay \
		--disable-ffprobe \
		--enable-gpl \
		--enable-static \
		--pkg-config="pkg-config --static" \
		--disable-shared \
		--disable-devices \
		--disable-bzlib \
		--disable-demuxer=msnwc_tcp \
		--extra-cflags="-static -I./pkgconfig/include -lstdc++ -lpthread" \
		--extra-ldflags="-static -L./pkgconfig/lib -static-libgcc -static-libstdc++"

		if [ $? -eq 0 ]; then
			echo "Configuring completed: " $?
		else	
			echo "Error configuring: " $?
			exit
		fi

	elif [ $buildTarget = "Linux" ]; then

		echo "Configuring SageTVTranscoder/FFmpeg (Linux)"
		#x265 not working.  Need to investigate further
		./configure --enable-libx264 --disable-ffplay --disable-ffprobe --prefix="./pkgconfig" --pkgconfigdir='./pkgconfig/lib/pkgconfig' --pkg-config-flags='--static' --enable-gpl --enable-static --disable-shared --disable-devices --disable-bzlib --disable-demuxer=msnwc_tcp --extra-libs="-lpthread -lm" --ld="g++" --enable-nonfree "--extra-cflags=-static -I./pkgconfig/include" "--extra-ldflags=-static -L./pkgconfig/lib"
		
		if [ $? -eq 0 ]; then
			echo "Configuring completed: " $?
		else	
			echo "Error configuring: " $?
			exit
		fi
		
	else
	
		echo "Configuring SageTVTranscoder/FFmpeg (Winx64)"
		./configure --enable-libx264 --enable-libx265 --disable-ffplay --disable-ffprobe --pkg-config-flags='--static' --enable-gpl --enable-static --disable-shared --disable-devices --disable-bzlib --disable-demuxer=msnwc_tcp "--extra-cflags=-static -I./pkgconfig/include" "--extra-ldflags=-static -L./pkgconfig/lib"
		
		if [ $? -eq 0 ]; then
			echo "Configuring completed: " $?
		else	
			echo "Error configuring: " $?
			exit
		fi
	
	fi
	
	
fi

if [ $1 = "build" ] || [ $1 = "buildall" ] || [ $1 = "rebuild" ]; then

    echo "Running build SageTVTranscoder/FFmpeg"

    make -j$(nproc)

    if [ $? -eq 0 ]; then
            echo "Compiliing SageTVTranscoder/FFmpeg completed: " $?
    else	
            echo "Error compiling: " $?
            exit
    fi

fi

if [ $1 = "build" ] || [ $1 = "buildall" ] || [ $1 = "package" ] || [ $1 = "rebuild" ]; then

	#Remove and create the directory to generate all of the output files
	echo "Removing output directory"
	rm -R output
	mkdir -p output

	
        if [ $buildTarget = "Winx32" ] || [ $buildTarget = "Winx64" ]; then

            #Move and rename binary
            cp ffmpeg.exe output/SageTVTranscoder.exe

            zipFileName="SageTVTranscoder${buildTarget}_v${version}.zip"
            echo "Archive name: $zipFileName"

            echo "Creating zip archive"
            #Create the zip archilve
            cd output

            zip -r $zipFileName SageTVTranscoder.exe

            #move required dll for 32bit build.  This is a work around for now
            if [ $buildTarget = "Winx32" ]; then
                    cp ../libgcc_s_dw2-1.dll.dep libgcc_s_dw2-1.dll
                    cp ../libwinpthread-1.dll.32.dep libwinpthread-1.dll
                    zip -ur $zipFileName libgcc_s_dw2-1.dll
                    zip -ur $zipFileName libwinpthread-1.dll
            fi

            #move required dll for 32bit build.  This is a work around for now
            if [ $buildTarget = "Winx64" ]; then
                    cp ../libgcc_s_seh-1.dll.dep libgcc_s_seh-1.dll
                    cp ../libwinpthread-1.dll.64.dep libwinpthread-1.dll
                    zip -ur $zipFileName libgcc_s_seh-1.dll
                    zip -ur $zipFileName libwinpthread-1.dll
            fi

            cd ..

            echo "Generating md5sum"
            #Create md5sum of SageTVTranscoder.exe
            md5=$( md5sum -z output/$zipFileName | awk '{print $1}' )
            echo "MD5 of the SageTVTranscoder: " $md5

            #Create build date variable
            builddate=$(date '+%Y.%m.%d')
            echo "Builddate of the SageTVTranscoder: " $builddate

            echo "Generating plugin file for SageTV Repository"
            #Create file for SageTV plugin manager
            cp -rf SageTVTranscoder$buildTarget.template output/SageTVTranscoder$buildTarget.xml
            sed -i "s/@MD5@/$md5/g" output/SageTVTranscoder$buildTarget.xml
            sed -i "s/@BUILDDATE@/$builddate/g" output/SageTVTranscoder$buildTarget.xml
            sed -i "s/@VERSION@/$version/g" output/SageTVTranscoder$buildTarget.xml
            sed -i "s/@ZIPFILENAME@/$zipFileName/g" output/SageTVTranscoder$buildTarget.xml
        
        else

            #Move and rename binary
            cp ffmpeg output/ffmpeg

            zipFileName="SageTVTranscoder${buildTarget}_v${version}.zip"
            echo "Archive name: $zipFileName"

            echo "Creating zip archive"
            #Create the zip archilve
            cd output

            zip -r $zipFileName ffmpeg

            cd ..

            echo "Generating md5sum"
            #Create md5sum of SageTVTranscoder.exe
            md5=$( md5sum -z output/$zipFileName | awk '{print $1}' )
            echo "MD5 of the SageTVTranscoder: " $md5

            #Create build date variable
            builddate=$(date '+%Y.%m.%d')
            echo "Builddate of the SageTVTranscoder: " $builddate

            echo "Generating plugin file for SageTV Repository"
            #Create file for SageTV plugin manager
            cp -rf SageTVTranscoder$buildTarget.template output/SageTVTranscoder$buildTarget.xml
            sed -i "s/@MD5@/$md5/g" output/SageTVTranscoder$buildTarget.xml
            sed -i "s/@BUILDDATE@/$builddate/g" output/SageTVTranscoder$buildTarget.xml
            sed -i "s/@VERSION@/$version/g" output/SageTVTranscoder$buildTarget.xml
            sed -i "s/@ZIPFILENAME@/$zipFileName/g" output/SageTVTranscoder$buildTarget.xml

        fi

fi

#rm -R x264

#if [[ -d x264 ]]; then
#    echo "x264 exists"
#else
#	echo "x264 does not exist. Cloning library from videolan git"
#	git clone https://code.videolan.org/videolan/x264.git
#	git checkout stable 
#git checkout  remotes/origin/stable
#fi

#cd x264

#./configure --enable-static --disable-cli --disable-opencl --enable-pic --prefix="../pkgconfig/"

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
#export PKG_CONFIG_PATH=./pkgconfig/lib/pkgconfig 
#export PKG_CONFIG_LIBDIR=./pkgconfig/lib/include
#./configure --disable-ffplay --disable-ffprobe --pkg-config-flags='--static' --enable-gpl --enable-static --disable-shared --disable-devices --disable-bzlib --disable-demuxer=msnwc_tcp --enable-libx264 "--extra-cflags=-static -I./pkgconfig/include" "--extra-ldflags=-static -L./pkgconfig/lib"

#make clean
#make -j$(nproc)


#--enable-libx264 --disable-ffplay --disable-ffprobe --enable-gpl --enable-static --disable-shared --disable-devices --disable-bzlib --disable-demuxer=msnwc_tcp "--extra-cflags=-static" "--extra-ldflags=-static"
