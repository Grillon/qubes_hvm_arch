. ./info_build.sh
echo "n'oubliez pas ~/install.txt"
loadkeys $keymap
./net.sh
echo "clavier en francais"
echo "chargement lib err"
if [ ! -e libsh ];then
wget https://github.com/Grillon/libsh/archive/master.zip
unzip master.zip
mv libsh-master libsh
if [ $? -ne 0 ];then
	echo "veillez a bien telecharger libsh sur wget https://github.com/Grillon/libsh/archive/master.zip"
fi
fi
exit 0
