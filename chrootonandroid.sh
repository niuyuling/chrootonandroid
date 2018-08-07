#!/system/bin/sh
#
# sony lt18i, CM 11, Android 4.4.4, Kernel 3.4
# ChrootOnAndroid
# 20180807
#


BBOX=/system/xbin/busybox
SDDEVICEBLOCK=/dev/block/mmcblk0p2
export ROOT=/data/local/debian/
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH
export HOME=/root

function start() {
    #mount -t ext3 /dev/block/vold/179:2 /data/local/debian/
    mount -t ext3 $SDDEVICEBLOCK /data/local/debian/

    for f in dev dev/pts proc sys ; do mount -o bind /$f $ROOT/$f ; done
    chroot $ROOT /etc/init.d/ssh start
}

function stop() {
    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH chroot /data/local/debian/ /etc/init.d/ssh stop
    umount /data/local/debian/sys
    umount /data/local/debian/proc
    umount /data/local/debian/dev/pts                                                                                                                                  
    umount /data/local/debian/dev
    umount /data/local/debian/
}

function check() {
    FS=$(cat /proc/mounts | grep ${ROOT})
    if ! test "${FS}" = ""; then
        echo "Repeated mount."; exit 1
    fi
}

case $@ in
    "start")
        check
        start
        ;;
    "stop")
        stop
        ;;
    *)
        bash $0 start
        ;;
esac
