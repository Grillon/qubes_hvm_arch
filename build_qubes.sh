#!/usr/bin/env bash
. ./info_build.sh
. ./libsh/libG.sh
initCouleur
. ./libsh/libError.sh
erreur $(((libError-1)*-1)) "chargement libError.sh" $ESTOP
base=$(pwd)
export BACKEND_VMM=xen
liste_pkg="qubes-vmm-xen qubes-core-vchan-xen qubes-core-qubesdb qubes-linux-utils qubes-core-agent-linux qubes-gui-common qubes-gui-agent-linux"

function clone_depot {
	git clone --recursive https://github.com/QubesOS/${depot}
}
function build_pkgs {
	cd ${depot}
	cp archlinux/* .
	md5sums=$(makepkg -g)
	md5sums=$(echo ${md5sums} | sed 's/\n//g')
	sed -i "s/md5sums=.*/${md5sums}/" PKGBUILD
	makepkg -s
}
function prepare {
	if [ ${depot} == "qubes-vmm-xen" ];then
		cp ./xen-4.6.4.tar.gz ${depot}
	fi
}
function install_pkgs {
	for pkg in $(ls *xz)
	do
		sudo pacman -U $pkg
		erreur $? "installation $pkg" $ECONT
	done
}
#function pkgs_to_install {
	#for pkg in $(ls *xz)
	#do
		#built_pkgs="${built_pkgs} ${depot}/${pkg}"
		#erreur $? "ajout $pkg a la liste" $ECONT
	#done
#}
function garbage_command {
	echo "rm -Rf ${liste_pkg}"
}

for depot in $liste_pkg
do
	clone_depot
	prepare
	build_pkgs
	erreur $? "construction des packages" $ESTOP
	install_pkgs
	cd $base
	#pkgs_to_install
done
garbage_command
