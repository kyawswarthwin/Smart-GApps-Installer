export PATH=/data/local/tmp:$PATH

chmod 755 /data/local/tmp/busybox

busybox mount -o remount,rw /system

busybox chown -R root.root /data/local/tmp/system/*
busybox chmod -R 644 /data/local/tmp/system/*
busybox cp -R /data/local/tmp/system/* /system
busybox chown root.root /system/addon.d/70-gapps.sh
busybox chmod 755 /system/addon.d/70-gapps.sh
