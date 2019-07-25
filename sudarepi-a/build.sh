#!/bin/sh
set -eu

cd cube_adapter
sudo ./dockerbuildpi.sh

cd ../xproxy
sudo ./dockerbuildpi.sh
