#!/usr/bin/env bash
. ./info_build.sh
. ./libsh/libG.sh
initCouleur
. ./libsh/libError.sh
erreur $(((libError-1)*-1)) "chargement libError.sh" $ESTOP
base=$(pwd)
if [ -e /usr/bin/makepkg_for_chroot ];then
	export makepkg=makepkg_for_chroot
else
	export makepkg=makepkg
fi
export BACKEND_VMM=xen
liste_pkg="qubes-vmm-xen qubes-core-vchan-xen qubes-core-qubesdb qubes-linux-utils qubes-core-agent-linux qubes-gui-common"
gui_pkg="qubes-gui-agent-linux"

function clone_depot {
	git clone --recursive https://github.com/QubesOS/${depot}
}
function build_pkgs {
	cd ${depot}
	cp archlinux/* .
	md5sums=$(makepkg -g)
	md5sums=$(echo ${md5sums} | sed 's/\n//g')
	sed -i "s/md5sums=.*/${md5sums}/" PKGBUILD
	if [ "${depot}" == "$gui_pkg" ];then
		sudo -S pacman -Sy --noconfirm
		erreur $? "maj pacman db" $ESTOP
	fi
	$makepkg -s --noconfirm
}
function prepare {
	if [ ${depot} == "qubes-vmm-xen" ];then
		cp ./xen-4.6.4.tar.gz ${depot}
	fi
}
function install_pkgs {
	for pkg in $(ls *xz)
	do
		sudo -S pacman -U $pkg --noconfirm
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
function add_rw_to_fstab {
	sudo -S sed -i 's#LABEL=home          	/home     	ext4      	rw,relatime,data=ordered	0 2#LABEL=home          	/rw     	ext4      	rw,relatime,data=ordered	0 2\
/rw/home         	/home     	ext4      	bind,defaults,noauto 0 0#' /etc/fstab
	erreur $? "ajout de /rw/home" $ECONT
}

for depot in $liste_pkg $gui_pkg
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
add_rw_to_fstab
