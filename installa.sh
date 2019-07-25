#!/bin/sh
set -eu

echo "** install agent.. **"
sshpass -f ./password.txt ssh pi@sudarepi-a.local 'bash -s' < ./common/build_agent.sh

echo "** install components.. **"
./sudarepi-a/cp.sh
sshpass -f ./password.txt ssh pi@sudarepi-a.local 'bash -s' < ./sudarepi-a/build.sh
