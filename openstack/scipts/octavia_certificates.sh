#!/bin/bash
set -euo pipefail

CERT_PASS=foobar
CERT_SUBJECT="/C=US/ST=Somestate/O=Org/CN=www.example.com"

mkdir -p demoCA/newcerts

touch demoCA/index.txt
touch demoCA/index.txt.attr

openssl genrsa -passout pass:$CERT_PASS -des3 -out issuing_ca_key.pem 2048
openssl req -x509 -passin pass:$CERT_PASS -new -nodes -key issuing_ca_key.pem \
    -config /etc/ssl/openssl.cnf \
    -subj "$CERT_SUBJECT" \
    -days 365 \
    -out issuing_ca.pem

openssl genrsa -passout pass:$CERT_PASS -des3 -out controller_ca_key.pem 2048
openssl req -x509 -passin pass:$CERT_PASS -new -nodes \
        -key controller_ca_key.pem \
    -config /etc/ssl/openssl.cnf \
    -subj "$CERT_SUBJECT" \
    -days 365 \
    -out controller_ca.pem
openssl req \
    -newkey rsa:2048 -nodes -keyout controller_key.pem \
    -subj "$CERT_SUBJECT" \
    -out controller.csr
openssl ca -passin pass:$CERT_PASS -config /etc/ssl/openssl.cnf \
    -cert controller_ca.pem -keyfile controller_ca_key.pem \
    -create_serial -batch \
    -in controller.csr -days 365 -out controller_cert.pem

cat controller_cert.pem controller_key.pem > controller_cert_bundle.pem

juju config neutron-api enable-ml2-port-security=True
juju config octavia \
    lb-mgmt-issuing-cacert="$(base64 issuing_ca.pem)" \
    lb-mgmt-issuing-ca-private-key="$(base64 issuing_ca_key.pem)" \
    lb-mgmt-issuing-ca-key-passphrase="$CERT_PASS" \
    lb-mgmt-controller-cacert="$(base64 controller_ca.pem)" \
    lb-mgmt-controller-cert="$(base64 controller_cert_bundle.pem)"
