#!/usr/bin/env bash
. ./info_build.sh
. ./libsh/libG.sh
initCouleur
. ./libsh/libError.sh
erreur $(((libError-1)*-1)) "chargement libError.sh" $ESTOP
echo "au programme :"
action1="- ajout utilisateur : $user et $xuser"
action2="- installation package : $packages_after_install"
action2_1="-a ajout sudoers"
action3="- construction univers qubes"
for action in "$action1" "$action2" "$action3"
do
	echo $action
done
echo "ok? sinon CTRL+C"
read a
useradd -m -G wheel $user
useradd -m $xuser
erreur $? "$action1" $ECONT
sed -i 'N;/multilib[^-]/s/#\(\S\)/\1/g' /etc/pacman.conf
erreur $? "ajout multilib" $ESTOP
pacman -Sy
pacman -S $packages_after_install --noconfirm --needed
erreur $? "$action2" $ECONT
sed -i 's/# \(%wheel ALL=(ALL) ALL\)/\1/' /etc/sudoers
erreur $? "ajout wheel to sudoers" $ECONT
erreur $KO "$action3 - non implemente" $ESTOP
