#!/usr/bin/env bash

<<=cut

=pod

=encoding utf-8

=head1 Name

libTest.sh

=head1 Description

Test library. aide à tester le comportement d un script dans un environnement maitrise.

=head1 Dependencies

libError.sh

=head1 Functions

=head2 assert_return_code

assert_return_code "COMMAND" "EXPECTED_RETURN_CODE"

 RETURN 0 if EXPECTED_RETURN_CODE == RETURN_CODE
 RETURN 1 othewise

in both case there are a message of type

B<hostname - date time - program -(function_tested) return_code;expected_return_code state>

tel que :

myhost - 0211 15:39 - :  ./test.sh -(ls) code retour:0 ; attendu:1  KO 

=head2 assert_return_err

TODO : verify stderr

=head2 assert_return_message

TODO : verify stdout

=head1 Author

Grillon

=cut

#dependancy
if [ ! "$libError" ];then
	echo "lib de gestion d'erreur manquante" >&2
	exit 1
fi

function assert_return_code {
eval $HEADER
typeset cmd=$1
typeset code_expected=$2
typeset code_obtained
typeset result
$cmd &>/dev/null
code_obtained=$?
if [ "${code_obtained}" -eq "${code_expected}" ];then
	result=$OK
else
	result=$KO
fi
erreur "${result}" "$mf code retour:${code_obtained} ; attendu:${code_expected}" $ECONT
}
function assert_return_err {
echo "TODO"
}
function assert_return_message {
echo "TODO"
}
