#!/usr/bin/env bash
. ./info_build.sh
. ./libsh/libG.sh
initCouleur
. ./libsh/libError.sh
erreur $(((libError-1)*-1)) "chargement libError.sh" $ESTOP
./03_inside_chroot_part1.sh
erreur $? "part 03" $ESTOP
./04_inside_chroot_part2.sh
erreur $? "part 04" $ESTOP
./05_after_reboot.sh
erreur $? "part 05" $ESTOP
./06_locales_and_qubes_keys.sh
erreur $? "part 06" $ESTOP
./07_packages_optionnels
erreur $? "part 07" $ESTOP
cp makepkg_for_chroot /usr/bin
su - thierry -c './build_qubes.sh'
