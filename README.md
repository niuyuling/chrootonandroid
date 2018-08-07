# ChrootOnAndroid
    参考
	https://wiki.debian.org/chroot
    https://wiki.debian.org/ChrootOnAndroid

# 本机SD卡分区
    root@LT18i:/ # fdisk /dev/block/mmcblk0                                                                                                                                           

    Command (m for help): p
    Disk /dev/block/mmcblk0: 3768 MB, 3951034368 bytes, 7716864 sectors
    478 cylinders, 256 heads, 63 sectors/track
    Units: sectors of 1 * 512 = 512 bytes

    Device             Boot StartCHS    EndCHS        StartLBA     EndLBA    Sectors  Size Id Type
    /dev/block/mmcblk0p1    0,1,1       199,255,63          63    3225599    3225537 1574M 83 Linux
    /dev/block/mmcblk0p2    200,0,1     477,255,63     3225600    7709183    4483584 2189M 83 Linux

    Command (m for help): 

    格式化分区
    mkfs.vfat /dev/block/mmcblk0p1    #本机/sdcard卡目录
    mkfs.ext3 /dev/block/mmcblk0p2

# 制作镜像
    debian arm chroot linux镜像制作方法，
    http://webthen.net/thread-140-1-2.html
	
	
    mount /dev/block/mmcblk0p2 /mnt
    debootstrap --foreign --arch armel wheezy /mnt http://ftp.cn.debian.org/debian/
    DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true LC_ALL=C LANGUAGE=C LANG=C chroot /mnt /debootstrap/debootstrap --second-stage
    DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true LC_ALL=C LANGUAGE=C LANG=C chroot /mnt dpkg --configure -a

# 安装opensh-server
    chroot /data/local/debian/ /bin/bash
    export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH
    export HOME=/root
    apt-get update
    apt-get install openssh-server

# 启动ChrootOnAndroid
    SDDEVICEBLOCK=/dev/block/mmcblk0p2
    export ROOT=/data/local/debian/
    export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH
    export HOME=/root
    #mount -t ext3 /dev/block/vold/179:2 /data/local/debian/
    mount -t ext3 $SDDEVICEBLOCK /data/local/debian/
    for f in dev dev/pts proc sys ; do mount -o bind /$f $ROOT/$f ; done
    chroot $ROOT /etc/init.d/ssh start
