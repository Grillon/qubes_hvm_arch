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
useradd -m -G wheel $user
erreur $? "$action1" $ECONT
sed -i 'N;/multilib[^-]/s/#\(\S\)/\1/g' /etc/pacman.conf
erreur $? "ajout multilib" $ESTOP
pacman -Sy
pacman -S $packages_after_install --noconfirm --needed
erreur $? "$action2" $ECONT
sed -i 's/# \(%wheel ALL=(ALL) ALL\)/\1/' /etc/sudoers

erreur $KO "$action3 - non implemente" $ESTOP
pacman-key --init
pacman-key --populate
pacman-key --recv-key 2043E7ACC1833B9C
pacman-key --finger 2043E7ACC1833B9C
pacman-key --lsign-key 2043E7ACC1833B9C
erreur $? "signature de la cle 2043E7ACC1833B9C" $ESTOP
