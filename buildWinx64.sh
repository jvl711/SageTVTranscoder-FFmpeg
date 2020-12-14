#!/bin/sh

#These are what I beleive are the package requirements
#pacman -S zip

#Get version number
version=$( < SageTVTranscoder.version)
echo "Building and packaging SageTVTranscoder version: $version"

make -f Makefile -j3

#Remove and create the directory to generate all of the output files
rm -R output
mkdir -p output

#Move and rename binary
cp ffmpeg.exe output/SageTVTranscoder.exe

#Create the zip archilve
cd output
zip -r SageTVTranscoderWin64_v$version.zip SageTVTranscoder.exe
cd ..

#Create md5sum of SageTVTranscoder.exe
md5=$( md5sum -z output/SageTVTranscoderWin64_v$version.zip | awk '{print $1}' )
echo "MD5 of the SageTVTranscoder: " $md5

#Create build date variable
builddate=$(date '+%Y.%m.%d')
echo "Builddate of the SageTVTranscoder: " $builddate

#Create file for SageTV plugin manager
cp -rf SageTVTranscoderWinx64.template output/SageTVTranscoderWinx64.xml
sed -i "s/@MD5@/$md5/g" output/SageTVTranscoderWinx64.xml
sed -i "s/@BUILDDATE@/$builddate/g" output/SageTVTranscoderWinx64.xml
sed -i "s/@VERSION@/$version/g" output/SageTVTranscoderWinx64.xml