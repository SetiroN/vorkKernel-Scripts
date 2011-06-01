#!/sbin/sh
ui_print() {
    echo ui_print "$@" 1>&$UPDATE_CMD_PIPE;
    if [ -n "$@" ]; then
        echo ui_print 1>&$UPDATE_CMD_PIPE;
    fi
}
log() { echo "$@"; }
fatal() { ui_print "$@"; exit 1; }

log ""

basedir=`dirname $0`
BB=$basedir/busybox
awk="$BB awk"
grep="$BB grep"
chmod="$BB chmod"
chown="$BB chown"
chgrp="$BB chgrp"
cpio="$BB cpio"
find="$BB find"
gzip="$BB gzip"
gunzip="$BB gunzip"
tar="$BB tar"
errors=0
warning=0

updatename=`echo $UPDATE_FILE | $awk '{ sub(/^.*\//,"",$0); sub(/.zip$/,"",$0); print }'`
#kernelver=`echo $updatename | $awk 'BEGIN {RS="-"; ORS="-"}; NR<=2 {print; ORS=""}`
args=`echo $updatename | $awk 'BEGIN {RS="-"}; NR>2 {print}'`

ui_print ""
ui_print "Installing $kernelver"
ui_print "Developed by Benee and kiljacken"
ui_print ""
ui_print "Parsing parameters..."
flags=
for pp in $args; do
  if [ "$pp" == "1080p" ]; then
      hdrec=1
      flags="$flags -1080p"
  elif [ "$pp" == "BC" ]; then
      baconcooker=1
      flags="$flags -baconcooker"
  elif [ "$pp" == "leCam" ]; then
      leeCam=1
      flags="$flags -leCam"
  else
      errors=$((errors + 1))
      ui_print "ERROR: unknown argument -$pp"
  fi
done

if [ "$leCam" == "1" ]: then
ui_print "thanks to LeJay for his cam mod"
fi

if [ -n "$flags" ]; then
    ui_print "flags:$flags"
fi

if [ $errors -gt 0 ]; then
    fatal "argument parsing failed, aborting."
fi

ui_print "Packing kernel..."
cd $basedir
if [ "$hdrec" == "1" ]; then
	if [ "$baconcooker" == "1" ]; then 
		mv Images/1080p/zImageBC zImage
	else
		mv Images/1080p/zImage zImage
	fi
	cline="mem=383M@0M nvmem=128M@384M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"

	if [ "$leeCam" == "1" ]; then
	  cp files/Camera.apk /system/app/Camera.apk
	  chmod 0644 /system/app/Camera.apk
	  cp $basedir/files/media_profiles.xml-le1080 /system/etc/media_profiles.xml
	else
	  cp $basedir/Images/1080p/media_profiles.xml-1080 /system/etc/media_profiles.xml
	fi

else
	if [ "$baconcooker" == "1" ]; then 
		mv Images/zImageBC zImage
	else
		mv Images/zImage zImage
	fi
	cline="mem=447M@0M nvmem=64M@447M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"

	if [ "$leeCam" == "1" ]; then
	  cp files/Camera.apk /system/app/Camera.apk
	  chmod 0644 /system/app/Camera.apk
	  cp $basedir/files/media_profiles.xml-le720 /system/etc/media_profiles.xml
	else
	  cp $basedir/media_profiles.xml-720 /system/etc/media_profiles.xml
	fi
fi

ui_print "building boot.img..."
/tmp/vorkKernel/mkbootimg --kernel /tmp/vorkKernel/zImage --ramdisk /tmp/vorkKernel/ramdisk-boot --cmdline "$cline" -o /tmp/vorkKernel/boot.img --base 0x10000000
else
