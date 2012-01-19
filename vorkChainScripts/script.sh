#!/bin/bash

target=arm-linux-androideabi
gcc=4.6
gcclv=$gcc-2012.01
binv=2.21.1
mpcv=0.9
newlibv=1.20.0
cloogv=0.16.3
gdblv=7.3-2011.10
gmpv=5.0.2
mpfrv=3.0.1

export buildprefix=$HOME/linaro-toolchain
export prefix=$HOME/linaro-toolchain/built

if [ ! -d ~/bin ]; then
	echo Installing repo...
	mkdir ~/bin
	PATH=~/bin:$PATH
	curl https://dl-ssl.google.com/dl/googlesource/git-repo/repo > ~/bin/repo
	chmod a+x ~/bin/repo
fi
if [ ! -d $buildprefix ]; then
	echo Initializing linaro repository...
	mkdir -p $buildprefix
	repo init -b linaro-master -u git://android.git.linaro.org/toolchain/manifest.git
fi
cd $buildprefix
echo Syncronizing linaro repository...
repo sync

if [ -d $prefix/bin ]; then
   read -p "Toolchain already compiled. Do you want to recompile? (y/n) " CHOICE
   if [ ! $CHOICE == "y" ]; then exit 0; fi
fi

if [ ! -d $buildprefix/gcc/gcc-linaro-$gcclv ]; then
    echo Downloading gcc-linaro...
    cd $buildprefix/gcc/
    rm gcc-linaro-*.tar.bz2 &>/dev/null
    wget http://launchpad.net/gcc-linaro/$gcc/$gcclv/+download/gcc-linaro-$gcclv.tar.bz2 || die "Unable to download GCC!"

    echo Extracting gcc-linaro...
    tar -xvjf gcc-linaro-$gcclv.tar.bz2
fi

cd $buildprefix/build
echo Configuring gcc...
bash $buildprefix/build/gcc-linaro-$gcclv/configure --target=$target --with-binutils-version=$binv --with-newlib-version=$newlibv --with-mpc-version=$mpcv --with-gcc-version=linaro-$gcclv --with-cloog-version=$cloogv --with-gdb-version=linaro-$gdblv --with-gmp-version=$gmpv --with-mpfr-version=$mpfrv --with-pkgversion=linar_roN-$gcclv

PATH=$prefix/bin:$PATH
export PATH

cd $buildprefix/build
echo Building gcc...
bash $buildprefix/build/gcc-linaro-$gcclv/linaro-build.sh --with-gcc=gcc-linaro-$gcclv --apply-gcc-patch=yes
echo Complete?!

read -p "Execute ccache install script? (y/n) " CHOICE
if [ ! $CHOICE == "y" ]; then exit 0; fi
bash $buildprefix/
