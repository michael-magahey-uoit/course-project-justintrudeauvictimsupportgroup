#!/bin/bash

rm -f backend.key backend.crt
openssl req -newkey rsa:2048 -nodes -keyout backend.key -x509 -days 365 -out backend.crt
