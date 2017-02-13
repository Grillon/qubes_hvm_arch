#!/usr/bin/env bash
function cluster {
eval $HEADER
for clCommand in cmviewcl clustat
do 
	type $clCommand
	if [ $? -eq 0 ];then 
		return 0;
	fi
done
return 1;
}

function fichierPresent {
$MODE_DEBUG;
eval $HEADER
if [ $# -ne 1 ];then
	erreur $KO "$mf nombre d'arguments invalides" $ECONT
	return 1;
fi
if [ ! -e $1 ];then
	erreur $KO "$mf arguments inexistant" $ECONT
	return 1;
fi
return 0;
}
function fichierExecutable {
$MODE_DEBUG
eval $HEADER
if [ $# -ne 1 ];then erreur $KO "$mf nombre d'argument incorrects" $ECONT;fi
if [ -x $1 ];then return 0
else return 1
fi
}
function fichierInPath {
$MODE_DEBUG
eval $HEADER
if [ $# -ne 1 ];then erreur $KO "$mf nombre d'argument incorrects" $ECONT;fi
type $1
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
#initCouleur
#ident lib
libG=1;
