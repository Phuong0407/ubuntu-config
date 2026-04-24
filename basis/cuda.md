# CUDA Development Stack

## NVIDIA Driver 535 Installation Guide

### Prerequisites

#### what driver is currently running?

nvidia-smi 2>/dev/null | head -n 4

#### what NVIDIA packages are installed?

dpkg -l | grep nvidia-driver

#### what does Ubuntu recommend?

ubuntu-drivers devices

#### check kernel version

uname -r
dpkg -l | grep "linux-headers-$(uname -r)"

#### if missing, install:

sudo apt-get install -y "linux-headers-$(uname -r)"

### Installation Steps

#### Backup current configuration

##### backup X11 config

sudo cp /etc/X11/xorg.conf /etc/X11/xorg.conf.backup 2>/dev/null || true

##### backup NVIDIA modprobe settings

sudo cp -r /etc/modprobe.d /etc/modprobe.d.backup 2>/dev/null || true

#### Remove conflicting drivers

##### check what's installed

dpkg -l | awk '/^ii/ && /nvidia-driver-[0-9]+/ {print $2}'

##### remove other driver version

sudo apt-get purge 'driver name'
sudo apt-get autoremove -y

### Install Driver 535

#### install

sudo apt-get update
sudo apt-get install -y nvidia-driver-535

#### verify installation

##### check package is installed

dpkg -l | grep nvidia-driver-535

##### check DKMS module status

sudo dkms status

### Post-installation verification

nvidia-smi
lspci | grep -i nvidia
lsmod | grep nvidia

## Install CUDA Toolkit

go to the website
https://developer.nvidia.com/cuda-toolkit-archive
