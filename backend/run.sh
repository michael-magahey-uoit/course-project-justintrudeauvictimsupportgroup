#!/bin/bash

#The & symbol allows 2 commands to be executed by the webserver at the same time.
#This is because we require ngrok to do our proxying so that our webserver isnt
#hampered by network firewalls by my apartment, which has every device VLANed from
#each other.

sudo npm install -g localtunnel
npm install
lt --port 9110 &
node index.js
