#!/bin/bash

# Update system
sudo /bin/bash <<EOF
dnf update -y
dnf install wget -y
EOF

# Download necessary files (done as non-privileged user)
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip

sudo /bin/bash <<EOF
# Configure RPM Fusion repos
dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

# Install proprietary NVIDIA driver - comment out if not needed
dnf update -y
dnf install akmod-nvidia -y
until modinfo -F version nvidia | grep -m 1 -q -v "ERROR";
do
  echo "Still waiting for module to build. Please wait..."
  sleep 5
done

# Install packages
dnf install sddm bspwm sxhkd rofi polybar picom thunar lxpolkit fontawesome-fonts fontawesome-fonts-web vim lxappearance unzip firefox neofetch alsa-utils copyq terminator flameshot nitrogen -y

# Install fonts
unzip FiraCode.zip -d /usr/share/fonts
unzip Meslo.zip -d /usr/share/fonts
# Reload system fonts
fc-cache -vf
rm ./FiraCode.zip ./Meslo.zip

# Enable SDDM
systemctl enable sddm
systemctl set-default graphical.target
EOF

# Make folders and move files to those folders (done as non-privileged user)
mkdir ~/.config
chown $(whoami): ~/.config
mv ./dotconfig/* ~/.config
mv ./bg.jpg ~/.config
mv ./xfiles/xinitrc ~/.xinitrc
mv ./xfiles/Xnord ~/.Xnord
mv ./xfiles/xprofile ~/.xprofile
mv ./xfiles/Xresources ~/.Xresources
