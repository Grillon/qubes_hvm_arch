#!/usr/bin/env bash
. ./info_build.sh
. ./libsh/libG.sh
initCouleur
. ./libsh/libError.sh
erreur $(((libError-1)*-1)) "chargement libError.sh" $ESTOP
for fs in $boot $home $root
do
	umount $fs
	erreur $? "demontage $fs" $ESTOP
done
echo "fs demontes"
echo "tapez reboot pour rebooter"
exit 0
