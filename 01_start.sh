#!/usr/bin/env bash
echo "contruire le minimum vital : /;/boot;/home"
echo "les referencer sur info_build.sh"
echo "est-ce OK? - CTRL+C sinon"
read a
. info_build.sh
e2label $root root
e2label $boot boot
e2label $home home
mount $root /mnt
mkdir /mnt/{boot,home}
mount $boot /mnt/boot
mount $home /mnt/home
echo "arbo nommee et montee"
exit 0
