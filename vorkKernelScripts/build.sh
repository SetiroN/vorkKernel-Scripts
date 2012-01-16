#!/bin/bash
# Static variables
storage_dir="$HOME/Optimus_Speed"
source_dir="$HOME"
script_dir="$source_dir/vorkKernel-Scripts/vorkKernelScripts"
start_dir="`pwd`"
cores="`grep processor /proc/cpuinfo | wc -l`"
now="`date +"%Y%m%d"h"%H%M"`"
build_device="LGP990"

# Functions
function die () { echo $@; exit 1; }

# Device specific functions
function LGP990() { toolchain="$HOME/vorkChain/toolchain/bin/arm-eabi-"; ramhack112=1; ramhack104=1; ramhack96=1; ramhack80=0; ramhack48=0; ramhack32=1; ramhack0=0; }
function LGP990_zip() {
	case $1 in
		"do")   
			cp $script_dir/mdfiles/update-binary $script_dir/Awesome.zip/META-INF/com/google/android/
			cp $script_dir/mdfiles/unpackbootimg $script_dir/Awesome.zip/tmp/ironkrnL/
			cp $script_dir/mdfiles/mkbootimg $script_dir/Awesome.zip/tmp/ironkrnL/
			cp $script_dir/mdfiles/busybox $script_dir/Awesome.zip/tmp/ironkrnL/
		;;
		"clean")
			rm $script_dir/Awesome.zip/META-INF/com/google/android/update-binary
			rm $script_dir/Awesome.zip/tmp/ironkrnL/unpackbootimg
			rm $script_dir/Awesome.zip/tmp/ironkrnL/mkbootimg
			rm $script_dir/Awesome.zip/tmp/ironkrnL/busybox
		;;
	esac
}

function LGP990_ramhack112() {
	case $1 in
		"do")   
			sed -i 's/#define IRON_AVP_FREQ 240000/#define IRON_AVP_FREQ 280000/g' $source_dir/lge-kernel-star/include/linux/ironkrnl.h
			sed -i 's/#define RAMHACK64/#define RAMHACK112/g' $source_dir/lge-kernel-star/include/linux/ironkrnl.h
			sed -i 's/#define BOOT_CMDLINE 		"mem=447M@0M nvmem=64M@448M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"/#define BOOT_CMDLINE 		"mem=495M@0M nvmem=16M@496M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"/g' $script_dir/mdfiles/installkernel.pre.sh
		;;
		"clean")
			sed -i 's/#define IRON_AVP_FREQ 280000/#define IRON_AVP_FREQ 240000/g' $source_dir/lge-kernel-star/include/linux/ironkrnl.h
			sed -i 's/#define RAMHACK112/#define RAMHACK64/g' $source_dir/lge-kernel-star/include/linux/ironkrnl.h
			sed -i 's/#define BOOT_CMDLINE 		"mem=495M@0M nvmem=16M@496M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"/#define BOOT_CMDLINE 		"mem=447M@0M nvmem=64M@448M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"/g' $script_dir/mdfiles/installkernel.pre.sh
		;;
	esac
}

function LGP990_ramhack104() {
	case $1 in
		"do")   
			sed -i 's/#define IRON_AVP_FREQ 240000/#define IRON_AVP_FREQ 280000/g' $source_dir/lge-kernel-star/include/linux/ironkrnl.h
			sed -i 's/#define RAMHACK64/#define RAMHACK104/g' $source_dir/lge-kernel-star/include/linux/ironkrnl.h
			sed -i 's/#define BOOT_CMDLINE 		"mem=447M@0M nvmem=64M@448M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"/#define BOOT_CMDLINE 		"mem=487M@0M nvmem=24M@488M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"/g' $script_dir/mdfiles/installkernel.pre.sh
		;;
		"clean")
			sed -i 's/#define IRON_AVP_FREQ 280000/#define IRON_AVP_FREQ 240000/g' $source_dir/lge-kernel-star/include/linux/ironkrnl.h
			sed -i 's/#define RAMHACK104/#define RAMHACK64/g' $source_dir/lge-kernel-star/include/linux/ironkrnl.h
			sed -i 's/#define BOOT_CMDLINE 		"mem=487M@0M nvmem=24M@488M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"/#define BOOT_CMDLINE 		"mem=447M@0M nvmem=64M@448M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"/g' $script_dir/mdfiles/installkernel.pre.sh
		;;
	esac
}

function LGP990_ramhack96() {
	case $1 in
		"do")   
			sed -i 's/#define RAMHACK64/#define RAMHACK96/g' $source_dir/lge-kernel-star/include/linux/ironkrnl.h
			sed -i 's/#define BOOT_CMDLINE 		"mem=447M@0M nvmem=64M@448M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"/#define BOOT_CMDLINE 		"mem=479M@0M nvmem=32M@480M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"/g' $script_dir/mdfiles/installkernel.pre.sh
		;;
		"clean")
			sed -i 's/#define RAMHACK96/#define RAMHACK64/g' $source_dir/lge-kernel-star/include/linux/ironkrnl.h
			sed -i 's/#define BOOT_CMDLINE 		"mem=479M@0M nvmem=32M@480M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"/#define BOOT_CMDLINE 		"mem=447M@0M nvmem=64M@448M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"/g' $script_dir/mdfiles/installkernel.pre.sh
		;;
	esac
}

function LGP990_ramhack80() {
	case $1 in
		"do")   
			sed -i 's/#define RAMHACK64/#define RAMHACK80/g' $source_dir/lge-kernel-star/include/linux/ironkrnl.h
			sed -i 's/#define BOOT_CMDLINE 		"mem=447M@0M nvmem=64M@448M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"/#define BOOT_CMDLINE 		"mem=463M@0M nvmem=48M@464M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"/g' $script_dir/mdfiles/installkernel.pre.sh
		;;
		"clean")
			sed -i 's/#define RAMHACK80/#define RAMHACK64/g' $source_dir/lge-kernel-star/include/linux/ironkrnl.h
			sed -i 's/#define BOOT_CMDLINE 		"mem=463M@0M nvmem=48M@464M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"/#define BOOT_CMDLINE 		"mem=447M@0M nvmem=64M@448M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"/g' $script_dir/mdfiles/installkernel.pre.sh
		;;
	esac
}

function LGP990_ramhack48() {
	case $1 in
		"do")   
			sed -i 's/#define RAMHACK64/#define RAMHACK48/g' $source_dir/lge-kernel-star/include/linux/ironkrnl.h
			sed -i 's/#define BOOT_CMDLINE 		"mem=447M@0M nvmem=64M@448M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"/#define BOOT_CMDLINE 		"mem=431M@0M nvmem=80M@432M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"/g' $script_dir/mdfiles/installkernel.pre.sh
		;;
		"clean")
			sed -i 's/#define RAMHACK48/#define RAMHACK64/g' $source_dir/lge-kernel-star/include/linux/ironkrnl.h
			sed -i 's/#define BOOT_CMDLINE 		"mem=431M@0M nvmem=80M@432M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"/#define BOOT_CMDLINE 		"mem=447M@0M nvmem=64M@448M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"/g' $script_dir/mdfiles/installkernel.pre.sh
		;;
	esac
}

function LGP990_ramhack32() {
	case $1 in
		"do")   
			sed -i 's/#define RAMHACK64/#define RAMHACK32/g' $source_dir/lge-kernel-star/include/linux/ironkrnl.h
			sed -i 's/#define BOOT_CMDLINE 		"mem=447M@0M nvmem=64M@448M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"/#define BOOT_CMDLINE 		"mem=415M@0M nvmem=96M@416M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"/g' $script_dir/mdfiles/installkernel.pre.sh
		;;
		"clean")
			sed -i 's/#define RAMHACK32/#define RAMHACK64/g' $source_dir/lge-kernel-star/include/linux/ironkrnl.h
			sed -i 's/#define BOOT_CMDLINE 		"mem=415M@0M nvmem=96M@416M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"/#define BOOT_CMDLINE 		"mem=447M@0M nvmem=64M@448M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"/g' $script_dir/mdfiles/installkernel.pre.sh
		;;
	esac
}

function LGP990_ramhack0() {
	case $1 in
		"do")   
			sed -i 's/#define RAMHACK64/#define RAMHACK0/g' $source_dir/lge-kernel-star/include/linux/ironkrnl.h
			sed -i 's/#define BOOT_CMDLINE 		"mem=447M@0M nvmem=64M@448M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"/#define BOOT_CMDLINE 		"mem=383M@0M nvmem=128M@384M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"/g' $script_dir/mdfiles/installkernel.pre.sh
		;;
		"clean")
			sed -i 's/#define RAMHACK0/#define RAMHACK64/g' $source_dir/lge-kernel-star/include/linux/ironkrnl.h
			sed -i 's/#define BOOT_CMDLINE 		"mem=383M@0M nvmem=128M@384M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"/#define BOOT_CMDLINE 		"mem=447M@0M nvmem=64M@448M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"/g' $script_dir/mdfiles/installkernel.pre.sh
		;;
	esac
}


echo "Setting up Kernel build"
$build_device
if [ "`which ccache`" != "" -a "$USE_CCACHE" == "1" ]; then # We have ccache and want to use it
	toolchain="ccache $toolchain"
fi

	zip_location=$storage_dir/ironkrnL/TEST/ironkrnL64-$now.zip
	if [ "$ramhack112" == "1" ]; then
		ramhack112_zip_location=$storage_dir/ironkrnL/TEST/ironkrnL112XT-$now.zip
	fi
	if [ "$ramhack104" == "1" ]; then
		ramhack104_zip_location=$storage_dir/ironkrnL/TEST/ironkrnL104XT-$now.zip
	fi
	if [ "$ramhack96" == "1" ]; then
		ramhack96_zip_location=$storage_dir/ironkrnL/TEST/ironkrnL96-$now.zip
	fi
	if [ "$ramhack80" == "1" ]; then
		ramhack80_zip_location=$storage_dir/ironkrnL/TEST/ironkrnL80-$now.zip
	fi
	if [ "$ramhack48" == "1" ]; then
		ramhack48_zip_location=$storage_dir/ironkrnL/TEST/ironkrnL48-$now.zip
	fi
	if [ "$ramhack32" == "1" ]; then
		ramhack32_zip_location=$storage_dir/ironkrnL/TEST/ironkrnL32-$now.zip
	fi
	if [ "$ramhack0" == "1" ]; then
		ramhack0_zip_location=$storage_dir/ironkrnL/TEST/ironkrnL00-$now.zip
	fi

if [ ! -d $source_dir/lge-kernel-star ]; then
	die "Could not find kernel source in $source_dir/lge-kernel-star"
fi

echo "Setting up kernel..."
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
cp $source_dir/lge-kernel-star/arch/arm/boot/zImage $script_dir/Awesome.zip/tmp/ironkrnL/zImage

echo "Grabbing kernel modules..."
if [ ! -d $script_dir/Awesome.zip/tmp/ironkrnL/files/modules/ ]; then
    mkdir -p $script_dir/Awesome.zip/tmp/ironkrnL/files/modules/
fi
rm $script_dir/Awesome.zip/tmp/ironkrnL/files/modules/*

for module in `find $source_dir/lge-kernel-star -name *.ko`
do
    cp $module $script_dir/Awesome.zip/tmp/ironkrnL/files/modules/
done

echo "Making update zip..."
echo "#!/sbin/sh" > $script_dir/Awesome.zip/tmp/ironkrnL/installkernel.sh
cpp -D DEVICE_$build_device $script_dir/mdfiles/installkernel.pre.sh | awk '/# / { next; } { print; }' >> $script_dir/Awesome.zip/tmp/ironkrnL/installkernel.sh
"$build_device"_zip do
cd $script_dir/Awesome.zip/
zip -qr9 $zip_location *
cd -
"$build_device"_zip clean

if [ "$ramhack80" == "1" ]; then
	"$build_device"_ramhack80 do
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
	cp $source_dir/lge-kernel-star/arch/arm/boot/zImage $script_dir/Awesome.zip/tmp/ironkrnL/zImage

	echo "Grabbing kernel modules..."
    if [ ! -d $script_dir/Awesome.zip/tmp/ironkrnL/files/modules/ ]; then
        mkdir -p $script_dir/Awesome.zip/tmp/ironkrnL/files/modules/
    fi
    rm $script_dir/Awesome.zip/tmp/ironkrnL/files/modules/*

	for module in `find $source_dir/lge-kernel-star -name *.ko`
	do
		cp $module $script_dir/Awesome.zip/tmp/ironkrnL/files/modules/
	done
	
	echo "Making update zip..."
	echo "#!/sbin/sh" > $script_dir/Awesome.zip/tmp/ironkrnL/installkernel.sh
	cpp -D DEVICE_$build_device $script_dir/mdfiles/installkernel.pre.sh | awk '/# / { next; } { print; }' >> $script_dir/Awesome.zip/tmp/ironkrnL/installkernel.sh
	"$build_device"_zip do
	cd $script_dir/Awesome.zip/
	zip -qr9 $ramhack80_zip_location *
	cd -
	"$build_device"_zip clean
	"$build_device"_ramhack80 clean
fi

if [ "$ramhack112" == "1" ]; then
	"$build_device"_ramhack112 do
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
	cp $source_dir/lge-kernel-star/arch/arm/boot/zImage $script_dir/Awesome.zip/tmp/ironkrnL/zImage

	echo "Grabbing kernel modules..."
    if [ ! -d $script_dir/Awesome.zip/tmp/ironkrnL/files/modules/ ]; then
        mkdir -p $script_dir/Awesome.zip/tmp/ironkrnL/files/modules/
    fi
    rm $script_dir/Awesome.zip/tmp/ironkrnL/files/modules/*

	for module in `find $source_dir/lge-kernel-star -name *.ko`
	do
		cp $module $script_dir/Awesome.zip/tmp/ironkrnL/files/modules/
	done
	
	echo "Making update zip..."
	echo "#!/sbin/sh" > $script_dir/Awesome.zip/tmp/ironkrnL/installkernel.sh
	cpp -D DEVICE_$build_device $script_dir/mdfiles/installkernel.pre.sh | awk '/# / { next; } { print; }' >> $script_dir/Awesome.zip/tmp/ironkrnL/installkernel.sh
	"$build_device"_zip do
	cd $script_dir/Awesome.zip/
	zip -qr9 $ramhack112_zip_location *
	cd -
	"$build_device"_zip clean
	"$build_device"_ramhack112 clean
fi

if [ "$ramhack104" == "1" ]; then
	"$build_device"_ramhack104 do
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
	cp $source_dir/lge-kernel-star/arch/arm/boot/zImage $script_dir/Awesome.zip/tmp/ironkrnL/zImage

	echo "Grabbing kernel modules..."
    if [ ! -d $script_dir/Awesome.zip/tmp/ironkrnL/files/modules/ ]; then
        mkdir -p $script_dir/Awesome.zip/tmp/ironkrnL/files/modules/
    fi
    rm $script_dir/Awesome.zip/tmp/ironkrnL/files/modules/*

	for module in `find $source_dir/lge-kernel-star -name *.ko`
	do
		cp $module $script_dir/Awesome.zip/tmp/ironkrnL/files/modules/
	done
	
	echo "Making update zip..."
	echo "#!/sbin/sh" > $script_dir/Awesome.zip/tmp/ironkrnL/installkernel.sh
	cpp -D DEVICE_$build_device $script_dir/mdfiles/installkernel.pre.sh | awk '/# / { next; } { print; }' >> $script_dir/Awesome.zip/tmp/ironkrnL/installkernel.sh
	"$build_device"_zip do
	cd $script_dir/Awesome.zip/
	zip -qr9 $ramhack104_zip_location *
	cd -
	"$build_device"_zip clean
	"$build_device"_ramhack104 clean
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
	cp $source_dir/lge-kernel-star/arch/arm/boot/zImage $script_dir/Awesome.zip/tmp/ironkrnL/zImage

	echo "Grabbing kernel modules..."
    if [ ! -d $script_dir/Awesome.zip/tmp/ironkrnL/files/modules/ ]; then
        mkdir -p $script_dir/Awesome.zip/tmp/ironkrnL/files/modules/
    fi
    rm $script_dir/Awesome.zip/tmp/ironkrnL/files/modules/*

	for module in `find $source_dir/lge-kernel-star -name *.ko`
	do
		cp $module $script_dir/Awesome.zip/tmp/ironkrnL/files/modules/
	done
	
	echo "Making update zip..."
	echo "#!/sbin/sh" > $script_dir/Awesome.zip/tmp/ironkrnL/installkernel.sh
	cpp -D DEVICE_$build_device $script_dir/mdfiles/installkernel.pre.sh | awk '/# / { next; } { print; }' >> $script_dir/Awesome.zip/tmp/ironkrnL/installkernel.sh
	"$build_device"_zip do
	cd $script_dir/Awesome.zip/
	zip -qr9 $ramhack96_zip_location *
	cd -
	"$build_device"_zip clean
	"$build_device"_ramhack96 clean
fi

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
	cp $source_dir/lge-kernel-star/arch/arm/boot/zImage $script_dir/Awesome.zip/tmp/ironkrnL/zImage

	echo "Grabbing kernel modules..."
    if [ ! -d $script_dir/Awesome.zip/tmp/ironkrnL/files/modules/ ]; then
        mkdir -p $script_dir/Awesome.zip/tmp/ironkrnL/files/modules/
    fi
    rm $script_dir/Awesome.zip/tmp/ironkrnL/files/modules/*

	for module in `find $source_dir/lge-kernel-star -name *.ko`
	do
		cp $module $script_dir/Awesome.zip/tmp/ironkrnL/files/modules/
	done
	
	echo "Making update zip..."
	echo "#!/sbin/sh" > $script_dir/Awesome.zip/tmp/ironkrnL/installkernel.sh
	cpp -D DEVICE_$build_device $script_dir/mdfiles/installkernel.pre.sh | awk '/# / { next; } { print; }' >> $script_dir/Awesome.zip/tmp/ironkrnL/installkernel.sh
	"$build_device"_zip do
	cd $script_dir/Awesome.zip/
	zip -qr9 $ramhack32_zip_location *
	cd -
	"$build_device"_zip clean
	"$build_device"_ramhack32 clean
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
	cp $source_dir/lge-kernel-star/arch/arm/boot/zImage $script_dir/Awesome.zip/tmp/ironkrnL/zImage

	echo "Grabbing kernel modules..."
    if [ ! -d $script_dir/Awesome.zip/tmp/ironkrnL/files/modules/ ]; then
        mkdir -p $script_dir/Awesome.zip/tmp/ironkrnL/files/modules/
    fi
    rm $script_dir/Awesome.zip/tmp/ironkrnL/files/modules/*

	for module in `find $source_dir/lge-kernel-star -name *.ko`
	do
		cp $module $script_dir/Awesome.zip/tmp/ironkrnL/files/modules/
	done
	
	echo "Making update zip..."
	echo "#!/sbin/sh" > $script_dir/Awesome.zip/tmp/ironkrnL/installkernel.sh
	cpp -D DEVICE_$build_device $script_dir/mdfiles/installkernel.pre.sh | awk '/# / { next; } { print; }' >> $script_dir/Awesome.zip/tmp/ironkrnL/installkernel.sh
	"$build_device"_zip do
	cd $script_dir/Awesome.zip/
	zip -qr9 $ramhack0_zip_location *
	cd -
	"$build_device"_zip clean
	"$build_device"_ramhack0 clean
fi

