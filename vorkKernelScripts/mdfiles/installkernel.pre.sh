#define BOOT_PARTITION 		/dev/block/mmcblk0p5
#define SYSTEM_PARTITION	/dev/block/mmcblk0p1
#define DATA_PARTITION		/dev/block/mmcblk0p8
#define CACHE_PARTITION		/dev/block/mmcblk1p2

#define SECONDARY_INIT		init.p990.rc

#define BOOT_PAGESIZE 		0x800
#define BOOT_CMDLINE 		"mem=447M@0M nvmem=64M@448M loglevel=0 muic_state=1 lpj=9994240 CRC=3010002a8e458d7 vmalloc=256M brdrev=1.0 video=tegrafb console=ttyS0,115200n8 usbcore.old_scheme_first=1 tegraboot=sdmmc tegrapart=recovery:35e00:2800:800,linux:34700:1000:800,mbr:400:200:800,system:600:2bc00:800,cache:2c200:8000:800,misc:34200:400:800,userdata:38700:c0000:800 androidboot.hardware=p990"
#define BOOT_BASE			0x10000000

#define HAS_CM
#define HAS_MIUI

#define IS_PHONE

#define EXT4_RDY

device=LGP990

ui_print() {
    echo ui_print "$@" 1>&$UPDATE_CMD_PIPE;
    if [ -n "$@" ]; then
        echo ui_print 1>&$UPDATE_CMD_PIPE;
    fi
}
log () { echo "$@"; }
fatal() { ui_print "$@"; exit 1; }

basedir=`dirname $0`
BB=$basedir/busybox
awk="$BB awk"
chmod="$BB chmod"
gunzip="$BB gunzip"
cpio="$BB cpio"
find="$BB find"
gzip="$BB gzip"
warning=0
ril=0
bit=0
density=0
ringsettings=0
sstatesettings=0
scriptsettings=0
screenstate=1
script=0
ring=0
#ifdef EXT4_RDY
extrdy=1
#endif
int2ext=0
ext4=1

updatename=`echo $UPDATE_FILE | $awk '{ sub(/^.*\//,"",$0); sub(/.zip$/,"",$0); print }'`
kernelver=`echo $updatename | $awk 'BEGIN {RS="-"; ORS="-"}; NR<=2 {print; ORS=""}'`
args=`echo $updatename | $awk 'BEGIN {RS="-"}; NR>2 {print}'`

log ""
log "Kernel script started. Installing $UPDATE_FILE in $basedir"
log ""
ui_print ""
ui_print ""
ui_print " **  Installing ironkrnL  **"
ui_print ""
ui_print "Toolchain, scripts and OC/UV code"
ui_print "provided by Benee and kiljacken"
ui_print ""
ui_print " compiled by SetiroN "
ui_print ""
#ifndef HAS_OTHER
ui_print "Checking ROM..."

#ifdef HAS_CM
cymo=`cat /system/build.prop | $awk 'tolower($0) ~ /cyanogenmod/ { printf "1"; exit 0 }'`
#endif // HAS_CM

#ifdef HAS_MIUI
miui=`cat /system/build.prop | $awk 'tolower($0) ~ /miui/ { printf "1"; exit 0 }'`
#endif // HAS_MIUI

epeen=`echo $kernelver | awk 'tolower($0) ~ /epeen/ { printf "1"; exit 0 }'`

if [ "$cymo" == "1" ]; then
    log "Installing on CyanogenMod"
elif [ "$miui" == "1" ]; then
    log "Installing on Miui"
else
    fatal "Current ROM is not compatible with ironkrnL! Aborting..."
fi

ui_print ""
#endif //HAS_OTHER

ui_print "Packing kernel..."

cd $basedir

log "dumping previous kernel image to $basedir/boot.old"
$BB dd if=BOOT_PARTITION of=$basedir/boot.old
if [ ! -f $basedir/boot.old ]; then
	fatal "ERROR: Dumping old boot image failed"
fi

log "Unpacking boot image..."
log ""
ramdisk="$basedir/boot.old-ramdisk.gz"
$basedir/unpackbootimg -i $basedir/boot.old -o $basedir/ -p BOOT_PAGESIZE
if [ "$?" -ne 0 -o ! -f $ramdisk ]; then
    fatal "ERROR: Unpacking old boot image failed (ramdisk)"
fi

mkdir $basedir/ramdisk
cd $basedir/ramdisk
log "Extracting ramdisk"
$gunzip -c $basedir/boot.old-ramdisk.gz | $cpio -i

if [ ! -f init.rc ]; then
    fatal "ERROR: Unpacking ramdisk failed!"
elif [ ! -f SECONDARY_INIT ]; then
    fatal "ERROR: Invalid ramdisk!"
fi

log "Applying init.rc tweaks..."
cp init.rc ../init.rc.org
$awk -f $basedir/awk/initrc.awk ../init.rc.org > ../init.rc.mod

FSIZE=`ls -l ../init.rc.mod | $awk '{ print $5 }'`
log "init.rc.mod filesize: $FSIZE"

if [[ -s ../init.rc.mod ]]; then
  mv ../init.rc.mod init.rc
else
  ui_print "Applying init.rc tweaks failed! Continue without tweaks"
  warning=$((warning + 1))
fi

#ifdef EXT4_RDY
log "Applying "SECONDARY_INIT" tweaks..."
cp SECONDARY_INIT ../SECONDARY_INIT.org
$awk -v ext4=$ext4 -f $basedir/awk/ext4.awk ../SECONDARY_INIT.org > ../SECONDARY_INIT.mod

FSIZE=`ls -l ../SECONDARY_INIT.mod | $awk '{ print $5 }'`
log SECONDARY_INIT".mod filesize: $FSIZE"

if [[ -s ../SECONDARY_INIT.mod ]]; then
  mv ../SECONDARY_INIT.mod SECONDARY_INIT
else
  if [ "$ext4" == "1" ]; then
    extrdy=0
    ui_print "WARNING: Tweaking "SECONDARY_INIT" failed. Script won't convert filesystem to ext4!"
    warning=$((warning + 1))
  fi
fi
#endif

log "Build new ramdisk..."
$BB find . | $BB cpio -o -H newc | $BB gzip > $basedir/boot.img-ramdisk.gz
if [ "$?" -ne 0 -o ! -f $basedir/boot.img-ramdisk.gz ]; then
	fatal "ERROR: Ramdisk repacking failed!"
fi

cd $basedir

log "Building boot.img..."
$basedir/mkbootimg --kernel $basedir/zImage --ramdisk $basedir/boot.img-ramdisk.gz --cmdline BOOT_CMDLINE -o $basedir/boot.img --base BOOT_BASE
if [ "$?" -ne 0 -o ! -f boot.img ]; then
    fatal "ERROR: Packing kernel failed!"
fi

ui_print ""
ui_print "Flashing the kernel..."
$BB dd if=/dev/zero of=BOOT_PARTITION
$BB dd if=$basedir/boot.img of=BOOT_PARTITION
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

$BB mount /data
ui_print ""
ui_print "Cleaning up interferences..."
$BB rm -rf /system/etc/init.d/10journalismoff
$BB rm -rf /system/etc/init.d/11mountoptions
$BB rm -rf /system/etc/init.d/11ext4journalismoff
$BB rm -rf /system/etc/init.d/12perfectmountoptions
$BB rm -rf /system/etc/init.d/12removelogger
$BB rm -rf /system/etc/init.d/13disablenormalizedsleep
$BB rm -rf /system/etc/init.d/13dis_norm_sleeper
$BB rm -rf /system/etc/init.d/15fuckthelogger
$BB rm -rf /system/etc/init.d/16wehatenormalizedsleep
$BB rm -rf /system/etc/init.d/70zipalign
$BB rm -rf /system/etc/init.d/70zipalign_defragdb
$BB rm -rf /system/etc/init.d/80log
$BB rm -rf /system/etc/init.d/90vktweak
$BB rm -rf /system/etc/init.d/90irontweaks
$BB rm -rf /system/etc/init.d/95zipalign_defragdb
$BB rm -rf /system/etc/init.d/97ramtweak
$BB rm -rf /system/etc/init.d/98ramtweak
$BB rm -rf /system/etc/init.d/99ramtweak
$BB rm -rf /system/etc/init.d/97loopy_smoothness_tweak
$BB rm -rf /system/etc/init.d/S_loopy_smoothness_tweak
$BB rm -rf /system/etc/init.d/98KickassKernelTweaks
$BB rm -rf /system/etc/init.d/99supercharger
$BB rm -rf /system/etc/init.d/S_volt_scheduler
$BB rm -rf /system/etc/init.d/S_ramtweak
$BB rm -rf /system/lib/libsqlite.so
ui_print "Installing additional mods..."
cp $basedir/files/libsqlite.so /system/lib/libsqlite.so
cp $basedir/files/11mountoptions /system/etc/init.d/11mountoptions
cp $basedir/files/12removelogger /system/etc/init.d/12removelogger
cp $basedir/files/Clockopia.ttf /system/fonts/Clockopia.ttf
cp $basedir/files/DroidSans-Bold.ttf /system/fonts/DroidSans-Bold.ttf
cp $basedir/files/DroidSans.ttf /system/fonts/DroidSans.ttf
cp $basedir/files/hosts /system/etc/hosts
cp $basedir/files/gps.conf /system/etc/gps.conf
cp $basedir/files/90irontweaks /system/etc/init.d/90irontweaks
cp $basedir/files/95zipalign_defragdb /system/etc/init.d/95zipalign_defragdb
cp $basedir/files/bootanimation.zip /data/local/bootanimation.zip
touch /system/etc/.root_browser

chmod 777 /system/etc/init.d/11mountoptions
chmod 777 /system/etc/init.d/12removelogger
chmod 777 /system/etc/init.d/90irontweaks
chmod 777 /system/etc/init.d/95zipalign_defragdb
chmod 777 /data/local/bootanimation.zip

if [ "$silent" == "1" ]; then
    mv /system/media/audio/ui/camera_click.ogg /system/media/audio/ui/camera_click.ogg.bak
    mv /system/media/audio/ui/VideoRecord.ogg /system/media/audio/ui/VideoRecord.ogg.bak
fi

  ui_print ""
cp /system/build.prop $basedir/build.prop
  ui_print "Saving build.prop copies..."
cp /system/build.prop /sdcard/build.prop.bak
cp /system/build.prop /system/build.prop.bak
$awk -f $basedir/awk/buildprop.awk $basedir/build.prop > $basedir/build.prop.mod

FSIZE=`ls -l $basedir/build.prop.mod | $awk '{ print $5 }'`
log ""
log "build.prop.mod filesize: $FSIZE"
log ""

if [[ -s $basedir/build.prop.mod ]]; then
  cp $basedir/build.prop.mod /system/build.prop
  ui_print "Applying build.prop tweaks..."
else
  ui_print "WARNING: Tweaking build.prop failed! Continue without tweaks"
  warning=$((warning + 1))
fi
  $BB rm -rf $basedir/build.prop.mod*

cp /system/etc/vold.fstab $basedir/vold.fstab
$awk -v int2ext=$int2ext -f $basedir/awk/voldfstab.awk $basedir/vold.fstab > $basedir/vold.fstab.mod

FSIZE=`ls -l $basedir/vold.fstab.mod | $awk '{ print $5 }'`
log ""
log "vold.fstab.mod filesize: $FSIZE"
log ""

if [[ -s $basedir/vold.fstab.mod ]]; then
  cp $basedir/vold.fstab.mod /system/etc/vold.fstab
else
  ui_print "WARNING: Tweaking vold.fstab failed! Continue without tweaks"
  warning=$((warning + 1))
fi

if [ "$ril" == "1" ]; then
    rm /system/lib/lge-ril.so
    cp $basedir/files/ril/$rildate/lge-ril.so /system/lib/lge-ril.so
fi

if [ "$debug" == "1" ]; then
    cp $basedir/files/80log /system/etc/init.d/80log
	chmod 755 /system/etc/init.d/80log
fi

#ifdef EXT4_RDY
if [ "$ext4" == "1" ]; then
  if [ "$extrdy" == "1" ]; then
    umount /system
    umount /data
    umount /cache
    
ui_print ""
ui_print "Converting file-systems to EXT4..."
    tune2fs -O extents,uninit_bg,dir_index DATA_PARTITION
    e2fsck -p DATA_PARTITION
    tune2fs -O extents,uninit_bg,dir_index DATA_PARTITION
    e2fsck -p DATA_PARTITION
ui_print "/data converted;"
    tune2fs -O extents,uninit_bg,dir_index SYSTEM_PARTITION
    e2fsck -p SYSTEM_PARTITION
    tune2fs -O extents,uninit_bg,dir_index SYSTEM_PARTITION
    e2fsck -p SYSTEM_PARTITION
ui_print "/system converted;"
    tune2fs -O extents,uninit_bg,dir_index CACHE_PARTITION
    e2fsck -p CACHE_PARTITION
    tune2fs -O extents,uninit_bg,dir_index CACHE_PARTITION
    e2fsck -p CACHE_PARTITION
ui_print "/cache converted."
  fi
fi
#endif

if [ -n "$flags" ]; then
    ui_print ""
fi

if [ "$debug" == "1" ]; then
  rm -r /sdcard/ironDebug
  mkdir /sdcard/ironDebug
  cp -r $basedir/. /sdcard/ironDebug/
fi

ui_print ""
if [ $warning -gt 0 ]; then
    ui_print "$kernelver installed with $warning warnings."
else
    ui_print "$kernelver installed successfully."
    ui_print "    Enjoy!"
fi
