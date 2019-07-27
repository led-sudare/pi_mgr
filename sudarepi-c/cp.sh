#!/bin/sh
set -eu

echo "copy files.."
sshpass -f ./password.txt rsync -av --exclude='.git' ./sudarepi-c/sudare_sim/ pi@sudarepi-c.local:~/sudare_sim/
