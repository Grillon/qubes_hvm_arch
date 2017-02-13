echo "je considere que la date est bonne par defaut"
echo "no prise de tete c'est pour installer de la vm"
. ./info_build.sh
. ./libsh/libG.sh
initCouleur
. ./libsh/libError.sh
erreur $(((libError-1)*-1)) "chargement libError.sh" $ESTOP
echo "installation des packages de base"
pacstrap $chroot $base_packages
erreur $? "installation des packages $base_packages sur $chroot" $ESTOP
genfstab -L $chroot >> ${chroot}etc/fstab
erreur $? "creation fstab" $ESTOP
ici=$(pwd)
cp -R $ici $chroot
erreur $? "copie de $ici vers $chroot" $ESTOP
echo "veuilez lancer arch-chroot $chroot"
exit 0
