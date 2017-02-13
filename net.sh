. ./info_build.sh
. ./libsh/libError.sh
erreur $(((libError-1)*-1)) "chargement libError.sh" $ESTOP
ip link set $dev up
erreur $? "activation de l'interface $dev" $ECONT
ip addr add $ip/$mask dev $dev
erreur $? "configuration de l'interface $dev avec $ip/$mask" $ECONT
ip route add default via $gateway
erreur $? "ajout de la gateway $gateway" $ECONT
sed -i "s/#nameserver <ip>/nameserver $gateway/" /etc/resolv.conf
erreur $? "configuration dns" $ECONT
