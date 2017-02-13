#!/usr/bin/env bash
. ./info_build.sh
echo "ATTENTION : je supprime /boot et / mais pas /home"
echo "OK? sinon CTRL+C"
read a
umount /mnt/boot
umount /mnt/home
umount /mnt
mkfs.ext2 $boot
mkfs.ext4 $root
echo "finito"
exit 0
