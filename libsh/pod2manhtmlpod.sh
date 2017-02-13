#!/usr/bin/env bash
. libError.sh
debug 0
#if [ $# -ne 1 ];then
	#echo "veuillez fournir un nom de fichier sh contenant du pod en argument"
	#exit 1
#elif [ "${1#*.*sh}" != "" ];then
	#echo "je n'accepte que les fichiers .bash .ksh .sh en argument pour le moment"
	#exit 2
#fi
for file in *.*sh
do
	destinations=docs/${file%.sh}

	destination=${destinations}.pod
	./extract_pod.sh $file > ${destination}
	erreur $? "conversion $file" $ECONT "rm $destination;continue"

	destination=${destinations}.html
	pod2html $file > ${destination}
	erreur $? "conversion $file" $ECONT "rm $destination;continue"

	destination=${destinations}.man
	pod2man $file > ${destination}
	erreur $? "conversion $file" $ECONT "rm $destination;continue"
done
