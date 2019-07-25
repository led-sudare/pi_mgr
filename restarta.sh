#!/bin/sh
set -eu

echo "** install components.. **"
./sudarepi-a/cp.sh
sshpass -f ./password.txt ssh pi@sudarepi-a.local 'bash -s' < ./sudarepi-a/restart.sh
