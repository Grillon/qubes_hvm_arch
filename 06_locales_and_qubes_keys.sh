#!/usr/bin/env bash
. ./info_build.sh
. ./libsh/libG.sh
initCouleur
. ./libsh/libError.sh
erreur $(((libError-1)*-1)) "chargement libError.sh" $ESTOP
sudo locale-gen
erreur $? "generation des locales" $ECONT
sudo pacman-key --init
sudo pacman-key --populate
sudo pacman-key --recv-key 2043E7ACC1833B9C
sudo pacman-key --finger 2043E7ACC1833B9C
sudo pacman-key --lsign-key 2043E7ACC1833B9C
erreur $? "signature de la cle 2043E7ACC1833B9C" $ESTOP
