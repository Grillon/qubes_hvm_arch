git clone --recursive https://github.com/QubesOS/qubes-vmm-xen
git clone --recursive https://github.com/QubesOS/qubes-linux-utils
git clone --recursive https://github.com/QubesOS/qubes-core-qubesdb
git clone --recursive https://github.com/QubesOS/qubes-core-agent-linux
git clone --recursive https://github.com/QubesOS/qubes-gui-agent-linux
cd qubes-vmm-xen
cp archlinux/PKGBUILD .
makepkg -s
pacman -U 
