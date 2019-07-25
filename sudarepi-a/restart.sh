#!/bin/sh
set -eu
sudo docker container restart cube_adapter
sudo docker container restart xproxy
