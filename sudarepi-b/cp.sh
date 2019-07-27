#!/bin/sh
set -eu

echo "copy files.."
sshpass -f ./password.txt rsync -av --exclude='.git' ./sudarepi-b/demos/ pi@sudarepi-b.local:~/demos/
