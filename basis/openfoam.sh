#!/usr/bin/env bash
set -euo pipefail

echo "adding OpenFOAM Foundation repository key..."
sudo sh -c 'wget -O - https://dl.openfoam.org/gpg.key > /etc/apt/trusted.gpg.d/openfoam.asc'

echo "adding OpenFOAM Foundation repository..."
sudo add-apt-repository -y http://dl.openfoam.org/ubuntu

echo "updating apt package index..."
sudo apt update

echo "installing OpenFOAM 13..."
sudo apt -y install openfoam13

echo "adding OpenCFD Debian repository..."
curl -s https://dl.openfoam.com/add-debian-repo.sh | sudo bash

echo "updating apt package index again..."
sudo apt-get update

echo "installing OpenFOAM 2512 default package..."
sudo apt-get install -y openfoam2512-default

echo "done."
