monhostname=fullarch
home=/dev/xvdb
boot=/dev/xvda1
root=/dev/xvda2
bootdisk=/dev/xvda
ip=10.137.2.21
gateway=10.137.2.1
mask=24
dev=eth0
dns1=10.137.2.1
locale=fr_FR.UTF-8
timezone=Europe/Paris
keymap=fr
chroot=/mnt/
base_packages="base base-devel"
user=thierry
packages_after_install="vim tmux sudo git"