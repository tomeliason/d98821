#!/bin/bash
#
#
#
echo "Generating RSA Keys"
echo "Cleaning up old rsa keys"
rm -rf ~/.ssh/id_rsa
rm -rf ~/.ssh/id_rsa.pub

echo "Generating new RSA keys"
echo -ne '\n\n\n' | ssh-keygen -b 2048 -t rsa

echo "Generated RSA keys"
cat ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub
echo 