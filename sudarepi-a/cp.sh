#!/bin/sh
set -eu

echo "copy files.."
sshpass -f ./password.txt rsync -av --exclude='.git' ./sudarepi-a/cube_adapter/ pi@sudarepi-a.local:~/cube_adapter/
sshpass -f ./password.txt rsync -av --exclude='.git' ./sudarepi-a/xproxy/ pi@sudarepi-a.local:~/xproxy/
