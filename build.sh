#!/bin/sh

#Library versions
libx265_version="3.5"
libx264_version="stable"
nvenc_version="11.1.5.1"

#Get version number
version=`cat SageTVTranscoderSettings`

if [ -z "$1" ]; then

    echo "Action was not provided and is required build.sh [build, buildall, buildlibs, rebuild] [Winx64, Winx32]"
    exit

fi

if [ $1 = "version" ]; then
	echo $version
	exit
fi

if [ $1 = "libx265_version" ]; then
	echo $libx265_version
	exit
fi

if [ $1 = "libx264_version" ]; then
	echo $libx264_version
	exit
fi

if [ $1 = "nvenc_version" ]; then
	echo $nvenc_version
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



if [ $1 = "clean" ]; then
	
    echo "Cleaning files and liraries"

    if [ -d x264 ]; then
        echo "Cleaning x264 directory"
		cd x264
		git reset --hard
		git clean -fdx
		cd ..
    fi

    if [ -d x265 ]; then
    	echo "Cleaning x265 directory"
        cd x265
		git reset --hard
		git clean -fdx
		cd ..
    fi

	if [ -d nvenc ]; then
        echo "Cleaning x264 directory"
		cd nvenc
		git reset --hard
		git clean -fdx
		cd ..
    fi

    #if [ -d output ]; then
    #        echo "Removing outout directory"
    #        rm -Rf output
    #fi

    if [ -d pkgconfig ]; then
    	echo "Removing pkgconfig directory"
       	rm -Rf pkgconfig
    fi

    rm SageTVTranscoder.log

    echo "Running ffmpeg clean"
    make clean

fi

echo "Building SageTVTranscoder version: $version"


if [ $1 = "buildlibs" ] || [ $1 = "buildall" ] || [ $1 = "buildnvenc" ]; then
	
	echo "Building NVENC"

	if [ -d nvenc ]; then
	    echo "NVENC already exists... Cleaning directory"
		cd nvenc
		git reset --hard
		git clean -fdx
		git checkout master
		git branch -D build
		echo "Checking out version: $nvenc_version"
		git checkout tags/n$nvenc_version -b build
	else
		echo "NVENC does not exist. Cloning library from videolan git"
		git clone https://github.com/FFmpeg/nv-codec-headers.git
		mv nv-codec-headers nvenc
		cd nvenc
		echo "Checking out version: $nvenc_version"
		git checkout tags/n$nvenc_version -b build
	fi

	
	echo "Running build of NVENC"
	
	make -j$(nproc)
	
	if [ $? -eq 0 ]; then
		echo "Compiliing NVENC completed: " $?
	else	
		echo "Error compiling: " $?
		exit 1
	fi
	
	echo "Installing NVENC"
	
	make install
	
	if [ $? -eq 0 ]; then
		echo "Installing NVENC completed: " $?
	else	
		echo "Error installing: " $?
		exit 1
	fi
	
	cd -

fi

#if [ $1 = "buildlibs" ] || [ $1 = "buildall" ] || [ $1 = "buildintel" ]; then
#
#    
#	echo "Building Intel Media SDK"
#
#	if [ -d MediaSDK  ]; then
#		echo "intel already exists... Cleaning directory"
#		cd MediaSDK 
#		git reset --hard
#		git clean -fdx
#		git submodule init
#
#		#echo "Checking out branch: Release_$libx265_version"
#		git checkout intel-mediasdk-22.4.3
#		git pull
#	else
#		echo "intel does not exist. Cloning library from github"
#		git clone https://github.com/Intel-Media-SDK/MediaSDK.git
#		cd MediaSDK
#		git submodule init
#		#echo "Checking out branch: Release_$libx265_version"
#		git checkout intel-mediasdk-22.4.3
#		git pull
#	fi
#
#	mkdir build
#	cd build
#
#	if [ $buildTarget = "Winx32" ]; then
#
#		echo "Configuring x265 for Windows 32bit"
#
#		cmake -DWIN32=1 \
#		-DCMAKE_SYSTEM_NAME=Windows \
#		-D CMAKE_SYSTEM_PROCESSOR="x86" \
#		-D CMAKE_RC_COMPILER="/usr/bin/i686-w64-mingw32-windres" \
#		-D CMAKE_C_COMPILER="/usr/bin/i686-w64-mingw32-gcc" \
#		-D CMAKE_CXX_COMPILER="/usr/bin/i686-w64-mingw32-g++" \
#		-D CMAKE_INSTALL_PREFIX="../pkgconfig" \
#        -D CMAKE_CXX_FLAGS="-static-libgcc -static-libstdc++" \
#		-DBUILD_STATIC_LIBS=true \
#		-DENABLE_SHARED=false ..
#
#	elif [ $buildTarget = "Winx64" ]; then
#
#		echo "Configuring Intel Media SDK for Windows 64bit"
#
#		cmake -DCMAKE_SYSTEM_NAME=Windows \
#		-D CMAKE_SYSTEM_PROCESSOR="x86_64" \
#		-D CMAKE_RC_COMPILER="/usr/bin/x86_64-w64-mingw32-windres" \
#		-D CMAKE_C_COMPILER="/usr/bin/x86_64-w64-mingw32-gcc" \
#		-D CMAKE_CXX_COMPILER="/usr/bin/x86_64-w64-mingw32-g++" \
#		-D CMAKE_INSTALL_PREFIX="../pkgconfig" \
#       -D CMAKE_CXX_FLAGS="-static-libgcc -static-libstdc++" \
#		-DCMAKE_EXE_LINKER_FLAGS="-static" \
#		-DENABLE_SHARED=OFF ..
#
#	elif [ $buildTarget = "Linux" ]; then
#
#		echo "Configuring Intel Media SDK for Linux"
#
#		cmake -DCMAKE_SYSTEM_NAME=Linux \
#		-D CMAKE_SYSTEM_PROCESSOR="x86_64" \
#		-D CMAKE_INSTALL_PREFIX="../pkgconfig" \
#		-DCMAKE_EXE_LINKER_FLAGS="-static" \
#		-DENABLE_SHARED=OFF ..
#
#	fi
#
#	echo "Running build of Intel Media SDK"
#
#	make -j$(nproc)
#	
#	if [ $? -eq 0 ]; then
#		echo "Compiliing Intel Media SDK completed: " $?
#	else	
#		echo "Error compiling: " $?
#		exit 1
#	fi
#
#	echo "Installing Intel Media SDK"
#
#	make install
#
#	if [ $? -eq 0 ]; then
#		echo "Installing Intel Media SDK completed: " $?
#	else	
#		echo "Error installing: " $?
#		exit 1
#	fi
#
#	cd -
#
#   
#
#fi


if [ $1 = "buildlibs" ] || [ $1 = "buildall" ] || [ $1 = "buildx265" ]; then

    
	echo "Building x265"

	if [ -d x265  ]; then
		echo "x265  already exists... Cleaning directory"
		cd x265 
		git reset --hard
		git clean -fdx
		echo "Checking out branch: Release_$libx265_version"
		git checkout Release_$libx265_version
	else
		echo "x265 does not exist. Cloning library from bitbucket git"
		git clone https://bitbucket.org/multicoreware/x265_git
		mv x265_git x265
		cd x265
		echo "Checking out branch: Release_$libx265_version"
		git checkout Release_$libx265_version
	fi

	if [ $buildTarget = "Winx32" ]; then

		echo "Configuring x265 for Windows 32bit"

		cmake -DWIN32=1 \
		-DCMAKE_SYSTEM_NAME=Windows \
		-D CMAKE_SYSTEM_PROCESSOR="x86" \
		-D CMAKE_RC_COMPILER="/usr/bin/i686-w64-mingw32-windres" \
		-D CMAKE_C_COMPILER="/usr/bin/i686-w64-mingw32-gcc" \
		-D CMAKE_CXX_COMPILER="/usr/bin/i686-w64-mingw32-g++" \
		-D CMAKE_INSTALL_PREFIX="../pkgconfig" \
        -D CMAKE_CXX_FLAGS="-static-libgcc -static-libstdc++" \
		-DBUILD_STATIC_LIBS=true \
		-DENABLE_SHARED=false source

	elif [ $buildTarget = "Winx64" ]; then

		echo "Configuring x265 for Windows 64bit"

		cmake -DCMAKE_SYSTEM_NAME=Windows \
		-D CMAKE_SYSTEM_PROCESSOR="x86_64" \
		-D CMAKE_RC_COMPILER="/usr/bin/x86_64-w64-mingw32-windres" \
		-D CMAKE_C_COMPILER="/usr/bin/x86_64-w64-mingw32-gcc" \
		-D CMAKE_CXX_COMPILER="/usr/bin/x86_64-w64-mingw32-g++" \
		-D CMAKE_INSTALL_PREFIX="../pkgconfig" \
        -D CMAKE_CXX_FLAGS="-static-libgcc -static-libstdc++" \
		-DCMAKE_EXE_LINKER_FLAGS="-static" \
		-DENABLE_SHARED=OFF source

	elif [ $buildTarget = "Linux" ]; then

		echo "Configuring x265 for Linux"

		cmake -DCMAKE_SYSTEM_NAME=Linux \
		-D CMAKE_SYSTEM_PROCESSOR="x86_64" \
		-D CMAKE_INSTALL_PREFIX="../pkgconfig" \
		-DCMAKE_EXE_LINKER_FLAGS="-static" \
		-DENABLE_SHARED=OFF source

	fi

	echo "Running build of x265"

	make -j$(nproc)
	
	if [ $? -eq 0 ]; then
		echo "Compiliing x265 completed: " $?
	else	
		echo "Error compiling: " $?
		exit 1
	fi

	echo "Installing x265"

	make install

	if [ $? -eq 0 ]; then
		echo "Installing x265 completed: " $?
	else	
		echo "Error installing: " $?
		exit 1
	fi

	cd -

    

fi

if [ $1 = "buildlibs" ] || [ $1 = "buildall" ] || [ $1 = "buildx264" ]; then
	
	echo "Building x264"

	if [ -d x264 ]; then
	    echo "x264 already exists... Cleaning directory"
		cd x264
		git reset --hard
		git clean -fdx
		echo "Checking out version: $libx264_version"
	else
		echo "x264 does not exist. Cloning library from videolan git"
		git clone https://code.videolan.org/videolan/x264.git
		cd x264
		echo "Checking out version: $libx264_version"
		git checkout remotes/origin/$libx264_version
	fi

	if [ $buildTarget = "Winx32" ]; then
	
		echo "Configuring x264 library for Winx32"
		
		./configure \
		--host=mingw32 \
		--cross-prefix=i686-w64-mingw32- \
		--enable-static \
		--disable-cli \
		--disable-opencl \
		--enable-pic \
		--prefix="../pkgconfig"		

		if [ $? -eq 0 ]; then
			echo "Configuring completed: " $?
		else	
			echo "Error configuring: " $?
			exit 1
		fi

	elif [ $buildTarget = "Winx64" ]; then		

		echo "Configuring x264 library for Winx64"
		
		./configure \
		--host=mingw64 \
		--cross-prefix=x86_64-w64-mingw32- \
		--enable-static \
		--disable-cli \
		--disable-opencl \
		--enable-pic \
		--prefix="../pkgconfig"		

		if [ $? -eq 0 ]; then
			echo "Configuring completed: " $?
		else	
			echo "Error configuring: " $?
			exit 1
		fi

	else
	
		echo "Configuring x264 library"
		
		./configure \
		--enable-static \
		--disable-cli \
		--disable-opencl \
		--enable-pic \
		--prefix="../pkgconfig/"
		
		if [ $? -eq 0 ]; then
			echo "Configuring completed: " $?
		else	
			echo "Error configuring: " $?
			exit 1
		fi
		
	fi

	echo "Running build of x264"
	
	make -j$(nproc)
	
	if [ $? -eq 0 ]; then
		echo "Compiliing x264 completed: " $?
	else	
		echo "Error compiling: " $?
		exit 1
	fi
	
	echo "Installing x264"
	
	make install
	
	if [ $? -eq 0 ]; then
		echo "Installing x264 completed: " $?
	else	
		echo "Error installing: " $?
		exit 1
	fi
	
	cd -

fi


if [ $1 = "build" ] || [ $1 = "buildall" ]; then

	echo "Updating ffversion.h with current build version"
	cp -rf ffversion.h.template libavutil/ffversion.h
	sed -i "s/@VERSION@/$version/g" libavutil/ffversion.h
	
	echo "Configuring build for SageTVTranscoder/FFmpeg"
	
        #export PKG_CONFIG_PATH=./pkgconfig/lib:./pkgconfig/lib/pkgconfig:/usr/local/lib/pkgconfig:/usr/local/cuda/lib64
        export PKG_CONFIG_PATH=./pkgconfig/lib:./pkgconfig/lib/pkgconfig:/usr/local/lib/pkgconfig
        echo PKG_CONFIG_PATH=$PKG_CONFIG_PATH
	
	if [ $buildTarget = "Winx32" ]; then
	
		echo "Configuring SageTVTranscoder/FFmpeg for Winx32"

		./configure \
		--arch=x86 \
		--target-os=mingw32 \
		--cross-prefix=i686-w64-mingw32- \
        --enable-nonfree \
		--enable-libx264 \
		--enable-libx265 \
        --enable-dxva2 \
        --enable-nvenc \
        --enable-cuvid \
        --enable-cuda \
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
		--extra-ldflags="-static -L./pkgconfig/lib -L./pkgconfig/lib/pkgconfig -static-libgcc -static-libstdc++ "	
	
		if [ $? -eq 0 ]; then
			echo "Configuring completed: " $?
		else	
			echo "Error configuring: " $?
			exit 1
		fi

	elif [ $buildTarget = "Winx64" ]; then
	
		echo "Configuring SageTVTranscoder/FFmpeg for Winx64"

		./configure \
		--arch=x86 \
		--target-os=mingw64 \
		--cross-prefix=x86_64-w64-mingw32- \
		--enable-libx264 \
		--enable-libx265 \
        --enable-dxva2 \
        --enable-nvenc \
        --enable-cuvid \
        --enable-cuda \
        --enable-libmfx \
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
			exit 1
		fi

	elif [ $buildTarget = "Linux" ]; then

		echo "Configuring SageTVTranscoder/FFmpeg (Linux)"
		#x265 not working.  Need to investigate further
		
		./configure \
		--enable-libx265 \
		--enable-libx264 \
        --enable-nvenc \
        --enable-cuvid \
        --enable-cuda \
		--enable-libmfx \
		--disable-ffplay \
		--disable-ffprobe \
		--enable-gpl \
		--enable-static \
		--pkg-config="pkg-config --static" \
		--disable-shared \
		--disable-devices \
		--disable-bzlib \
		--disable-demuxer=msnwc_tcp \
		--extra-libs="-lpthread -lm" \
        --ld="g++" \
		--extra-cflags="-I./pkgconfig/include -lstdc++ -lpthread" \
		--extra-ldflags="-L./pkgconfig/lib -static-libgcc -static-libstdc++"

		if [ $? -eq 0 ]; then
			echo "Configuring completed: " $?
		else	
			echo "Error configuring: " $?
			exit 1
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
	rm -R output/$buildTarget
	mkdir -p output/$buildTarget

	
    if [ $buildTarget = "Winx32" ] || [ $buildTarget = "Winx64" ]; then

        #Move and rename binary
        cp ffmpeg.exe output/$buildTarget/SageTVTranscoder.exe

        zipFileName="SageTVTranscoder${buildTarget}_v${version}.zip"
        echo "Archive name: $zipFileName"

        echo "Creating zip archive"

        cd output/$buildTarget

        #Create the zip archilve
        zip -r $zipFileName SageTVTranscoder.exe

		#I do not think I will need this anymore.  I am going to keep this
		#for potential future reusue.
        #move required dll for 32bit build.  This is a work around for now
        #if [ $buildTarget = "Winx32" ]; then
        #        cp ../../libgcc_s_dw2-1.dll.dep libgcc_s_dw2-1.dll
        #        cp ../../libwinpthread-1.dll.32.dep libwinpthread-1.dll
        #        zip -ur $zipFileName libgcc_s_dw2-1.dll
        #        zip -ur $zipFileName libwinpthread-1.dll
        #fi

        #move required dll for 32bit build.  This is a work around for now
        #if [ $buildTarget = "Winx64" ]; then
        #        cp ../../libgcc_s_seh-1.dll.dep libgcc_s_seh-1.dll
        #        cp ../../libwinpthread-1.dll.64.dep libwinpthread-1.dll
        #        zip -ur $zipFileName libgcc_s_seh-1.dll
        #        zip -ur $zipFileName libwinpthread-1.dll
        #fi

        cd ../..

        echo "Generating md5sum"
        #Create md5sum of SageTVTranscoder.exe
        md5=$( md5sum -z output/$buildTarget/$zipFileName | awk '{print $1}' )
        echo "MD5 of the SageTVTranscoder: " $md5

        #Create build date variable
        builddate=$(date '+%Y.%m.%d')
        echo "Builddate of the SageTVTranscoder: " $builddate

        echo "Generating plugin file for SageTV Repository"
        #Create file for SageTV plugin manager
        cp -rf SageTVTranscoder$buildTarget.template output/$buildTarget/SageTVTranscoder$buildTarget.xml
        sed -i "s/@MD5@/$md5/g" output/$buildTarget/SageTVTranscoder$buildTarget.xml
        sed -i "s/@BUILDDATE@/$builddate/g" output/$buildTarget/SageTVTranscoder$buildTarget.xml
        sed -i "s/@VERSION@/$version/g" output/$buildTarget/SageTVTranscoder$buildTarget.xml
        sed -i "s/@ZIPFILENAME@/$zipFileName/g" output/$buildTarget/SageTVTranscoder$buildTarget.xml
    
    else

        #Move and rename binary
        cp ffmpeg output/$buildTarget/ffmpeg

        zipFileName="SageTVTranscoder${buildTarget}_v${version}.zip"
        echo "Archive name: $zipFileName"

        echo "Creating zip archive"
        #Create the zip archilve
        cd output/$buildTarget

        zip -r $zipFileName ffmpeg

        cd ../..

        echo "Generating md5sum"
        #Create md5sum of SageTVTranscoder.exe
        md5=$( md5sum -z output/$buildTarget/$zipFileName | awk '{print $1}' )
        echo "MD5 of the SageTVTranscoder: " $md5

        #Create build date variable
        builddate=$(date '+%Y.%m.%d')
        echo "Builddate of the SageTVTranscoder: " $builddate

        echo "Generating plugin file for SageTV Repository"
        #Create file for SageTV plugin manager
        cp -rf SageTVTranscoder$buildTarget.template output/$buildTarget/SageTVTranscoder$buildTarget.xml
        sed -i "s/@MD5@/$md5/g" output/$buildTarget/SageTVTranscoder$buildTarget.xml
        sed -i "s/@BUILDDATE@/$builddate/g" output/$buildTarget/SageTVTranscoder$buildTarget.xml
        sed -i "s/@VERSION@/$version/g" output/$buildTarget/SageTVTranscoder$buildTarget.xml
        sed -i "s/@ZIPFILENAME@/$zipFileName/g" output/$buildTarget/SageTVTranscoder$buildTarget.xml

    fi

fi
