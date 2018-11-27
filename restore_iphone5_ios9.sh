#!/bin/bash
dpkg -i /dualbootstuff.deb
rm /dualbootstuff.deb
mkdir /mnt1 
mkdir /mnt2
# Check the file systems and mount them.
fsck_hfs -fy /dev/disk0s1s1
fsck_hfs -fy /dev/disk0s1s2 && mount -t hfs /dev/disk0s1s1 /mnt1 && cp -a /mnt1/etc/fstab /var 
mkdir /var/Mav5
cp -a /mnt1/usr/local/standalone/firmware/Baseband/Mav5/* /var/Mav5
cp -a /mnt1/System/Library/Caches/apticket.der /
umount /mnt1
umount /mnt1
# Edit the partition table to make room for the file system that we'll flash using asr later.
system_size="$((<system_partition_size>+<system_partition_padding>))"
systemsize="$(($system_size*1024*1024/4096+5))"
(echo -e "d\n1\nd\n2\nn\n\1\n\n$systemsize\n\nn\n2\n\n\n\nc\n2\nData\nx\na\n2\n48\n49\n\nw\nY\n")  | gptfdisk /dev/rdisk0s1
sync
sync
sync && (echo -e "d\n1\nn\n\1\n\n\n\nd\n2\n\nn\n2\n\n\n\nc\n1\nSystem\nc\n2\nData\nx\na\n2\n48\n49\n\nw\nY\n")  | gptfdisk /dev/rdisk0s1
sync
sync
sync
# Erase the file systems using newfs_hfs.
newfs_hfs -s -v System -J /dev/disk0s1s1 && newfs_hfs -s -v Data -J -P /dev/disk0s1s2 && fsck_hfs -fy /dev/disk0s1s1 && fsck_hfs -fy /dev/disk0s1s2
# Flash the file system.
asr restore -source /var/UDZO.dmg -target /dev/disk0s1s1 -erase -noprompt -puppetstrings && fsck_hfs -fy /dev/disk0s1s1 && mount -t hfs /dev/disk0s1s1 /mnt1 && fsck_hfs -fy /dev/disk0s1s2 && mount -t hfs /dev/disk0s1s2 /mnt2 && cd /usr/local/standalone/firmware/Baseband/Mav5/ && mkdir -p /mnt1/usr/local/standalone/firmware/Baseband/Mav5 && cp -a /var/Mav5/* /mnt1/usr/local/standalone/firmware/Baseband/Mav5 && mv -v /mnt1/private/var/* /mnt2 && cp -a /var/fstab /mnt1/etc && umount /mnt2 && mount -t hfs /dev/disk0s1s2 /var && fixkeybag && umount -f /var && mount -t hfs /dev/disk0s1s2 /mnt2 && mv /apticket.der /mnt1/System/Library/Caches && mv /kernelcache /mnt1/System/Library/Caches/com.apple.kernelcaches && echo Cleaning up... && rm -rf /var/UDZO.dmg &&
mv /mnt1/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/Support/softwareupdateservicesd /mnt1/System/Library/PrivateFrameworks/SoftwareUpdateServices.framework/ && cd /mnt2/mobile/Media
cp -a /iBSS /usr/bin/hfs_resize /usr/bin/kloader .
./hfs_resize
./kloader
# Destroy partitions made by CoolBooter and use kloader to jump to a pwned iBEC.
used_size="$(df -B1 | sed -n -e 's/^.*\/dev\/disk0s1s1 //p'| sed -e 's/^[ \t]*//' | sed 's/[^ ]* //' | sed 's/ .*//')"
system_size2="$(($used_size+<system_partition_padding_bytes>))"
new_system_size="$(($system_size2/4096 + 5))"
System_GUID="$((echo -e "i\n1\nq")  |  gptfdisk /dev/rdisk0s1 | sed -n -e 's/^.*Partition unique GUID: //p')"
Data_GUID="$((echo -e "i\n2\nq")  |  gptfdisk /dev/rdisk0s1 | sed -n -e 's/^.*Partition unique GUID: //p')"
(echo -e "d\n1\nd\n2\nd\n3\nd\n4\nn\n1\n\n$new_system_size\n\nc\nSystem\nn\n2\n\n\n\nc\n2\nData\nx\na\n2\n48\n49\n\nc\n1\n$System_GUID\n\nc\n2\n$Data_GUID\nw\nY\n")  | gptfdisk /dev/rdisk0s1
data_size="$((echo -e "i\n2\nq")  | gptfdisk /dev/rdisk0s1 | sed -n -e 's/^.*Partition size: //p' | sed 's/ .*//')"
data_size2="$(($data_size-5))"
new_data_size="$(($data_size2*4096))"
./hfs_resize /mnt1 $system_size2; ./hfs_resize /mnt2 $new_data_size; ./kloader iBSS

