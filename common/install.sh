#!/bin/sh
set -eu

target=$1
echo "target:" $target

echo "** install agent.. **"
sshpass -f ./password.txt ssh pi@$target.local 'bash -s' < ./common/build_agent.sh

echo "** install components.. **"
./$target/cp.sh
sshpass -f ./password.txt ssh pi@$target.local 'bash -s' < ./$target/build.sh
