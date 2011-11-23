#!/bin/bash
# Static variables
storage_dir="$HOME/Optimus_Speed"
source_dir="$HOME"
script_dir="$source_dir/vorkKernel-Scripts/vorkKernelScripts"
start_dir="`pwd`"
cores="`grep processor /proc/cpuinfo | wc -l`"
now="`date +"%Y%m%d"h"%H%M"`"

# Functions
function die () { echo $@; exit 1; }

# Device variables
devices="LGP990 XOOM DESIRE"

# Device specific functions
function LGP990() { toolchain="$HOME/vorkChain/toolchain/bin/arm-eabi-"; ramhack32=1; ramhack96=1; ramhack0=1; }
function XOOM() { toolchain="$HOME/vorkChain/toolchain/bin/arm-eabi-"; epeen=0; }
function DESIRE() { toolchain="$HOME/vorkChain/msmqsd/toolchain/bin/arm-eabi-"; epeen=0; }
function LGP990_zip() {
	case $1 in
		"do")   
			cp $script_dir/mdfiles/update-binary $script_dir/Awesome.zip/META-INF/com/google/android/
			cp $script_dir/mdfiles/unpackbootimg $script_dir/Awesome.zip/tmp/vorkKernel/
			cp $script_dir/mdfiles/mkbootimg $script_dir/Awesome.zip/tmp/vorkKernel/
			cp $script_dir/mdfiles/busybox $script_dir/Awesome.zip/tmp/vorkKernel/
			cp -r $script_dir/mdfiles/ril $script_dir/Awesome.zip/tmp/vorkKernel/files
		;;
		"clean")
			rm $script_dir/Awesome.zip/META-INF/com/google/android/update-binary
			rm $script_dir/Awesome.zip/tmp/vorkKernel/unpackbootimg
			rm $script_dir/Awesome.zip/tmp/vorkKernel/mkbootimg
			rm $script_dir/Awesome.zip/tmp/vorkKernel/busybox
			rm -r $script_dir/Awesome.zip/tmp/vorkKernel/files/ril
		;;
	esac
}
function XOOM_zip() {
	case $1 in
		"do")   
			cp $script_dir/mdfiles/update-binary $script_dir/Awesome.zip/META-INF/com/google/android/
			cp $script_dir/mdfiles/unpackbootimg $script_dir/Awesome.zip/tmp/vorkKernel/
			cp $script_dir/mdfiles/mkbootimg $script_dir/Awesome.zip/tmp/vorkKernel/
			cp $script_dir/mdfiles/busybox $script_dir/Awesome.zip/tmp/vorkKernel/
			cp $script_dir/mdfiles/media_profiles.xml $script_dir/Awesome.zip/tmp/vorkKernel/files/
		;;
		"clean")
			rm $script_dir/Awesome.zip/META-INF/com/google/android/update-binary
			rm $script_dir/Awesome.zip/tmp/vorkKernel/unpackbootimg
			rm $script_dir/Awesome.zip/tmp/vorkKernel/mkbootimg
			rm $script_dir/Awesome.zip/tmp/vorkKernel/busybox
			rm $script_dir/Awesome.zip/tmp/vorkKernel/files/media_profiles.xml
		;;
	esac
}
function DESIRE_zip() {
	case $1 in
		"do")
			cp $script_dir/mdfiles/updater-desire $script_dir/Awesome.zip/META-INF/com/google/android/update-binary
			cp $script_dir/mdfiles/dump_image $script_dir/Awesome.zip/tmp/vorkKernel/dump_image
			cp $script_dir/mdfiles/flash_image $script_dir/Awesome.zip/tmp/vorkKernel/flash_image
			cp $script_dir/mdfiles/unpackbootimg-desire $script_dir/Awesome.zip/tmp/vorkKernel/unpackbootimg
			cp $script_dir/mdfiles/mkbootimg-desire $script_dir/Awesome.zip/tmp/vorkKernel/mkbootimg
			cp $script_dir/mdfiles/busybox-desire $script_dir/Awesome.zip/tmp/vorkKernel/busybox
			cp $script_dir/mdfiles/initbravo.awk $script_dir/Awesome.zip/tmp/vorkKernel/awk/initbravo.awk
		;;
		"clean")
			rm $script_dir/Awesome.zip/META-INF/com/google/android/update-binary
			rm $script_dir/Awesome.zip/tmp/vorkKernel/unpackbootimg
			rm $script_dir/Awesome.zip/tmp/vorkKernel/mkbootimg
			rm $script_dir/Awesome.zip/tmp/vorkKernel/busybox
			rm $script_dir/Awesome.zip/tmp/vorkKernel/dump_image
			rm $script_dir/Awesome.zip/tmp/vorkKernel/flash_image
			rm $script_dir/Awesome.zip/tmp/vorkKernel/awk/initbravo.awk
		;;
	esac
}

function LGP990_ramhack32() {
	case $1 in
		"do")   
			sed -i 's/#define RAMHACK64/#define RAMHACK32/g' $source_dir/lge-kernel-star/include/linux/vorkKernel.h
			sed -i 's/#define BOOT_CMDLINE 		"mem=447M@0M nvmem=64M@448M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"/#define BOOT_CMDLINE 		"mem=415M@0M nvmem=96M@416M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"/g' $script_dir/mdfiles/installkernel.pre.sh
		;;
		"clean")
			sed -i 's/#define RAMHACK32/#define RAMHACK64/g' $source_dir/lge-kernel-star/include/linux/vorkKernel.h
			sed -i 's/#define BOOT_CMDLINE 		"mem=415M@0M nvmem=96M@416M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"/#define BOOT_CMDLINE 		"mem=447M@0M nvmem=64M@448M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"/g' $script_dir/mdfiles/installkernel.pre.sh
		;;
	esac
}

function LGP990_ramhack96() {
	case $1 in
		"do")   
			sed -i 's/#define RAMHACK64/#define RAMHACK96/g' $source_dir/lge-kernel-star/include/linux/vorkKernel.h
			sed -i 's/#define BOOT_CMDLINE 		"mem=447M@0M nvmem=64M@448M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"/#define BOOT_CMDLINE 		"mem=479M@0M nvmem=32M@480M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"/g' $script_dir/mdfiles/installkernel.pre.sh
		;;
		"clean")
			sed -i 's/#define RAMHACK96/#define RAMHACK64/g' $source_dir/lge-kernel-star/include/linux/vorkKernel.h
			sed -i 's/#define BOOT_CMDLINE 		"mem=479M@0M nvmem=32M@480M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"/#define BOOT_CMDLINE 		"mem=447M@0M nvmem=64M@448M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"/g' $script_dir/mdfiles/installkernel.pre.sh
		;;
	esac
}

function LGP990_ramhack0() {
	case $1 in
		"do")   
			sed -i 's/#define RAMHACK64/#define RAMHACK0/g' $source_dir/lge-kernel-star/include/linux/vorkKernel.h
			sed -i 's/#define BOOT_CMDLINE 		"mem=447M@0M nvmem=64M@448M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"/#define BOOT_CMDLINE 		"mem=383M@0M nvmem=128M@384M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"/g' $script_dir/mdfiles/installkernel.pre.sh
		;;
		"clean")
			sed -i 's/#define RAMHACK0/#define RAMHACK64/g' $source_dir/lge-kernel-star/include/linux/vorkKernel.h
			sed -i 's/#define BOOT_CMDLINE 		"mem=383M@0M nvmem=128M@384M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"/#define BOOT_CMDLINE 		"mem=447M@0M nvmem=64M@448M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"/g' $script_dir/mdfiles/installkernel.pre.sh
		;;
	esac
}

# Cleanup
release=
build_device=

if [ $# -gt 0 ]; then
	input=$1
else
	i=1
	for device in $devices; do
		echo "$i) $device Release"
		i=$(($i+1))
		echo "$i) $device Test"
		i=$(($i+1))
	done
	echo "Choose a device:"
	read input
fi

i=1
for device in $devices; do
	if [ "$input" == $i ]; then # This is a release build
		release="release"
		build_device=$device
		break
	fi
	i=$(($i+1))
	
	if [ "$input" == $i ]; then # This is a test build
		release="test"
		build_device=$device
		break
	fi
	i=$(($i+1))
done

if [ "$release" == "" -o "$device" == "" ]; then # No device has been chosen
	die "ERROR: Please choose a device"
fi

echo "Setting up a $build_device $release build"
$build_device
if [ "`which ccache`" != "" -a "$USE_CCACHE" == "1" ]; then # We have ccache and want to use it
	toolchain="ccache $toolchain"
fi

if [ "$release" == "release" ]; then
	zip_location=$storage_dir/ironkrnL/RELEASE/ironkrnL64-$now.zip
	if [ "$ramhack32" == "1" ]; then
		ramhack32_zip_location=$storage_dir/ironkrnL/RELEASE/ironkrnL32-$now.zip
	fi
	if [ "$ramhack96" == "1" ]; then
		ramhack96_zip_location=$storage_dir/ironkrnL/RELEASE/ironkrnL96-$now.zip
	fi
	if [ "$ramhack0" == "1" ]; then
		ramhack0_zip_location=$storage_dir/ironkrnL/RELEASE/ironkrnL00-$now.zip
	fi
elif [ "$release" == "test" ]; then
	zip_location=$storage_dir/ironkrnL/TEST/ironkrnL64-$now.zip
	if [ "$ramhack32" == "1" ]; then
		ramhack32_zip_location=$storage_dir/ironkrnL/TEST/ironkrnL32-$now.zip
	fi
	if [ "$ramhack96" == "1" ]; then
		ramhack96_zip_location=$storage_dir/ironkrnL/TEST/ironkrnL96-$now.zip
	fi
	if [ "$ramhack0" == "1" ]; then
		ramhack0_zip_location=$storage_dir/ironkrnL/TEST/ironkrnL00-$now.zip
	fi
fi

if [ ! -d $source_dir/lge-kernel-star ]; then
	die "Could not find kernel source for $build_device"
fi

echo "Setting up kernel..."
make -BC $source_dir/lge-kernel-star ARCH=arm CROSS_COMPILE="$toolchain" setiron_defconfig
if [ "$?" != "0" ]; then
	die "Error setting up kernel"
fi

echo "Building kernel..."
make -BC $source_dir/lge-kernel-star ARCH=arm CROSS_COMPILE="$toolchain" -j$cores
if [ "$?" != "0" ]; then
	die "Error building kernel"
fi

echo "Grabbing zImage..."
cp $source_dir/lge-kernel-star/arch/arm/boot/zImage $script_dir/Awesome.zip/tmp/vorkKernel/zImage

echo "Grabbing kernel modules..."
if [ ! -d $script_dir/Awesome.zip/tmp/vorkKernel/files/lib/modules/ ]; then
    mkdir -p $script_dir/Awesome.zip/tmp/vorkKernel/files/lib/modules/
fi
rm $script_dir/Awesome.zip/tmp/vorkKernel/files/lib/modules/*

for module in `find $source_dir/lge-kernel-star -name *.ko`
do
    cp $module $script_dir/Awesome.zip/tmp/vorkKernel/files/lib/modules/
done

echo "Making update zip..."
echo "#!/sbin/sh" > $script_dir/Awesome.zip/tmp/vorkKernel/installkernel.sh
cpp -D DEVICE_$build_device $script_dir/mdfiles/installkernel.pre.sh | awk '/# / { next; } { print; }' >> $script_dir/Awesome.zip/tmp/vorkKernel/installkernel.sh
"$build_device"_zip do
cd $script_dir/Awesome.zip/
zip -qr $zip_location *
cd -
"$build_device"_zip clean

if [ "$ramhack32" == "1" ]; then
	"$build_device"_ramhack32 do
	echo "Setting up kernel..."
	rm ~/lge-kernel-star/arch/arm/mach-tegra/board-nvodm.o
	rm ~/lge-kernel-star/arch/arm/mach-tegra/odm_kit/star/query/nvodm_query.o
	make -C $source_dir/lge-kernel-star ARCH=arm CROSS_COMPILE="$toolchain" setiron_defconfig
	if [ "$?" != "0" ]; then
		die "Error setting up kernel"
	fi

	echo "Building kernel..."
	make -C $source_dir/lge-kernel-star ARCH=arm CROSS_COMPILE="$toolchain" -j$cores
	if [ "$?" != "0" ]; then
		die "Error building kernel"
	fi

	echo "Grabbing zImage..."
	cp $source_dir/lge-kernel-star/arch/arm/boot/zImage $script_dir/Awesome.zip/tmp/vorkKernel/zImage

	echo "Grabbing kernel modules..."
    if [ ! -d $script_dir/Awesome.zip/tmp/vorkKernel/files/lib/modules/ ]; then
        mkdir -p $script_dir/Awesome.zip/tmp/vorkKernel/files/lib/modules/
    fi
    rm $script_dir/Awesome.zip/tmp/vorkKernel/files/lib/modules/*

	for module in `find $source_dir/lge-kernel-star -name *.ko`
	do
		cp $module $script_dir/Awesome.zip/tmp/vorkKernel/files/lib/modules/
	done
	
	echo "Making update zip..."
	echo "#!/sbin/sh" > $script_dir/Awesome.zip/tmp/vorkKernel/installkernel.sh
	cpp -D DEVICE_$build_device $script_dir/mdfiles/installkernel.pre.sh | awk '/# / { next; } { print; }' >> $script_dir/Awesome.zip/tmp/vorkKernel/installkernel.sh
	"$build_device"_zip do
	cd $script_dir/Awesome.zip/
	zip -qr $ramhack32_zip_location *
	cd -
	"$build_device"_zip clean
	"$build_device"_ramhack32 clean
fi

if [ "$ramhack96" == "1" ]; then
	"$build_device"_ramhack96 do
	echo "Setting up kernel..."
	rm ~/lge-kernel-star/arch/arm/mach-tegra/board-nvodm.o
	rm ~/lge-kernel-star/arch/arm/mach-tegra/odm_kit/star/query/nvodm_query.o
	make -C $source_dir/lge-kernel-star ARCH=arm CROSS_COMPILE="$toolchain" setiron_defconfig
	if [ "$?" != "0" ]; then
		die "Error setting up kernel"
	fi

	echo "Building kernel..."
	make -C $source_dir/lge-kernel-star ARCH=arm CROSS_COMPILE="$toolchain" -j$cores
	if [ "$?" != "0" ]; then
		die "Error building kernel"
	fi

	echo "Grabbing zImage..."
	cp $source_dir/lge-kernel-star/arch/arm/boot/zImage $script_dir/Awesome.zip/tmp/vorkKernel/zImage

	echo "Grabbing kernel modules..."
    if [ ! -d $script_dir/Awesome.zip/tmp/vorkKernel/files/lib/modules/ ]; then
        mkdir -p $script_dir/Awesome.zip/tmp/vorkKernel/files/lib/modules/
    fi
    rm $script_dir/Awesome.zip/tmp/vorkKernel/files/lib/modules/*

	for module in `find $source_dir/lge-kernel-star -name *.ko`
	do
		cp $module $script_dir/Awesome.zip/tmp/vorkKernel/files/lib/modules/
	done
	
	echo "Making update zip..."
	echo "#!/sbin/sh" > $script_dir/Awesome.zip/tmp/vorkKernel/installkernel.sh
	cpp -D DEVICE_$build_device $script_dir/mdfiles/installkernel.pre.sh | awk '/# / { next; } { print; }' >> $script_dir/Awesome.zip/tmp/vorkKernel/installkernel.sh
	"$build_device"_zip do
	cd $script_dir/Awesome.zip/
	zip -qr $ramhack96_zip_location *
	cd -
	"$build_device"_zip clean
	"$build_device"_ramhack96 clean
fi

if [ "$ramhack0" == "1" ]; then
	"$build_device"_ramhack0 do
	echo "Setting up kernel..."
	rm ~/lge-kernel-star/arch/arm/mach-tegra/board-nvodm.o
	rm ~/lge-kernel-star/arch/arm/mach-tegra/odm_kit/star/query/nvodm_query.o
	make -C $source_dir/lge-kernel-star ARCH=arm CROSS_COMPILE="$toolchain" setiron_defconfig
	if [ "$?" != "0" ]; then
		die "Error setting up kernel"
	fi

	echo "Building kernel..."
	make -C $source_dir/lge-kernel-star ARCH=arm CROSS_COMPILE="$toolchain" -j$cores
	if [ "$?" != "0" ]; then
		die "Error building kernel"
	fi

	echo "Grabbing zImage..."
	cp $source_dir/lge-kernel-star/arch/arm/boot/zImage $script_dir/Awesome.zip/tmp/vorkKernel/zImage

	echo "Grabbing kernel modules..."
    if [ ! -d $script_dir/Awesome.zip/tmp/vorkKernel/files/lib/modules/ ]; then
        mkdir -p $script_dir/Awesome.zip/tmp/vorkKernel/files/lib/modules/
    fi
    rm $script_dir/Awesome.zip/tmp/vorkKernel/files/lib/modules/*

	for module in `find $source_dir/lge-kernel-star -name *.ko`
	do
		cp $module $script_dir/Awesome.zip/tmp/vorkKernel/files/lib/modules/
	done
	
	echo "Making update zip..."
	echo "#!/sbin/sh" > $script_dir/Awesome.zip/tmp/vorkKernel/installkernel.sh
	cpp -D DEVICE_$build_device $script_dir/mdfiles/installkernel.pre.sh | awk '/# / { next; } { print; }' >> $script_dir/Awesome.zip/tmp/vorkKernel/installkernel.sh
	"$build_device"_zip do
	cd $script_dir/Awesome.zip/
	zip -qr $ramhack0_zip_location *
	cd -
	"$build_device"_zip clean
	"$build_device"_ramhack0 clean
fi

if [ "$release" == "release" ]; then # Stuff for update app
	echo "Saving release information..."
	echo $now > $storage_dir/UpdateApp/version_$build_device
	
	echo "Updating Twitter..."
	python /opt/vorkBot/vorkbot.py $device
fi
