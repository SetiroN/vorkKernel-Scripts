#!/sbin/sh

ui_print() {
    echo ui_print "$@" 1>&$UPDATE_CMD_PIPE;
    if [ -n "$@" ]; then
        echo ui_print 1>&$UPDATE_CMD_PIPE;
    fi
}
fatal() { ui_print "$@"; exit 1; }

basedir=`dirname $0`
BB=$basedir/busybox
awk="$BB awk"
chmod="$BB chmod"
warning=0
ril=0

updatename=`echo $UPDATE_FILE | $awk '{ sub(/^.*\//,"",$0); sub(/.zip$/,"",$0); print }'`
kernelver=`echo $updatename | $awk 'BEGIN {RS="-"; ORS="-"}; NR<=2 {print; ORS=""}'`
args=`echo $updatename | $awk 'BEGIN {RS="-"}; NR>2 {print}'`

ui_print ""
ui_print "Installing $kernelver"
ui_print "Developed by Benee and kiljacken"
ui_print ""
ui_print "Checking ROM..."
if [[ `cat /system/build.prop` != *CyanogenMod* ]]; then
    fatal "Current ROM is not CyanogenMod! Aborting..."
fi

ui_print ""
ui_print "Parsing parameters..."
flags=
for pp in $args; do
    case $pp in
        "1080p")
            hdrec=1
            flags="$flags -1080p"
        ;;
        "bc")
            baconcooker=1
            flags="$flags -baconcooker"
        ;;
        "lecam")
            hdrec=1
            lecam=1
            flags="$flags -leCam"
            ui_print "Thanks to LeJay for his cam mod"
        ;;
        "405")
            if [ "$ril" == "1"]; then
                fatal "ERROR: Only one RIL can be flashed!"
            fi
            ril405=1
            ril=1
            flags="$flags -405"
        ;;
        "502")
            if [ "$ril" == "1" ]; then
                fatal "ERROR: Only one RIL can be flashed!"
            fi
            ril502=1
            ril=1
            flags="$flags -502"
        ;;
        "606")
            if [ "$ril" == "1"]; then
                fatal "ERROR: Only one RIL can be flashed!"
            fi
            ril606=1
            ril=1
            flags="$flags -606"
            ;;
        "silent")
            silent=1
            flags="$flags -silent"
        ;;
        "boost")
            boost=1
            flags="$flags -boost"
        ;;
        "density")
            density=1
            flags="$flags -density"
        ;;
        *)
            fatal "ERROR: Unknown argument -$pp"
        ;;
    esac
done

ui_print "Parsing complete"

if [ -n "$flags" ]; then
    ui_print "Flags: $flags"
else
    ui_print "No flags selected"
fi

ui_print "Packing kernel..."

cd $basedir

#Choose Kernel
if [ "$hdrec" == "1" ]; then
    if [ "$baconcooker" == "1" ]; then 
        cp $basedir/Images/1080p/zImageBC $basedir/zImage
    else
        cp $basedir/Images/1080p/zImage $basedir/zImage
    fi
    cline="mem=383M@0M nvmem=128M@384M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"
else
    if [ "$baconcooker" == "1" ]; then 
        cp $basedir/Images/zImageBC $basedir/zImage
    else
        cp $basedir/Images/zImage $basedir/zImage
    fi
    cline="mem=447M@0M nvmem=64M@448M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"
fi

ui_print "Selected correct Kernel version..."
ui_print ""
ui_print "Building boot.img..."
$basedir/mkbootimg --kernel $basedir/zImage --ramdisk $basedir/ramdisk-boot --cmdline "$cline" -o $basedir/boot.img --base 0x10000000
if [ "$?" -ne 0 -o ! -f boot.img ]; then
    fatal "ERROR: Packing kernel failed!"
fi

ui_print ""
ui_print "Flashing the kernel..."
$BB dd if=/dev/zero of=/dev/block/mmcblk0p5
$BB dd if=$basedir/boot.img of=/dev/block/mmcblk0p5
if [ "$?" -ne 0 ]; then
    fatal "ERROR: Flashing kernel failed!"
fi

ui_print ""
ui_print "Installing kernel modules..."
rm -rf /system/lib/modules
cp -r files/lib/modules /system/lib/
if [ "$?" -ne 0 -o ! -d /system/lib/modules ]; then
    ui_print "WARNING: kernel modules not installed!"
    warning=$((warning + 1))
fi

ui_print ""
if [ -n "$flags" ]; then
    ui_print "Installing additional mods..."
fi

# LeCam
if [ "$lecam" == "1" ]; then
    cp $basedir/files/Camera.apk /system/app/Camera.apk
    $chmod 644 /system/app/Camera.apk
fi

# silent cam
if [ "$silent" == "1" ]; then
    mv /system/media/audio/ui/camera_click.ogg /system/media/audio/ui/camera_click.ogg.bak
    mv /system/media/audio/ui/VideoRecord.ogg /system/media/audio/ui/VideoRecord.ogg.bak
fi

# Media Profiles
if [ "$hdrec" == "1" ]; then
    rm /system/etc/media_profiles.xml
    if [ "$lecam" == "1" ]; then
        cp $basedir/files/media_profiles.xml-le1080 /system/etc/media_profiles.xml
    else
        cp $basedir/files/media_profiles.xml-1080 /system/etc/media_profiles.xml
    fi
else
    rm /system/etc/media_profiles.xml
    cp $basedir/files/media_profiles.xml-720 /system/etc/media_profiles.xml
fi

# Ril 405
if [ "$ril405" == "1" ]; then
    rm /system/lib/lge-ril.so
    cp $basedir/files/ril/405/lge-ril.so /system/lib/lge-ril.so
fi

# Ril 502
if [ "$ril502" == "1" ]; then
    rm /system/lib/lge-ril.so
    cp $basedir/files/ril/502/lge-ril.so /system/lib/lge-ril.so
fi

# Ril 606
if [ "$ril606" == "1"]; then
    rm /system/lib/lge-ril.so
    cp $basedir/files/ril/606/lge-ril.so /system/lib/lib-ril.so
fi

#boost
if [ "$boost" == "1" ]; then
    cp $basedir/files/80boost /system/etc/init.d/80boost
    $chmod 750 /system/etc/init.d/80boost
fi

#density
if [ "$density" == "1" ]; then
    sed -n "s/lcd_density=240/lcd_density=220/" /system/build.prop
fi

ui_print ""
if [ $warning -gt 0 ]; then
    ui_print "$kernelver installed with $warning warnings."
else
    ui_print "$kernelver installed successfully. Enjoy"
fi