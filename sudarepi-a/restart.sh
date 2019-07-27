#!/bin/sh
set -eu
echo "restarting.. " && sudo docker container restart cube_adapter
echo "restarting.. " && sudo docker container restart xproxy
