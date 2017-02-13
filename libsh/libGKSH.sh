#!/usr/bin/env ksh
#variable
OK=0;
KO=1;
ECONT=1;
ESTOP=251;

#commandes
cAwk=${cAwk:=awk}

#titre fonction plus arg1
HEADER="typeset maFonction=\"\${aGras}\${0}\${dGras} -\";typeset mf=\"\${maFonction}(\$1)\"";

#HEADERS
#= verification du nombre d'arguments
#if [ $# -ne 1 ];then erreur $KO "$0 : nombre d'argument incorrects" $ECONT;fi
#= initialisation du debug level
#$MODE_DEBUG

#= titre de la fonction
#typeset maFonction="${aGras}${0}${dGras} -";
#= sous ensemble de la fonction
#typeset mf="${maFonction}($1)"
#- cela peut être remplacé par eval $HEADER


function debug
{
eval $HEADER
if [ $# -ne 1 ];then erreur $KO "$0 : nombre d'argument incorrects" $ECONT;fi
case $1 in
0) MODE_DEBUG=""
	;;
1)	MODE_DEBUG="set -x"
	;;
2)	MODE_DEBUG="set -xv"
	;;
*)	erreur $KO "$0 : argument $1 invalides" $ECONT
	MODE_DEBUG="set -xv"
	return 1
	;;
esac
return 0
}
function cluster {
eval $HEADER
for clCommand in cmviewcl clustat
do 
	whence $clCommand
	if [ $? -eq 0 ];then 
		return 0;
	fi
done
return 1;
}

function typeDeMontage {
eval $HEADER
if [ $# -ne 1 ];then erreur $KO "$0 : nombre d'argument incorrects" $ECONT;fi
typeset ptm=$1;
if [ $(uname) = AIX ];then
typeset aff=$(mount | grep $ptm | awk '{print $3}')
if [[ $aff = +(/*) ]];then
typeset aff=$(mount | grep $ptm | awk '{print $4}')
fi
else 
typeset aff=$(mount -v | grep $ptm | cut -d" " -f5)
fi
echo $aff
}

function fichierPresent {
$MODE_DEBUG;
eval $HEADER
if [ $# -ne 1 ];then
	erreur $KO "$mf nombre d'arguments invalides" $ECONT
	return 1;
fi
if [ ! -a $1 ];then
	erreur $KO "$mf arguments inexistant" $ECONT
	return 1;
fi
return 0;
}
function fichierExecutable {
$MODE_DEBUG
eval $HEADER
if [ $# -ne 1 ];then erreur $KO "$mf nombre d'argument incorrects" $ECONT;fi
if [ -e $1 ];then return 0
else return 1
fi
}
function fichierInPath {
$MODE_DEBUG
eval $HEADER
if [ $# -ne 1 ];then erreur $KO "$mf nombre d'argument incorrects" $ECONT;fi
whence $1
if [ $? -eq 0 ];then return 0
else return 1
fi
}
function checkPath  {
$MODE_DEBUG
eval $HEADER
if [ $# -ne 1 ];then
 erreur $KO "${mf} nombre d'arguments invalides" $ESTOP
fi
typeset executables=$1;
for executable in $(echo "$executables")
do
 if [ -x "$executable" ];then
  echo $executable;
  return 0;
 fi
done

return 1;
}
function entierValide
{
eval $HEADER
if [ $# -ne 1 ];then erreur $KO "$mf nombre d'argument incorrects" $ECONT;fi
return $(echo "$1" | $cAwk '{if ($0 ~ /^[0-9]+$/) {print "0"} else print "1"}')
}
function decimalValide
{
eval $HEADER
if [ $# -ne 1 ];then erreur $KO "$mf nombre d'argument incorrects" $ECONT;fi
return $(echo "$1" | $cAwk '{if ($0 ~ /^[0-9]+\.[0-9]+$/) {print "0"} else print "1"}')
}
function IPValide
{
eval $HEADER
if [ $# -ne 1 ];then erreur $KO "$mf nombre d'argument incorrects" $ECONT;fi
return $(echo "$1" | $cAwk '{if ($0 ~ /^[0-2]?[0-9]?[0-9]\.[0-2]?[0-9]?[0-9]\.[0-2]?[0-9]?[0-9]\.[0-2]?[0-9]?[0-9]$/) {print "0"} else print "1"}')
}
function hostValide
{
eval $HEADER
if [ $# -ne 1 ];then erreur $KO "$mf nombre d'argument incorrects" $ECONT;fi
return $(echo "$1" | $cAwk '{if ($0 ~ /^[a-zA-Z_-\.0-9]+$/) {print "0"} else print "1"}')
}
function alNumValide
{
eval $HEADER
if [ $# -ne 1 ];then erreur $KO "$mf nombre d'argument incorrects" $ECONT;fi
return $(echo "$1" | $cAwk '{if ($0 ~ /^[a-zA-Z0-9]+$/) {print "0"} else print "1"}')
}
function stopCouleur
{
eval $HEADER
unset esc tRouge tBlanc fRouge aGras tVert tNoir fVert dGras raz;
}
function initCouleur
{
eval $HEADER
#usage : initCouleur (charge des variable portant les code ANSI de couleurs)
#ensuite il suffit d'entourer le texte comme avec du html
#tCouleur pour le texte et fCouleur pour le fond; a pour activation; d pour desactivation; raz pour revenir
#a l'etat d'origine
#cette fonction vient tout droit de wicked cool shell script;
$MODE_DEBUG
esc=""
tRouge="${esc}[31m";    tVert="${esc}[32m"
tBlanc="${esc}[37m";    tNoir="${esc}[30m"
fRouge="${esc}[41m";    fVert="${esc}[42m"
aGras="${esc}[1m";    dGras="${esc}[22m"
raz="${esc}[0m"
}
function erreur
{
$MODE_DEBUG
eval $HEADER
#erreur devient complexe
#arg 1 : numero d'erreur;
#arg 2 : message;
#arg 3 : code erreur(de 251 ` 254), $ECONT pour continuer, $ESTOP pour arret;
#args 4 : fonction ` appeller en cas d'erreur avant sortie

typeset codeRetourE=$1
typeset message=$2
typeset codeRetourS=$3
typeset date=$(date "+%m%d %H:%M")

if [ $codeRetourE -ne 0 ];then
	echo "${aGras} $(uname -n) ${dGras} - $date - : ${tRouge} $message ${fRouge}${tBlanc} KO ${raz}" >&2
	if [ -n "$4" ];then
		typeset action=$4
		eval $action
		ERREUR=$?
	fi
	if [ $codeRetourS -ge 251 ];then
		exit $codeRetourS
	fi
	return $codeRetourE;
else
echo "${aGras} $(uname -n) ${dGras}  - $date - : ${tVert} $message ${fVert}${tNoir} OK ${raz}"
return $OK;
fi
}
#initCouleur
#ident lib
libG=1;
