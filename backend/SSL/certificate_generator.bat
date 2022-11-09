openssl genrsa -des3 -out private.key 4096
openssl req -key private.key -new -x509 -days 365 -out certificate.crt