#!/usr/bin/env bash
echo "au programme :"
action1="- ajout utilisateur : $user"
action2="- installation package : $packages_after_install"
action2_1="-a ajout sudoers"
action3="- construction univers qubes"
for action in "$action1" "$action2" "$action3"
do
	echo $action
done
echo "ok? sinon CTRL+C"
read a
. ./info_build.sh
. ./libsh/libG.sh
initCouleur
. ./libsh/libError.sh
erreur $(((libError-1)*-1)) "chargement libError.sh" $ESTOP
./net.sh
useradd -m -G wheel $user
erreur $? "$action1" $ECONT
pacman -Sy
pacman -S $packages_after_install --noconfirm --needed
erreur $? "$action2" $ECONT
sed -i 's/# \(%wheel ALL=(ALL) ALL\)/\1/' /etc/sudoers

erreur $KO "$action3 - non implemente" $ESTOP
