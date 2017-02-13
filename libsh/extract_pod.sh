#!/usr/bin/env bash
if [ $# -ne 1 ];then
	echo "please give the name of shell script with pod inside as arg"
	exit 1
fi
pod_file=$1
grep -q '^<<=cut' $pod_file
if [ $? -ne 0 ];then
	echo "ce n'est pas un shell contenant du pod"
	echo "ou alors il ne correspond pas au format attendu"
	exit 1
fi

fin=$(grep -n '^=cut' $pod_file)
fin=${fin%:*}
debut=$(grep -n '^<<=cut' $pod_file)
debut=${debut%:*}
ensemble=$((fin - debut))
head -$fin $pod_file | tail -$ensemble 
