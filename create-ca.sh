#!/bin/bash

openssl genrsa -out ca.key 2048
openssl req -x509 -new -nodes -key ca.key -sha256 -days 3652 -out ca.pem -subj /C=TW/ST=Taiwan/L=Taipei/CN=RootCA/ -batch
chmod -w ca.pem
chmod -w ca.key
