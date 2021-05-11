#!/bin/bash

NAME=sub-c-

if [ "$#" -ne 1 ]; then
        echo "Usage: $0 NUM"
        exit 1
fi

is_digit='^[0-9]+$'
if ! [[ $1 =~ $is_digit ]] ; then
	echo "error: Not a number"
	exit 1
fi

for i in `seq 1 $1`; do
	if [ $i -eq 1 ]; then
		echo "first"
		./create-cert.sh $NAME$i ca
	elif [ $i -eq $1 ]; then
		echo "last"
		./create-cert.sh $NAME$1 $NAME`expr $i - 1`
	else
		echo "middle"
		./create-cert.sh $NAME$i $NAME`expr $i - 1`
	fi
done
