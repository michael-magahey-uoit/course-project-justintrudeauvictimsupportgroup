del private.key
del certificate.crt
openssl genrsa -des3 -out private.key 2048
openssl req -key private.key -new -x509 -days 365 -out certificate.crt