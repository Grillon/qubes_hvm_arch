#!/usr/bin/env bash

<<=cut

=pod

=encoding utf-8 

=head1 Name

libError

=head1 Description

Error handling and debug library. To use it just source it on the begining of your script.

=head1 Dependencies

no dependencies.

=head1 Functions

=head2 debug

in adding to each of your functions these two lines : 

$MODE_DEBUG
eval $HEADER

=over 4

=item MODE_DEBUG

0 : normal mode

1 : as set -x

2 : as set -xv

just put $MODE_DEBUG to each fonctions and you could debug on purpose from your main program.

=item eval $HEADER

HEADER="typeset maFonction=\"\${aGras}\${0}\${dGras} -\";typeset mf=\"\${maFonction}(\$1)\"";

as you can see give you function and first arg.

maybe be something like $0 shift then $@ would be better???

=back

=head2 erreur

means error in french

define theses variables on first load :

OK=0;
KO=1;
ECONT=1;
ESTOP=251;

usage : 

 C<ls my_file>
 C<erreur $? "mesage" $ECONT "COMMAND">

erreur take the first arg, 

=over 4

=item * 

if it's equal to 0 it return 0 with the message and OK

=item * 

else take the third arg $ECONT means continue on error $ESTOP means stop on error.
before stoping or continue it start COMMAND. COMMAND is optionnal

=back

=head3 here few exemples

=head4 case1 : no error

 C<ls my_file>
 C<erreur $? "presence fichier my_file" $ECONT "ls .">

ls returns 0, so erreur return a message : B<myhostname - 0211 17:21 - myprogram(myfunction):  presence fichier my_file  OK>

=head4 case2 : continue on error

same exemple :

 C<ls my_file>
 C<erreur $? "presence fichier my_file" $ECONT "ls .">

ls return 2 : file not found. so erreur keep the return code of ls I mean 2. then execute the forth arg, in our exemple it's "ls .".finally return 2 with the message B<myhostname - 0211 17:28 - : myprogram(myfunction) presence fichier my_file  KO>

=head4 case3 : no action on error

the same as explained before without execution of the forth argument because you omited it.

=head4 case4 : stop on error with action

 C<ls my_file>
 C<erreur $? "presence fichier my_file" $ESTOP "ls .">

as you can see I put $ESTOP instead of $ECONT witch mean please stop on error. The forth arg is executed before the program exit.

=head1 Author

Grillon


=cut
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
libError=1;
