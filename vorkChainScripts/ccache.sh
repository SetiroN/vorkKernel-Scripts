#!/bin/bash

export buildprefix=$HOME/linaro-toolchain
ccachev=3.1.7

if [ ! -d $buildprefix/ccache ]; then
	mkdir $buildprefix/ccache; fi
if [ ! -d $buildprefix/ccache/ccache-$ccachev ]; then
	echo Downloading ccache...
	cd $buildprefix/ccache
	wget http://samba.org/ftp/ccache/ccache-$ccachev.tar.bz2
	tar -xvjf ccache-$ccachev.tar.bz2
fi

cd $buildprefix/ccache/ccache-$ccachev
echo Configuring ccache...
./configure
make -j`grep "processor" /proc/cpuinfo | wc -l`
sudo make install -j`grep "processor" /proc/cpuinfo | wc -l`

touch $HOME/vorkKernel-Scripts/vorkKernelScripts/Tools/ccache.txt
echo > $HOME/vorkKernel-Scripts/vorkKernelScripts/Tools/ccache.txt
cd $HOME/vorkKernel-Scripts/ 
