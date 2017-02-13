#!/usr/bin/env bash
. ./info_build.sh
. ./libsh/libG.sh
initCouleur
. ./libsh/libError.sh
erreur $(((libError-1)*-1)) "chargement libError.sh" $ESTOP
ln -sf /usr/share/zoneinfo/$timezone /etc/localtime
erreur $? "installation timezone $timezone" $ESTOP
hwclock --systohc
erreur $? "configure hwclock" $ESTOP
sed -i "s/#${locale}/${locale}/" /etc/locale.gen
err=$?
echo "LANG=${locale}">/etc/locale.conf
err2=$?
echo "KEYMAP=${keymap}">/etc/vconsole.conf
err3=$?
erreur $((err+err2+err3)) "configuration des locales" $ESTOP
echo "$monhostname">/etc/hostname
err=$?
sed -i "8s/^$/127.0.1.1	$monhostname.localdomain	$monhostname/" /etc/hosts
err2=$?
erreur $((err+err2)) "configuration hostname $monhostmane" $ESTOP
