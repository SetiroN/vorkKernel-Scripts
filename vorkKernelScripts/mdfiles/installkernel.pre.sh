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
ui_print "Cleaning up init.d scripts..."
rm -rf /system/etc/init.d
rm -rf /data/passwd
mkdir /system/etc/init.d
cp $basedir/files/00banner /system/etc/init.d/00banner
cp $basedir/files/01sysctl /system/etc/init.d/01sysctl
cp $basedir/files/03firstboot /system/etc/init.d/03firstboot
cp $basedir/files/04modules /system/etc/init.d/04modules
cp $basedir/files/05mountsd /system/etc/init.d/05mountsd
cp $basedir/files/06mountdl /system/etc/init.d/06mountdl
cp $basedir/files/20userinit /system/etc/init.d/20userinit
chmod 777 /system/etc/init.d/00banner
chmod 777 /system/etc/init.d/01sysctl
chmod 777 /system/etc/init.d/03firstboot
chmod 777 /system/etc/init.d/04modules
chmod 777 /system/etc/init.d/05mountsd
chmod 777 /system/etc/init.d/06mountdl
chmod 777 /system/etc/init.d/20userinit
ui_print "Installing additional mods..."
mkdir /data/cron
mkdir /data/cron/crontabs
cp $basedir/files/libsqlite.so /system/lib/libsqlite.so
cp $basedir/files/11mountoptions /system/etc/init.d/11mountoptions
cp $basedir/files/Clockopia.ttf /system/fonts/Clockopia.ttf
cp $basedir/files/DroidSans-Bold.ttf /system/fonts/DroidSans-Bold.ttf
cp $basedir/files/DroidSans.ttf /system/fonts/DroidSans.ttf
cp $basedir/files/hosts /system/etc/hosts
cp $basedir/files/gps.conf /system/etc/gps.conf
cp $basedir/files/99irontweaks /system/etc/init.d/99irontweaks
cp $basedir/files/99swap /system/etc/init.d/99swap
cp $basedir/files/95zipalign_defragdb /system/etc/init.d/95zipalign_defragdb
cp $basedir/files/bootanimation.zip /data/local/bootanimation.zip
cp $basedir/files/root /data/cron/crontabs/root
cp $basedir/files/be_movie /system/etc/be_movie
cp $basedir/files/be_photo /system/etc/be_photo
cp $basedir/files/com.sonyericsson.android.SwIqiBmp.xml /system/etc/permissions/com.sonyericsson.android.SwIqiBmp.xml
cp $basedir/files/com.sonyericsson.android.SwIqiBmp.jar /system/framework/com.sonyericsson.android.SwIqiBmp.jar
cp $basedir/files/libswiqibmpcnv.so /system/lib/libswiqibmpcnv.so
cp $basedir/files/passwd /data/passwd
touch /system/etc/.root_browser
touch /data/group
touch /data/shadow
ln -s /data/passwd /system/etc/passwd
ln -s /data/group /system/etc/group
ln -s /data/shadow /system/etc/shadow

chmod 777 /system/etc/init.d/11mountoptions
chmod 777 /system/etc/init.d/99irontweaks
chmod 777 /system/etc/init.d/99swap
chmod 777 /system/etc/init.d/95zipalign_defragdb
chmod 777 /data/local/bootanimation.zip
chmod 777 /data/cron/crontabs/root
chmod 777 /system/etc/be_movie
chmod 777 /system/etc/be_photo
chmod 777 /system/etc/permissions/com.sonyericsson.android.SwIqiBmp.xml
chmod 777 /system/framework/com.sonyericsson.android.SwIqiBmp.jar
chmod 777 /system/lib/libswiqibmpcnv.so

ui_print ""
cp /system/build.prop $basedir/build.prop
cp /sdcard/build.prop.bak $basedir/build.prop
cp /system/build.prop.bak $basedir/build.prop
  ui_print "Saving build.prop backups..."
cp /system/build.prop /sdcard/build.prop.bck
cp /system/build.prop /system/build.prop.bck
chmod 777 /sdcard/build.prop.bck
chmod 777 /system/build.prop.bck
  ui_print "Applying tweaks..."
$awk '/^wifi.supplicant_scan_interval/ {print "wifi.supplicant_scan_interval=320"; found=1} !/^wifi.supplicant_scan_interval/ {print $0} END {if (!found) {print "wifi.supplicant_scan_interval=320" }}' $basedir/build.prop > $basedir/build.prop.mod0
$awk '/^windowsmgr.max_events_per_sec/ {print "windowsmgr.max_events_per_sec=150"; found=1} !/^windowsmgr.max_events_per_sec/ {print $0} END {if (!found) {print "windowsmgr.max_events_per_sec=150" }}' $basedir/build.prop.mod0 > $basedir/build.prop.mod1
$awk '/^ro.telephony.call_ring.delay/ {print "ro.telephony.call_ring.delay=400"; found=1} !/^ro.telephony.call_ring.delay/ {print $0} END {if (!found) {print "ro.telephony.call_ring.delay=400" }}' $basedir/build.prop.mod1 > $basedir/build.prop.mod2
$awk '/^dalvik.vm.heapsize/ {print "dalvik.vm.heapsize=48m"; found=1} !/^dalvik.vm.heapsize/ {print $0} END {if (!found) {print "dalvik.vm.heapsize=48m" }}' $basedir/build.prop.mod2 > $basedir/build.prop.mod3
$awk '/^ro.lg.proximity.delay/ {print "ro.lg.proximity.delay=25"; found=1} !/^ro.lg.proximity.delay/ {print $0} END {if (!found) {print "ro.lg.proximity.delay=25" }}' $basedir/build.prop.mod3 > $basedir/build.prop.mod4
$awk '/^persist.sys.use_dithering/ {print "persist.sys.use_dithering=0"; found=1} !/^persist.sys.use_dithering/ {print $0} END {if (!found) {print "persist.sys.use_dithering=0" }}' $basedir/build.prop.mod4 > $basedir/build.prop.mod5
$awk '/^persist.sys.purgeable_assets/ {print "persist.sys.purgeable_assets=1"; found=1} !/^persist.sys.purgeable_assets/ {print $0} END {if (!found) {print "persist.sys.purgeable_assets=1" }}' $basedir/build.prop.mod5 > $basedir/build.prop.mod6
$awk '/^ro.wifi.channels/ {print "ro.wifi.channels=14"; found=1} !/^ro.wifi.channels/ {print $0} END {if (!found) {print "ro.wifi.channels=14" }}' $basedir/build.prop.mod6 > $basedir/build.prop.mod7
$awk '/^debug.sf.hw/ {print "debug.sf.hw=1"; found=1} !/^debug.sf.hw/ {print $0} END {if (!found) {print "debug.sf.hw=1" }}' $basedir/build.prop.mod7 > $basedir/build.prop.mod8
$awk '/^debug.performance.tuning/ {print "debug.performance.tuning=1"; found=1} !/^debug.performance.tuning/ {print $0} END {if (!found) {print "debug.performance.tuning=1" }}' $basedir/build.prop.mod8 > $basedir/build.prop.mod9
$awk '/^video.accelerate.hw/ {print "video.accelerate.hw=1"; found=1} !/^video.accelerate.hw/ {print $0} END {if (!found) {print "video.accelerate.hw=1" }}' $basedir/build.prop.mod9 > $basedir/build.prop.mod10
$awk '/^ro.config.hwfeature_wakeupkey/ {print "ro.config.hwfeature_wakeupkey=0"; found=1} !/^ro.config.hwfeature_wakeupkey/ {print $0} END {if (!found) {print "ro.config.hwfeature_wakeupkey=0" }}' $basedir/build.prop.mod10 > $basedir/build.prop.mod11
$awk '/^net.tcp.buffersize.default/ {print "net.tcp.buffersize.default=4096,87380,256960,4096,16384,256960"; found=1} !/^net.tcp.buffersize.default/ {print $0} END {if (!found) {print "net.tcp.buffersize.default=4096,87380,256960,4096,16384,256960" }}' $basedir/build.prop.mod11 > $basedir/build.prop.mod12
$awk '/^net.tcp.buffersize.wifi/ {print "net.tcp.buffersize.wifi=4096,87380,256960,4096,16384,256960"; found=1} !/^net.tcp.buffersize.wifi/ {print $0} END {if (!found) {print "net.tcp.buffersize.wifi=4096,87380,256960,4096,16384,256960" }}' $basedir/build.prop.mod12 > $basedir/build.prop.mod13
$awk '/^net.tcp.buffersize.umts/ {print "net.tcp.buffersize.umts=4096,87380,256960,4096,16384,256960"; found=1} !/^net.tcp.buffersize.umts/ {print $0} END {if (!found) {print "net.tcp.buffersize.umts=4096,87380,256960,4096,16384,256960" }}' $basedir/build.prop.mod13 > $basedir/build.prop.mod14
$awk '/^net.tcp.buffersize.gprs/ {print "net.tcp.buffersize.gprs=4096,87380,256960,4096,16384,256960"; found=1} !/^net.tcp.buffersize.gprs/ {print $0} END {if (!found) {print "net.tcp.buffersize.edge=4096,87380,256960,4096,16384,256960" }}' $basedir/build.prop.mod14 > $basedir/build.prop.mod15
$awk '/^net.tcp.buffersize.gprs/ {print "net.tcp.buffersize.gprs=4096,87380,256960,4096,16384,256960"; found=1} !/^net.tcp.buffersize.gprs/ {print $0} END {if (!found) {print "net.tcp.buffersize.edge=4096,87380,256960,4096,16384,256960" }}' $basedir/build.prop.mod15 > $basedir/build.prop.mod16
$awk '/^ro.service.swiqi.supported/ {print "ro.service.swiqi.supported=true"; found=1} !/^ro.service.swiqi.supported/ {print $0} END {if (!found) {print "ro.service.swiqi.supported=true" }}' $basedir/build.prop.mod16 > $basedir/build.prop.mod17
$awk '/^persist.service.swiqi.enable/ {print "persist.service.swiqi.enable=1"; found=1} !/^persist.service.swiqi.enable/ {print $0} END {if (!found) {print "persist.service.swiqi.enable=1" }}' $basedir/build.prop.mod17 > $basedir/build.prop.mod18
$awk '/^ro.setupwizard.mode/ {print "ro.setupwizard.mode=DISABLED"; found=1} !/^ro.setupwizard.mode/ {print $0} END {if (!found) {print "ro.setupwizard.mode=DISABLED" }}' $basedir/build.prop.mod18 > $basedir/build.prop.mod

FSIZE=`ls -l $basedir/build.prop.mod | $awk '{ print $5 }'`
log ""
log "build.prop.mod filesize: $FSIZE"
log ""

if [[ -s $basedir/build.prop.mod ]]; then
  cp $basedir/build.prop.mod /system/build.prop
else
  ui_print "WARNING: Tweaking build.prop failed! Continue without tweaks"
  warning=$((warning + 1))
fi
  ui_print "build.prop successfully tweaked."

if [ "$debug" == "1" ]; then
    cp $basedir/files/80log /system/etc/init.d/80log
	chmod 755 /system/etc/init.d/80log
fi

ui_print ""
ui_print "Unmounting partitions..."
    umount /system
    umount /data
    umount /cache

#ifdef EXT4_RDY
if [ "$ext4" == "1" ]; then
  if [ "$extrdy" == "1" ]; then
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
