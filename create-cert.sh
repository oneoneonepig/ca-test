#!/bin/bash
# script name: create-cert.sh
# created by: oneoneonepig
# date: 2021/5/9
# modified from: https://deliciousbrains.com/ssl-certificate-authority-for-local-https-development/

sign_cert () {

DOMAIN=$1

openssl genrsa -out $DOMAIN.key 2048
openssl req -new -key $DOMAIN.key -out $DOMAIN.csr -subj /C=TW/ST=Taiwan/L=Taipei/CN=$DOMAIN/ -batch

cat > $DOMAIN.ext << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
authorityInfoAccess = caIssuers;URI:http://replace.with.your.domain/ca.pem
subjectAltName = @alt_names
[alt_names]
DNS.1 = $DOMAIN
EOF

openssl x509 -req -in $DOMAIN.csr -CA ca.pem -CAkey ca.key -CAcreateserial -out $DOMAIN.pem -days 365 -sha256 -extfile $DOMAIN.ext
rm $DOMAIN.csr
rm $DOMAIN.ext
}

sign_subca_cert () {

SUBCA=$1
CA=$2

openssl genrsa -out $SUBCA.key 2048
openssl req -new -key $SUBCA.key -out $SUBCA.csr -subj /C=TW/ST=Taiwan/L=Taipei/CN=$SUBCA/ -batch

cat > $SUBCA.ext << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:TRUE
keyUsage = digitalSignature, cRLSign, keyCertSign
authorityInfoAccess = caIssuers;URI:http://replace.with.your.domain/$CA.pem
subjectAltName = @alt_names
[alt_names]
DNS.1 = $SUBCA
EOF

openssl x509 -req -in $SUBCA.csr -CA $CA.pem -CAkey $CA.key -CAcreateserial -out $SUBCA.pem -days 365 -sha256 -extfile $SUBCA.ext

rm $SUBCA.csr
rm $SUBCA.ext

}

usage () {
	echo "Usage: $0 CertName"
	echo "Usage: $0 SubCAName CAName"
}

if [ "$#" -eq 1 ]; then
	sign_cert $1
elif [ "$#" -eq 2 ]; then
	sign_subca_cert $1 $2
else
	usage
	exit 1
fi 


