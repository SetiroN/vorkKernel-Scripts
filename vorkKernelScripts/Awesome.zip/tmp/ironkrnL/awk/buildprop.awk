/^wifi.supplicant_scan_interval/ {print "wifi.supplicant_scan_interval=320"; found=1} !/^wifi.supplicant_scan_interval/ {print $0} END {if (!found) {print "wifi.supplicant_scan_interval=320" } next; }
/^windowsmgr.max_events_per_sec/ {print "windowsmgr.max_events_per_sec=150"; found=1} !/^windowsmgr.max_events_per_sec/ {print $0} END {if (!found) {print "windowsmgr.max_events_per_sec=150" } next; }
/^ro.telephony.call_ring.delay/ {print "ro.telephony.call_ring.delay=400"; found=1} !/^ro.telephony.call_ring.delay/ {print $0} END {if (!found) {print "ro.telephony.call_ring.delay=400" } next; }
/^dalvik.vm.heapsize/ {print "dalvik.vm.heapsize=48m"; found=1} !/^dalvik.vm.heapsize/ {print $0} END {if (!found) {print "dalvik.vm.heapsize=48m" } next; }
/^ro.lg.proximity.delay/ {print "ro.lg.proximity.delay=25"; found=1} !/^ro.lg.proximity.delay/ {print $0} END {if (!found) {print "ro.lg.proximity.delay=25" } next; }
/^persist.sys.use_dithering/ {print "persist.sys.use_dithering=0"; found=1} !/^persist.sys.use_dithering/ {print $0} END {if (!found) {print "persist.sys.use_dithering=0" } next; }
/^persist.sys.purgeable_assets/ {print "persist.sys.purgeable_assets=1"; found=1} !/^persist.sys.purgeable_assets/ {print $0} END {if (!found) {print "persist.sys.purgeable_assets=1" } next; }
/^ro.wifi.channels/ {print "ro.wifi.channels=14"; found=1} !/^ro.wifi.channels/ {print $0} END {if (!found) {print "ro.wifi.channels=14" } next; }
/^debug.sf.hw/ {print "debug.sf.hw=1"; found=1} !/^debug.sf.hw/ {print $0} END {if (!found) {print "debug.sf.hw=1" } next; }
/^debug.performance.tuning/ {print "debug.performance.tuning=1"; found=1} !/^debug.performance.tuning/ {print $0} END {if (!found) {print "debug.performance.tuning=1" } next; }
/^video.accelerate.hw/ {print "video.accelerate.hw=1"; found=1} !/^video.accelerate.hw/ {print $0} END {if (!found) {print "video.accelerate.hw=1" } next; }
/^ro.config.hwfeature_wakeupkey/ {print "ro.config.hwfeature_wakeupkey=0"; found=1} !/^ro.config.hwfeature_wakeupkey/ {print $0} END {if (!found) {print "ro.config.hwfeature_wakeupkey=0" } next; }
/^net.tcp.buffersize.default/ {print "net.tcp.buffersize.default=4096,87380,256960,4096,16384,256960"; found=1} !/^net.tcp.buffersize.default/ {print $0} END {if (!found) {print "net.tcp.buffersize.default=4096,87380,256960,4096,16384,256960" } next; }
/^net.tcp.buffersize.wifi/ {print "net.tcp.buffersize.wifi=4096,87380,256960,4096,16384,256960"; found=1} !/^net.tcp.buffersize.wifi/ {print $0} END {if (!found) {print "net.tcp.buffersize.wifi=4096,87380,256960,4096,16384,256960" } next; }
/^net.tcp.buffersize.umts/ {print "net.tcp.buffersize.umts=4096,87380,256960,4096,16384,256960"; found=1} !/^net.tcp.buffersize.umts/ {print $0} END {if (!found) {print "net.tcp.buffersize.umts=4096,87380,256960,4096,16384,256960" } next; }
/^net.tcp.buffersize.gprs/ {print "net.tcp.buffersize.gprs=4096,87380,256960,4096,16384,256960"; found=1} !/^net.tcp.buffersize.gprs/ {print $0} END {if (!found) {print "net.tcp.buffersize.edge=4096,87380,256960,4096,16384,256960" } next; }
/^net.tcp.buffersize.gprs/ {print "net.tcp.buffersize.gprs=4096,87380,256960,4096,16384,256960"; found=1} !/^net.tcp.buffersize.gprs/ {print $0} END {if (!found) {print "net.tcp.buffersize.edge=4096,87380,256960,4096,16384,256960" } next; }
/^ro.setupwizard.mode/ {print "ro.setupwizard.mode=DISABLED"; found=1} !/^ro.setupwizard.mode=DISABLED/ {print $0} END {if (!found) {print "ro.setupwizard.mode=DISABLED" } print; }

