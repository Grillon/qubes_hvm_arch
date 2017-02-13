#!/usr/bin/env bash
. ./info_build.sh
. ./libsh/libG.sh
initCouleur
. ./libsh/libError.sh
erreur $(((libError-1)*-1)) "chargement libError.sh" $ESTOP
mkinitcpio -p linux
erreur $? "configuration de la l'initramfs" $ECONT
pacman -S grub --noconfirm --needed
erreur $? "installation grub package" $ESTOP
grub-install --target=i386-pc $bootdisk
erreur $? "install grub bootloader to $bootdisk" $ESTOP
grub-mkconfig -o /boot/grub/grub.cfg
erreur $? "generate grub.cfg" $ESTOP
echo "a present veuillez inserer votre mdp root en tapant passwd root"
echo "byebye"
exit 0
