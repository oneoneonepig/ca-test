#!/bin/bash

if [ "$#" -ne 3 ]; then
        echo "Usage: $0 NUM ServerCertName SubCAName"
        exit 1
fi

is_digit='^[0-9]+$'
if ! [[ $1 =~ $is_digit ]] ; then
        echo "error: Not a number"
        exit 1
fi

COMBINED=$2-combined.pem
cat $2.pem >> $COMBINED
for i in `seq $1 -1 1`; do
	cat $3$i.pem >> $COMBINED
done

