#!/bin/bash

####################################################################################################
# Name:         Autodesk Fusion 360 - Setup Wizard (Linux)                                         #
# Description:  With this file you can install Autodesk Fusion 360 on Linux.                       #
# Author:       Steve Zabka                                                                        #
# Author URI:   https://cryinkfly.com                                                              #
# License:      MIT                                                                                #
# Copyright (c) 2020-2021                                                                          #
# Time/Date:    11:00/09.11.2021                                                                   #
# Version:      1.5.6                                                                              #
####################################################################################################

###############################################################################################################################################################
# DESCRIPTION IN DETAIL                                                                                                                                       #
###############################################################################################################################################################
# With the help of my setup wizard, you will be given a way to install Autodesk Fusion 360 with some extensions on                                            #
# Linux so that you don't have to use Windows or macOS for this program in the future!                                                                        #
#                                                                                                                                                             #
# Also, my setup wizard will guides you through the installation step by step and will install some required packages.                                        #
#                                                                                                                                                             #
# The next one is you have the option of installing the program directly on your system or you can install it on an external storage medium.                  #
#                                                                                                                                                             #
# But it's important to know, you must to purchase the licenses directly from the manufacturer of Autodesk Fusion 360, when you will work with them on Linux! #
###############################################################################################################################################################

###############################################################################################################################################################
# ALL FUNCTIONS ARE ARRANGED HERE:                                                                                                                            #
###############################################################################################################################################################

# Records the installation of Autodesk Fusion 360!
# This log file will later help with error analysis to find out why the installation did not work.

function logfile-installation {
   mkdir -p "/$HOME/.local/share/fusion360/logfiles" &&
   exec 5> /$HOME/.local/share/fusion360/logfiles/logfile-installation
   BASH_XTRACEFD="5"
   set -x
}

###############################################################################################################################################################

# It will check whether Autodesk Fusion 360 is already installed on your system or not!

function check-if-fusion360installer-exists {
fusion360_installer="$HOME/Fusion360/data/fusion360/Fusion360installer.exe" # Search for a existing installer of Autodesk Fusion 360
if [ -f "$fusion360_installer" ]; then
    echo "Autodesk Fusion 360 installer exist!"
else
    load-fusion360-installer
fi
}

function check-if-fusion360-exists {
log_path="$HOME/.local/share/fusion360/logfiles/log-path" # Search for log files indicting install
if [ -f "$log_path" ]; then
    cp "$HOME/.local/share/fusion360/logfiles/log-path" data/logfiles
    new_modify_deinstall # Exists - Modify install
else
    logfile_install=1
    select-opengl_dxvk # New install
fi
}

function logfile-installation-standard {
if [ $logfile_install -eq 1 ]; then
    echo "$HOME/.wineprefixes/fusion360" >> $HOME/.local/share/fusion360/logfiles/log-path
fi
}

function logfile-installation-custom {
if [ $logfile_install -eq 1 ]; then
   echo "$custom_directory" >> $HOME/.local/share/fusion360/logfiles/log-path
fi
}

function logfile-installation-flatpak-standard {
if [ $logfile_install -eq 1 ]; then
    echo "$HOME/.local/share/flatpak-wine619/default" >> $HOME/.local/share/fusion360/logfiles/log-path
fi
}

###############################################################################################################################################################

# Create the structure for the installation of Autodesk Fusion 360!

function create-structure {
  mkdir -p data/extensions
  mkdir -p data/fusion360
  mkdir -p data/flatpak
  mkdir -p data/logfiles
  mkdir -p data/locale
  mkdir -p data/locale/cs-CZ
  mkdir -p data/locale/de-DE
  mkdir -p data/locale/en-US
  mkdir -p data/locale/es-ES
  mkdir -p data/locale/fr-FR
  mkdir -p data/locale/it-IT
  mkdir -p data/locale/ja-JP
  mkdir -p data/locale/ko-KR
  mkdir -p data/locale/zh-CN
  mkdir -p data/winetricks
}

###############################################################################################################################################################

# Load the Flatpak-files for the Setup Wizard!

function load-flatpak {
  wget -N -P data/flatpak https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/scripts/development-branch/flatpak-install.sh
  chmod +x data/flatpak/flatpak-install.sh
}

###############################################################################################################################################################

# Load the locale for the Setup Wizard!

function load-locale {
  wget -N -P data/locale https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/scripts/stable-branch/data/locale/locale.sh
  chmod +x data/locale/locale.sh
  . data/locale/locale.sh
}

function load-locale-cs {
  . data/locale/cs-CZ/locale-cs.sh
}

function load-locale-de {
  . data/locale/de-DE/locale-de.sh
}

function load-locale-en {
  . data/locale/en-US/locale-en.sh
}

function load-locale-es {
  . data/locale/es-ES/locale-es.sh
}

function load-locale-fr {
  . data/locale/fr-FR/locale-fr.sh
}

function load-locale-it {
  . data/locale/it-IT/locale-it.sh
}

function load-locale-ja {
  . data/locale/ja-JP/locale-ja.sh
}

function load-locale-ko {
  . data/locale/ko-KR/locale-ko.sh
}

function load-locale-zh {
  . data/locale/zh-CN/locale-zh.sh
}

###############################################################################################################################################################

# Load newest winetricks version for the Setup Wizard!

function load-winetricks {
  wget -N -P data/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
  chmod +x data/winetricks/winetricks
  }

###############################################################################################################################################################

# Load newest Autodesk Fusion 360 installer version for the Setup Wizard!

function load-fusion360-installer {
  wget https://dl.appstreaming.autodesk.com/production/installers/Fusion%20360%20Admin%20Install.exe -O Fusion360installer.exe
  mv Fusion360installer.exe data/fusion360/Fusion360installer.exe
}

###############################################################################################################################################################

# For the installation of Autodesk Fusion 360 one of the supported Linux distributions must be selected! - Part 2

function archlinux-1 {
    echo "Checking for multilib..."
    if archlinux-verify-multilib ; then
        echo "multilib found. Continuing..."
        archlinux-2
        select-your-path
    else
        echo "Enabling multilib..."
        echo "[multilib]" | sudo tee -a /etc/pacman.conf
        echo "Include = /etc/pacman.d/mirrorlist" | sudo tee -a /etc/pacman.conf
        archlinux-2
        select-your-path
    fi
}

function archlinux-2 {
   sudo pacman -Sy --needed wine wine-mono wine_gecko winetricks p7zip curl cabextract samba ppp
}

function archlinux-verify-multilib {
    if cat /etc/pacman.conf | grep -q '^\[multilib\]$' ; then
        true
    else
        false
    fi
}

function debian-based-1 {
    sudo apt-get update
    sudo apt-get upgrade
    sudo dpkg --add-architecture i386
    wget -nc https://dl.winehq.org/wine-builds/winehq.key
    sudo apt-key add winehq.key
}

function debian-based-2 {
    sudo apt-get update
    sudo apt-get upgrade
    sudo apt-get install p7zip p7zip-full p7zip-rar curl winbind cabextract wget
    sudo apt-get install --install-recommends winehq-staging
    select-your-path
}

function ubuntu18 {
    sudo apt-add-repository -r 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main'
    wget -q https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/Release.key -O Release.key -O- | sudo apt-key add -
    sudo apt-add-repository 'deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/ ./'
}

function ubuntu20 {
    sudo add-apt-repository -r 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main'
    wget -q https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_20.04/Release.key -O Release.key -O- | sudo apt-key add -
    sudo apt-add-repository 'deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_20.04/ ./'
}

function ubuntu20_10 {
    sudo add-apt-repository -r 'deb https://dl.winehq.org/wine-builds/ubuntu/ groovy main'
    wget -q https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_20.10/Release.key -O Release.key -O-
    sudo apt-add-repository 'deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_20.10/ ./'
}

function ubuntu21 {
    # Note: This installs the public key to trusted.gpg.d - While this is "acceptable" behaviour it is not best practice.
    # It is infinitely better than using apt-key add though.
    # For more information and for instructions to utalise best practices, see:
    # https://askubuntu.com/questions/1286545/what-commands-exactly-should-replace-the-deprecated-apt-key

    sudo apt update
    sudo apt upgrade
    sudo dpkg --add-architecture i386
    mkdir -p /tmp/360 && cd /tmp/360
    wget https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_21.04/Release.key
    wget https://dl.winehq.org/wine-builds/winehq.key
    gpg --no-default-keyring --keyring ./temp-keyring.gpg --import Release.key
    gpg --no-default-keyring --keyring ./temp-keyring.gpg --export --output opensuse-wine.gpg && rm temp-keyring.gpg
    gpg --no-default-keyring --keyring ./temp-keyring.gpg --import winehq.key
    gpg --no-default-keyring --keyring ./temp-keyring.gpg --export --output winehq.gpg && rm temp-keyring.gpg
    sudo mv *.gpg /etc/apt/trusted.gpg.d/ && cd /tmp && sudo rm -rf 360
    echo "deb [signed-by=/etc/apt/trusted.gpg.d/opensuse-wine.gpg] https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_21.04/ ./" | sudo tee -a /etc/apt/sources.list.d/opensuse-wine.list
    sudo add-apt-repository -r 'deb https://dl.winehq.org/wine-builds/ubuntu/ hirsute main'
}

function ubuntu21_10 {
    # Verify the below repos exist and uncomment this block to replace the above after 21.10 release
    # echo "deb [signed-by=/etc/apt/trusted.gpg.d/opensuse-wine.gpg] https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_21.10/ ./" | sudo tee -a /etc/apt/sources.list.d/opensuse-wine.list &&
    # sudo add-apt-repository -r 'deb https://dl.winehq.org/wine-builds/ubuntu/ impish main' &&

    ubuntu21
}

function fedora-based-1 {
    sudo dnf update
    sudo dnf upgrade
    sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
}

function fedora-based-2 {
    sudo dnf install p7zip p7zip-plugins curl wget wine cabextract
    select-your-path
}

function redhat-linux {
   sudo subscription-manager repos --enable codeready-builder-for-rhel-8-x86_64-rpms
   sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
   sudo dnf upgrade
   sudo dnf install wine
}

function solus-linux {
   sudo eopkg install wine winetricks p7zip curl cabextract samba ppp
}

function void-linux {
   sudo xbps-install -Sy wine wine-mono wine-gecko winetricks p7zip curl cabextract samba ppp
}

function gentoo-linux {
    sudo emerge -nav virtual/wine app-emulation/winetricks app-emulation/wine-mono app-emulation/wine-gecko app-arch/p7zip app-arch/cabextract net-misc/curl net-fs/samba net-dialup/ppp
}

###############################################################################################################################################################

# Here you have to decide whether you want to use Autodesk Fusion 360 with DXVK (DirectX 9) or OpenGL! - Part 2

function configure-dxvk-or-opengl-standard-1 {
  if [ $driver_used -eq 2 ]; then
      WINEPREFIX=/home/$USER/.wineprefixes/fusion360 sh data/winetricks/winetricks -q dxvk &&
      wget -N https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/extras/opengl_dxvk/DXVK.reg &&
      WINEPREFIX=/home/$USER/.wineprefixes/fusion360 wine regedit.exe DXVK.reg
   fi
}

function configure-dxvk-or-opengl-standard-2 {
if [ $driver_used -eq 2 ]; then
      wget -N https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/extras/opengl_dxvk/DXVK.xml &&
      mv DXVK.xml NMachineSpecificOptions.xml
   else
      wget -N https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/extras/opengl_dxvk/OpenGL.xml
      mv OpenGL.xml NMachineSpecificOptions.xml
   fi
}

function configure-dxvk-or-opengl-standard-3 {
if [ $driver_used -eq 2 ]; then
      wget -N https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/extras/opengl_dxvk/DXVK.xml &&
      mv DXVK.xml NMachineSpecificOptions.xml
   else
      wget -N https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/extras/opengl_dxvk/OpenGL.xml
      mv OpenGL.xml NMachineSpecificOptions.xml
   fi
}

function configure-dxvk-or-opengl-custom-1 {
   if [ $driver_used -eq 2 ]; then
      WINEPREFIX=$filename sh data/winetricks/winetricks -q dxvk &&
      wget -N https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/extras/opengl_dxvk/DXVK.reg &&
      WINEPREFIX=$filename wine regedit.exe DXVK.reg
   else
      wget -N https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/extras/opengl_dxvk/OpenGL.xml
      mv OpenGL.xml NMachineSpecificOptions.xml
   fi
}

function configure-dxvk-or-opengl-custom-2 {
if [ $driver_used -eq 2 ]; then
      wget -N https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/extras/opengl_dxvk/DXVK.xml &&
      mv DXVK.xml NMachineSpecificOptions.xml
   else
      wget -N https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/extras/opengl_dxvk/OpenGL.xml
      mv OpenGL.xml NMachineSpecificOptions.xml
   fi
}

function configure-dxvk-or-opengl-custom-3 {
if [ $driver_used -eq 2 ]; then
      wget -N https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/extras/opengl_dxvk/DXVK.xml &&
      mv DXVK.xml NMachineSpecificOptions.xml
   else
      wget -N https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/extras/opengl_dxvk/OpenGL.xml
      mv OpenGL.xml NMachineSpecificOptions.xml
   fi
}

function configure-dxvk-or-opengl-flatpak-standard-1 {
  if [ $driver_used -eq 2 ]; then
      flatpak run org.winehq.flatpak-wine619 winetricks -q dxvk &&
      wget -N https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/extras/opengl_dxvk/DXVK.reg &&
      flatpak run org.winehq.flatpak-wine619 wine regedit.exe DXVK.reg
   fi
}

function configure-dxvk-or-opengl-flatpak-standard-2 {
if [ $driver_used -eq 2 ]; then
      wget -N https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/extras/opengl_dxvk/DXVK.xml &&
      mv DXVK.xml NMachineSpecificOptions.xml
   else
      wget -N https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/extras/opengl_dxvk/OpenGL.xml
      mv OpenGL.xml NMachineSpecificOptions.xml
   fi
}

function configure-dxvk-or-opengl-flatpak-standard-3 {
if [ $driver_used -eq 2 ]; then
      wget -N https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/extras/opengl_dxvk/DXVK.xml &&
      mv DXVK.xml NMachineSpecificOptions.xml
   else
      wget -N https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/extras/opengl_dxvk/OpenGL.xml
      mv OpenGL.xml NMachineSpecificOptions.xml
   fi
}

###############################################################################################################################################################

# Autodesk Fusion 360 will now be installed using Wine and Winetricks! - Standard

function winetricks-standard {
   mkdir -p $HOME/.wineprefixes/fusion360
   WINEPREFIX=$HOME/.wineprefixes/fusion360 sh data/winetricks/winetricks -q corefonts cjkfonts msxml4 msxml6 vcrun2017 fontsmooth=rgb win8
   # We must install cjkfonts again then sometimes it doesn't work the first time!
   WINEPREFIX=$HOME/.wineprefixes/fusion360 sh data/winetricks/winetricks -q cjkfonts
   configure-dxvk-or-opengl-standard-1
   WINEPREFIX=$HOME/.wineprefixes/fusion360 wine data/fusion360/Fusion360installer.exe -p deploy -g -f log.txt --quiet
   WINEPREFIX=$HOME/.wineprefixes/fusion360 wine data/fusion360/Fusion360installer.exe -p deploy -g -f log.txt --quiet
   mkdir -p "$HOME/.wineprefixes/fusion360/drive_c/users/$USER/AppData/Roaming/Autodesk/Neutron Platform/Options"
   cd "$HOME/.wineprefixes/fusion360/drive_c/users/$USER/AppData/Roaming/Autodesk/Neutron Platform/Options"
   configure-dxvk-or-opengl-standard-2
   # Because the location varies depending on the Linux distro!
   mkdir -p "$HOME/.wineprefixes/fusion360/drive_c/users/$USER/Application Data/Autodesk/Neutron Platform/Options"
   cd "$HOME/.wineprefixes/fusion360/drive_c/users/$USER/Application Data/Autodesk/Neutron Platform/Options"
   configure-dxvk-or-opengl-standard-3
   #Set up the program launcher for you!
   rm $HOME/.local/share/applications/wine/Programs/Autodesk/Autodesk\ Fusion\ 360.desktop
   wget -P $HOME/.local/share/applications/wine/Programs/Autodesk https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/extras/desktop-starter/Autodesk%20Fusion%20360.desktop
   rm $HOME/.local/share/fusion360/launcher.sh
   wget -P $HOME/.local/share/fusion360 https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/extras/desktop-starter/launcher.sh
   chmod +x $HOME/.local/share/fusion360/launcher.sh
   logfile-installation-standard
   manager-extensions-standard
   program-exit
}

###############################################################################################################################################################

# Autodesk Fusion 360 will now be installed using Wine and Winetricks! - Custom

function winetricks-custom {
   mkdir -p $custom_directory
   WINEPREFIX=$custom_directory sh data/winetricks/winetricks -q corefonts cjkfonts msxml4 msxml6 vcrun2017 fontsmooth=rgb win8
   # We must install cjkfonts again then sometimes it doesn't work the first time!
   WINEPREFIX=$custom_directory sh data/winetricks/winetricks -q cjkfonts
   configure-dxvk-or-opengl-custom-1
   WINEPREFIX=$custom_directory wine data/fusion360/Fusion360installer.exe -p deploy -g -f log.txt --quiet
   WINEPREFIX=$custom_directory wine data/fusion360/Fusion360installer.exe -p deploy -g -f log.txt --quiet
   mkdir -p "$custom_directory/drive_c/users/$USER/AppData/Roaming/Autodesk/Neutron Platform/Options"
   cd "$custom_directory/drive_c/users/$USER/AppData/Roaming/Autodesk/Neutron Platform/Options"
   configure-dxvk-or-opengl-custom-2
   # Because the location varies depending on the Linux distro!
   mkdir -p "$custom_directory/drive_c/users/$USER/Application Data/Autodesk/Neutron Platform/Options"
   cd "$custom_directory/drive_c/users/$USER/Application Data/Autodesk/Neutron Platform/Options"
   configure-dxvk-or-opengl-custom-3
   #Set up the program launcher for you!
   rm $HOME/.local/share/applications/wine/Programs/Autodesk/Autodesk\ Fusion\ 360.desktop
   wget -P $HOME/.local/share/applications/wine/Programs/Autodesk https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/extras/desktop-starter/Autodesk%20Fusion%20360.desktop
   cd $HOME/Fusion360
   wget -P $HOME/.local/share/fusion360 https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/extras/desktop-starter/launcher.sh
   wget https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/launcher.sh -O Fusion360launcher
   mv Fusion360launcher data/fusion360/Fusion360launcher
   desktop-launcher-custom
   logfile-installation-custom
   manager-extensions-custom
   program-exit
}

###############################################################################################################################################################

# Autodesk Fusion 360 will now be installed using Wine and Winetricks! - Standard (Flatpak)

function winetricks-flatpak-standard {
   flatpak run org.winehq.flatpak-wine619 winetricks -q corefonts cjkfonts msxml4 msxml6 vcrun2017 fontsmooth=rgb win8
   # We must install cjkfonts again then sometimes it doesn't work the first time!
   flatpak run org.winehq.flatpak-wine619-ge-1 winetricks -q cjkfonts
   configure-dxvk-or-opengl-flatpak-standard-1
   flatpak run org.winehq.flatpak-wine619 wine data/fusion360/Fusion360installer.exe -p deploy -g -f log.txt --quiet
   flatpak run org.winehq.flatpak-wine619 wine data/fusion360/Fusion360installer.exe -p deploy -g -f log.txt --quiet
   mkdir -p "$HOME/.local/share/flatpak-wine619/default/drive_c/users/$USER/AppData/Roaming/Autodesk/Neutron Platform/Options"
   cd "$HOME/.local/share/flatpak-wine619/default/drive_c/users/$USER/AppData/Roaming/Autodesk/Neutron Platform/Options"
   configure-dxvk-or-opengl-flatpak-standard-2
   # Because the location varies depending on the Linux distro!
   mkdir -p "$HOME/.local/share/flatpak-wine619/default/drive_c/users/$USER/Application Data/Autodesk/Neutron Platform/Options"
   cd "$$HOME/.local/share/flatpak-wine619/default/drive_c/users/$USER/Application Data/Autodesk/Neutron Platform/Options"
   configure-dxvk-or-opengl-flatpak-standard-3
   #Set up the program launcher for you!
   #rm ...
   #wget -P $HOME/.local/share/applications/wine/Programs/Autodesk https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/extras/desktop-starter/Autodesk%20Fusion%20360%20-%20Flatpak.desktop
   #rm ...
   #wget -P $HOME/.local/share/fusion360 https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/extras/desktop-starter/flatpak-launcher.sh
   #chmod +x $HOME/.local/share/fusion360/launcher.sh
   logfile-installation-flatpak-standard
   manager-extensions-flatpak-standard
   program-exit
}

###############################################################################################################################################################

# Install a extension: Airfoil Tools

function airfoil-tools-plugin-standard {
    mkdir -p "$HOME/Fusion360/data/extensions"
    cd "$HOME/Fusion360/data/extensions"
    wget -N https://github.com/cryinkfly/Fusion-360---Linux-Wine-Version-/raw/main/files/extensions/AirfoilTools_win64.msi &&
    WINEPREFIX=$HOME/.wineprefixes/fusion360 wine AirfoilTools_win64.msi
}

function airfoil-tools-plugin-custom {
    mkdir -p "$HOME/Fusion360/data/extensions"
    cd "$HOME/Fusion360/data/extensions"
    wget -N https://github.com/cryinkfly/Fusion-360---Linux-Wine-Version-/raw/main/files/extensions/AirfoilTools_win64.msi &&
    WINEPREFIX=$custom_directory wine AirfoilTools_win64.msi
}

function airfoil-tools-plugin-flatpak-standard {
    mkdir -p "$HOME/Fusion360/data/extensions"
    cd "$HOME/Fusion360/data/extensions"
    wget -N https://github.com/cryinkfly/Fusion-360---Linux-Wine-Version-/raw/main/files/extensions/AirfoilTools_win64.msi &&
    flatpak run org.winehq.flatpak-wine619 wine AirfoilTools_win64.msi
}

###############################################################################################################################################################

# Install a extension: Additive Assistant (FFF)

function additive-assistant-plugin-standard {
    mkdir -p "$HOME/Fusion360/data/extensions"
    cd "$HOME/Fusion360/data/extensions"
    wget -N https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/extensions/AdditiveAssistant.bundle-win64.msi &&
    WINEPREFIX=$HOME/.wineprefixes/fusion360 wine AdditiveAssistant.bundle-win64.msi
}

function additive-assistant-plugin-custom {
    mkdir -p "$HOME/Fusion360/data/extensions"
    cd "$HOME/Fusion360/data/extensions"
    wget -N https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/extensions/AdditiveAssistant.bundle-win64.msi &&
    WINEPREFIX=$custom_directory wine AdditiveAssistant.bundle-win64.msi
}

function additive-assistant-plugin-flatpak-standard {
    mkdir -p "$HOME/Fusion360/data/extensions"
    cd "$HOME/Fusion360/data/extensions"
    wget -N https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/extensions/AdditiveAssistant.bundle-win64.msi &&
    flatpak run org.winehq.flatpak-wine619 wine AdditiveAssistant.bundle-win64.msi
}

###############################################################################################################################################################

# Install a extension: Czech localization for F360

function czech-locale-plugin-standard {
    czech-locale-search-plugin-standard
    WINEPREFIX=$HOME/.wineprefixes/fusion360 wine $CZECH_LOCALE
}

function czech-locale-plugin-custom {
    czech-locale-search-plugin-custom
    WINEPREFIX=$custom_directory wine $CZECH_LOCALE
}

function czech-locale-plugin-flatpak-standard {
    czech-locale-search-plugin-flatpak-standard
    flatpak run org.winehq.flatpak-wine619 wine $CZECH_LOCALE
}

###############################################################################################################################################################

# Install a extension: HP 3D Printers for Autodesk® Fusion 360™

function hp-3dprinter-connector-plugin-standard {
    mkdir -p "$HOME/Fusion360/data/extensions"
    cd "$HOME/Fusion360/data/extensions"
    wget -N https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/extensions/HP_3DPrinters_for_Fusion360-win64.msi &&
    WINEPREFIX=$HOME/.wineprefixes/fusion360 wine HP_3DPrinters_for_Fusion360-win64.msi
}

function hp-3dprinter-connector-plugin-custom {
    mkdir -p "$HOME/Fusion360/data/extensions"
    cd "$HOME/Fusion360/data/extensions"
    wget -N https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/extensions/HP_3DPrinters_for_Fusion360-win64.msi &&
    WINEPREFIX=$custom_directory wine HP_3DPrinters_for_Fusion360-win64.msi
}

function hp-3dprinter-connector-plugin-flatpak-standard {
    mkdir -p "$HOME/Fusion360/data/extensions"
    cd "$HOME/Fusion360/data/extensions"
    wget -N https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/extensions/HP_3DPrinters_for_Fusion360-win64.msi &&
    flatpak run org.winehq.flatpak-wine619 wine HP_3DPrinters_for_Fusion360-win64.msi
}

###############################################################################################################################################################

# Install a extension: OctoPrint for Autodesk® Fusion 360™

function octoprint-plugin-standard {
    mkdir -p "$HOME/Fusion360/data/extensions"
    cd "$HOME/Fusion360/data/extensions"
    wget -N https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/extensions/OctoPrint_for_Fusion360-win64.msi &&
    WINEPREFIX=$HOME/.wineprefixes/fusion360 wine OctoPrint_for_Fusion360-win64.msi
}

function octoprint-plugin-custom {
    mkdir -p "$HOME/Fusion360/data/extensions"
    cd "$HOME/Fusion360/data/extensions"
    wget -N https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/extensions/OctoPrint_for_Fusion360-win64.msi &&
    WINEPREFIX=$custom_directory wine OctoPrint_for_Fusion360-win64.msi
}

function octoprint-plugin-flatpak-standard {
    mkdir -p "$HOME/Fusion360/data/extensions"
    cd "$HOME/Fusion360/data/extensions"
    wget -N https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/extensions/OctoPrint_for_Fusion360-win64.msi &&
    flatpak run org.winehq.flatpak-wine619 wine OctoPrint_for_Fusion360-win64.msi
}

###############################################################################################################################################################

# Install a extension: RoboDK

function robodk-plugin-standard {
    mkdir -p "$HOME/Fusion360/data/extensions"
    cd "$HOME/Fusion360/data/extensions"
    wget -N https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/extensions/RoboDK.bundle-win64.msi &&
    WINEPREFIX=$HOME/.wineprefixes/fusion360 wine RoboDK.bundle-win64.msi
}

function robodk-plugin-custom {
    mkdir -p "$HOME/Fusion360/data/extensions"
    cd "$HOME/Fusion360/data/extensions"
    wget -N https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/extensions/RoboDK.bundle-win64.msi &&
    WINEPREFIX=$custom_directory wine RoboDK.bundle-win64.msi
}

function robodk-plugin-flatpak-standard {
    mkdir -p "$HOME/Fusion360/data/extensions"
    cd "$HOME/Fusion360/data/extensions"
    wget -N https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/extensions/RoboDK.bundle-win64.msi &&
    flatpak run org.winehq.flatpak-wine619 wine RoboDK.bundle-win64.msi
}

###############################################################################################################################################################

# Remove a exist Autodesk Fusion 360 (Wineprefix)!

function deinstall-exist-fusion360 {
    deinstall-select-fusion360
    rm -r "$deinstall_directory"
    program-exit-uninstall
}

###############################################################################################################################################################
# ALL DIALOGS ARE ARRANGED HERE:                                                                                                                              #
###############################################################################################################################################################

# Progress indicator dialog

function progress-indicator-dialog {
  (
echo "5" ; sleep 1
echo "# The folder structure will be created." ; sleep 1
create-structure
echo "25" ; sleep 1
echo "# The locale files will be loaded." ; sleep 1
load-locale
echo "45" ; sleep 1
echo "# The Flatpak file will be loaded." ; sleep 1
load-flatpak
echo "55" ; sleep 1
echo "# The wine- and winetricks Script is loaded." ; sleep 1
load-winetricks
echo "75" ; sleep 1
echo "# The Autodesk Fusion 360 installation file will be downloaded." ; sleep 1
check-if-fusion360installer-exists
echo "90" ; sleep 1
echo "# The installation can now be started!" ; sleep 1
echo "100" ; sleep 1
) |
zenity --progress \
  --title="Autodesk Fusion 360 for Linux - Setup Wizard" \
  --text="The Setup Wizard is being configured ..." \
  --width=400 \
  --height=100 \
  --percentage=0

if [ "$?" = 0 ] ; then
        start-launcher
elif [ "$?" = 1 ] ; then
        zenity --question \
                 --title="$program_name" \
                 --text="Are you sure you want to cancel the installation?" \
                 --width=400 \
                 --height=100
        answer=$?

        if [ "$answer" -eq 0 ]; then
              exit;
        elif [ "$answer" -eq 1 ]; then
              progress-indicator-dialog
        fi
elif [ "$?" = -1 ] ; then
        zenity --error \
          --text="An unexpected error occurred!"
        exit;
fi
}

###############################################################################################################################################################

# Welcome Screen - Setup Wizard of Autodesk Fusion 360 for Linux

function start-launcher {
  zenity --question \
         --title="$program_name" \
         --text="Would you like to install Autodesk Fusion 360 on your system?" \
         --width=400 \
         --height=100
  answer=$?

  if [ "$answer" -eq 0 ]; then
      configure-locale
  elif [ "$answer" -eq 1 ]; then
      exit;
  fi
}

###############################################################################################################################################################

# Configure the locale of the Setup Wizard

function configure-locale {

  response=$(zenity --list \
                    --radiolist \
                    --title="$program_name" \
                    --width=700 \
                    --height=500 \
                    --column="Select:" --column="Language:" \
                    TRUE "English (Standard)" \
                    FALSE "German" \
                    FALSE "Czech" \
                    FALSE "Spanish" \
                    FALSE "French" \
                    FALSE "Italian" \
                    FALSE "Japanese" \
                    FALSE "Korean" \
                    FALSE "Chinese")

[[ $response = "English (Standard)" ]] && load-locale-en && licenses-en

[[ $response = "German" ]] && load-locale-de && licenses-de

[[ $response = "Czech" ]] && load-locale-cs && licenses-cs

[[ $response = "Spanish" ]] && load-locale-es && licenses-es

[[ $response = "French" ]] && load-locale-fr && licenses-fr

[[ $response = "Italian" ]] && load-locale-it && licenses-it

[[ $response = "Japanese" ]] && load-locale-ja && licenses-ja

[[ $response = "Korean" ]] && load-locale-ko && licenses-ko

[[ $response = "Chinese" ]] && load-locale-zh && licenses-zh

[[ "$response" ]] || start-launcher
}

###############################################################################################################################################################

# Load & View the LICENSE AGREEMENT of this Setup Wizard - cs-CZ

function licenses-cs {

license_de=`dirname $0`/data/locale/cs-CZ/license-cs

zenity --text-info \
       --title="$program_name" \
       --width=700 \
       --height=500 \
       --filename=$license_cs \
       --checkbox="$text_license_checkbox"

case $? in
    0)
        echo "Start the installation."
        check-if-fusion360-exists
	      ;;
    1)
        echo "Go back"
        configure-locale
	      ;;
    -1)
        zenity --error \
          --text="$text_error"
        exit;
	      ;;
esac
}

###############################################################################################################################################################

# Load & View the LICENSE AGREEMENT of this Setup Wizard - de-DE

function licenses-de {

license_de=`dirname $0`/data/locale/de-DE/license-de

zenity --text-info \
       --title="$program_name" \
       --width=700 \
       --height=500 \
       --filename=$license_de \
       --checkbox="$text_license_checkbox"

case $? in
    0)
        echo "Start the installation."
        check-if-fusion360-exists
	      ;;
    1)
        echo "Go back"
        configure-locale
	      ;;
    -1)
        zenity --error \
          --text="$text_error"
        exit;
	      ;;
esac
}

###############################################################################################################################################################

# Load & View the LICENSE AGREEMENT of this Setup Wizard - en-US

function licenses-en {

license_en=`dirname $0`/data/locale/en-US/license-en

zenity --text-info \
       --title="$program_name" \
       --width=700 \
       --height=500 \
       --filename=$license_en \
       --checkbox="$text_license_checkbox"

case $? in
    0)
        echo "Start the installation."
        check-if-fusion360-exists
	      ;;
    1)
        echo "Go back."
        configure-locale
	      ;;
    -1)
        zenity --error \
          --text="$text_error"
        exit;
        ;;
esac
}

###############################################################################################################################################################

# Load & View the LICENSE AGREEMENT of this Setup Wizard - es-ES

function licenses-es {

license_es=`dirname $0`/data/locale/es-ES/license-es

zenity --text-info \
       --title="$program_name" \
       --width=700 \
       --height=500 \
       --filename=$license_es \
       --checkbox="$text_license_checkbox"

case $? in
    0)
        echo "Start the installation."
        check-if-fusion360-exists
	      ;;
    1)
        echo "Go back"
        configure-locale
	      ;;
    -1)
        zenity --error \
          --text="$text_error"
        exit;
	      ;;
esac
}

###############################################################################################################################################################

# Load & View the LICENSE AGREEMENT of this Setup Wizard - fr-FR

function licenses-fr {

license_fr=`dirname $0`/data/locale/fr-FR/license-fr

zenity --text-info \
       --title="$program_name" \
       --width=700 \
       --height=500 \
       --filename=$license_fr \
       --checkbox="$text_license_checkbox"

case $? in
    0)
        echo "Start the installation."
        check-if-fusion360-exists
	      ;;
    1)
        echo "Go back"
        configure-locale
	      ;;
    -1)
        zenity --error \
          --text="$text_error"
        exit;
	      ;;
esac
}

###############################################################################################################################################################

# Load & View the LICENSE AGREEMENT of this Setup Wizard - it-IT

function licenses-it {

license_it=`dirname $0`/data/locale/it-IT/license-it

zenity --text-info \
       --title="$program_name" \
       --width=700 \
       --height=500 \
       --filename=$license_it \
       --checkbox="$text_license_checkbox"

case $? in
    0)
        echo "Start the installation."
        check-if-fusion360-exists
	      ;;
    1)
        echo "Go back"
        configure-locale
	      ;;
    -1)
        zenity --error \
          --text="$text_error"
        exit;
      	;;
esac
}

###############################################################################################################################################################

# Load & View the LICENSE AGREEMENT of this Setup Wizard - ja-JP

function licenses-ja {

license_ja=`dirname $0`/data/locale/ja-JP/license-ja

zenity --text-info \
       --title="$program_name" \
       --width=700 \
       --height=500 \
       --filename=$license_ja \
       --checkbox="$text_license_checkbox"

case $? in
    0)
        echo "Start the installation."
        check-if-fusion360-exists
	      ;;
    1)
        echo "Go back"
        configure-locale
	      ;;
    -1)
        zenity --error \
          --text="$text_error"
        exit;
	      ;;
esac
}

###############################################################################################################################################################

# Load & View the LICENSE AGREEMENT of this Setup Wizard - ko-KR

function licenses-ko {

license_ko=`dirname $0`/data/locale/ko-KR/license-ko

zenity --text-info \
       --title="$program_name" \
       --width=700 \
       --height=500 \
       --filename=$license_ko \
       --checkbox="$text_license_checkbox"

case $? in
    0)
        echo "Start the installation."
        check-if-fusion360-exists
	      ;;
    1)
        echo "Go back"
        configure-locale
	      ;;
    -1)
        zenity --error \
          --text="$text_error"
        exit;
	      ;;
esac
}

###############################################################################################################################################################

# Load & View the LICENSE AGREEMENT of this Setup Wizard - zh-CN

function licenses-zh {

license_zh=`dirname $0`/data/locale/zh-CN/license-zh

zenity --text-info \
       --title="$program_name" \
       --width=700 \
       --height=500 \
       --filename=$license_zh \
       --checkbox="$text_license_checkbox"

case $? in
    0)
        echo "Start the installation."
        check-if-fusion360-exists
	      ;;
    1)
        echo "Go back"
        configure-locale
	      ;;
    -1)
        zenity --error \
          --text="$text_error"
        exit;
      	;;
esac
}

###############################################################################################################################################################

# Autodesk Fusion 360 will be installed from scratch on this system!

function select-opengl_dxvk {
  response=$(zenity --list \
                    --radiolist \
                    --title="$program_name" \
                    --width=700 \
                    --height=500 \
                    --column="$text_select" --column="$text_driver" \
                    TRUE "$text_driver_opengl" \
                    FALSE "$text_driver_dxvk")

[[ $response = "$text_driver_opengl" ]] && driver_used=1 && select-your-os

[[ $response = "$text_driver_dxvk" ]] && driver_used=2 && select-your-os

[[ "$response" ]] || echo "Go back" && configure-locale
}

function select-opengl_dxvk-flatpak {
  response=$(zenity --list \
                    --radiolist \
                    --title="$program_name" \
                    --width=700 \
                    --height=500 \
                    --column="$text_select" --column="$text_driver" \
                    TRUE "$text_driver_opengl" \
                    FALSE "$text_driver_dxvk")

[[ $response = "$text_driver_opengl" ]] && driver_used=1 && . data/flatpak/flatpak-install.sh && winetricks-flatpak-standard

[[ $response = "$text_driver_dxvk" ]] && driver_used=2 && data/flatpak/flatpak-install.sh && winetricks-flatpak-standard

[[ "$response" ]] || echo "Go back" && configure-locale
}

###############################################################################################################################################################

# For the installation of Autodesk Fusion 360 one of the supported Linux distributions must be selected! - Part 1

function select-your-os {
  response=$(zenity --list \
                    --radiolist \
                    --title="$program_name" \
                    --width=700 \
                    --height=500 \
                    --column="$text_select" --column="$text_linux_distribution" \
                    FALSE "Arch Linux, Manjaro Linux, EndeavourOS, ..." \
                    FALSE "Debian 10, MX Linux 19.4, Raspberry Pi Desktop, ..." \
                    FALSE "Debian 11" \
                    FALSE "Fedora 33" \
                    FALSE "Fedora 34" \
                    FALSE "openSUSE Leap 15.2" \
                    FALSE "openSUSE Leap 15.3" \
                    FALSE "openSUSE Tumbleweed" \
                    FALSE "Red Hat Enterprise Linux 8.x" \
                    FALSE "Solus" \
                    FALSE "Ubuntu 18.04, Linux Mint 19.x, ..." \
                    FALSE "Ubuntu 20.04, Linux Mint 20.x, Pop!_OS 20.04, ..." \
                    FALSE "Ubuntu 20.10" \
                    FALSE "Ubuntu 21.04, Pop!_OS 21.04, ..." \
                    FALSE "Ubuntu 21.10" \
                    FALSE "Void Linux" \
                    FALSE "Gentoo Linux")

[[ $response = "Arch Linux, Manjaro Linux, EndeavourOS, ..." ]] && archlinux-1

[[ $response = "Debian 10, MX Linux 19.4, Raspberry Pi Desktop, ..." ]] && debian-based-1 && sudo add-apt-repository 'deb https://dl.winehq.org/wine-builds/debian/ buster main' && debian-based-2

[[ $response = "Debian 11" ]] && debian-based-1 && sudo add-apt-repository 'deb https://dl.winehq.org/wine-builds/debian/ bullseye main' && debian-based-2

[[ $response = "Fedora 33" ]] && fedora-based-1 && sudo dnf config-manager --add-repo https://dl.winehq.org/wine-builds/fedora/33/winehq.repo && fedora-based-2

[[ $response = "Fedora 34" ]] && fedora-based-1 && sudo dnf config-manager --add-repo https://dl.winehq.org/wine-builds/fedora/34/winehq.repo && fedora-based-2

[[ $response = "openSUSE Leap 15.2" ]] && su -c 'zypper up && zypper rr https://download.opensuse.org/repositories/Emulators:/Wine/openSUSE_Leap_15.2/ wine && zypper ar -cfp 95 https://download.opensuse.org/repositories/Emulators:/Wine/openSUSE_Leap_15.2/ wine && zypper install p7zip-full curl wget wine cabextract' && select-your-path

[[ $response = "openSUSE Leap 15.3" ]] && su -c 'zypper up && zypper rr https://download.opensuse.org/repositories/Emulators:/Wine/openSUSE_Leap_15.3/ wine && zypper ar -cfp 95 https://download.opensuse.org/repositories/Emulators:/Wine/openSUSE_Leap_15.3/ wine && zypper install p7zip-full curl wget wine cabextract' && select-your-path

[[ $response = "openSUSE Tumbleweed" ]] && su -c 'zypper up && zypper install p7zip-full curl wget wine cabextract' && select-your-path

[[ $response = "Red Hat Enterprise Linux 8.x" ]] && redhat-linux && select-your-path

[[ $response = "Solus" ]] && solus-linux && select-your-path

[[ $response = "Ubuntu 18.04, Linux Mint 19.x, ..." ]] && debian-based-1 && ubuntu18 && debian-based-2

[[ $response = "Ubuntu 20.04, Linux Mint 20.x, Pop!_OS 20.04, ..." ]] && debian-based-1 && ubuntu20 && debian-based-2

[[ $response = "Ubuntu 20.10" ]] && debian-based-1 && ubuntu20_10 && debian-based-2

[[ $response = "Ubuntu 21.04, Pop!_OS 21.04, ..." ]] && ubuntu21 && debian-based-2

[[ $response = "Ubuntu 21.10" ]] && ubuntu21_10 && debian-based-2

[[ $response = "Void Linux" ]] && void-linux && select-your-path

[[ $response = "Gentoo Linux" ]] && gentoo-linux && select-your-path

[[ "$response" ]] || echo "Go back" && select-opengl_dxvk
}

###############################################################################################################################################################

# Here you can determine how Autodesk Fusion 360 should be instierlert! (Installation location)

function select-your-path {
  response=$(zenity --list \
                    --radiolist \
                    --title="$program_name" \
                    --width=700 \
                    --height=500 \
                    --column="$text_select" --column="$text_installation_location" \
                    TRUE "$text_installation_location_standard" \
                    FALSE "$text_installation_location_custom")

[[ $response = "$text_installation_location_standard" ]] && winetricks-standard

[[ $response = "$text_installation_location_custom" ]] && select-your-path-fusion360 && winetricks-custom

[[ "$response" ]] || echo "Go back" && abort-installation
}

###############################################################################################################################################################

function desktop-launcher-custom {
  file=`dirname $0`/data/fusion360/Fusion360launcher
  launcher=`zenity --text-info \
         --title="$program_name" \
         --width=1000 \
         --height=500 \
         --filename=$file \
         --editable \
         --checkbox="$text_desktop_launcher_custom_checkbox"`

  case $? in
      0)
          zenity --question \
                 --title="$program_name" \
                 --text="$text_desktop_launcher_custom_question" \
                 --width=400 \
                 --height=100
          answer=$?

          if [ "$answer" -eq 0 ]; then
              echo "$launcher" > $file
              rm "$HOME/.local/share/fusion360/launcher.sh"
              mv $file "$HOME/.local/share/fusion360/launcher.sh"
          elif [ "$answer" -eq 1 ]; then
              desktop-launcher-custom
          fi

  	      ;;
      1)
          echo "Go back"
          desktop-launcher-custom
  	      ;;
      -1)
          zenity --error \
          --text="$text_error"
          exit;
  	      ;;
  esac
}

###############################################################################################################################################################

# Create & Select a directory for your Autodesk Fusion 360!

function select-your-path-fusion360 {
custom_directory=`zenity --file-selection --directory --title="$text_select_location_custom"`
}

###############################################################################################################################################################

# Autodesk Fusion 360 has already been installed on your system and you will now be given various options to choose from!

function new_modify_deinstall {
  response=$(zenity --list \
                    --radiolist \
                    --title="$program_name" \
                    --width=700 \
                    --height=500 \
                    --column="$text_select" --column="$text_select_option" \
                    TRUE "$text_select_option_1" \
                    FALSE "$text_select_option_2" \
                    FALSE "$text_select_option_3" \
                    False "$text_select_option_4")

[[ $response = "$text_select_option_1" ]] && logfile_install=1 && view-exist-fusion360

[[ $response = "$text_select_option_2" ]] && edit-exist-fusion360

[[ $response = "$text_select_option_3" ]] && view-exist-fusion360-extensions

[[ $response = "$text_select_option_4" ]] && deinstall-view-exist-fusion360

[[ "$response" ]] || echo "Go back" && configure-locale

}

###############################################################################################################################################################

# View the path of your exist Autodesk Fusion 360! -View

function view-exist-fusion360 {
  file=`dirname $0`/data/logfiles/log-path
  directory=`zenity --text-info \
         --title="$program_name" \
         --width=700 \
         --height=500 \
         --filename=$file \
         --checkbox="$text_new_installation_checkbox"`

  case $? in
      0)
          new_modify-select-opengl_dxvk
  	      ;;
      1)
          echo "Go back"
          new_modify_deinstall
  	      ;;
      -1)
        zenity --error \
          --text="$text_error"
          exit;
  	      ;;
  esac

}

###############################################################################################################################################################

# View the path of your exist Autodesk Fusion 360! - edit-exist-fusion360

function edit-exist-fusion360 {
  file=`dirname $0`/data/logfiles/log-path
  directory=`zenity --text-info \
         --title="$program_name" \
         --width=700 \
         --height=500 \
         --filename=$file \
         --checkbox="$text_edit_installation_checkbox"`

  case $? in
      0)
          new_modify-select-opengl_dxvk
  	      ;;
      1)
          echo "Go back"
          new_modify_deinstall
  	      ;;
      -1)
        zenity --error \
          --text="$text_error"
          exit;
  	      ;;
  esac

}

###############################################################################################################################################################

# Autodesk Fusion 360 will be installed from scratch on this system!

function new_modify-select-opengl_dxvk {
  response=$(zenity --list \
                    --radiolist \
                    --title="$program_name" \
                    --width=700 \
                    --height=500 \
                    --column="$text_select" --column="$text_driver" \
                    TRUE "$text_driver_opengl" \
                    FALSE "$text_driver_dxvk")

[[ $response = "$text_driver_opengl" ]] && driver_used=1 && select-your-path-fusion360 && winetricks-custom

[[ $response = "$text_driver_dxvk" ]] && driver_used=2 && select-your-path-fusion360 && winetricks-custom

[[ "$response" ]] || echo "Go back" && new_modify_deinstall
}

###############################################################################################################################################################

# View the path of your exist Autodesk Fusion 360! -View

function view-exist-fusion360-extensions {
  file=`dirname $0`/data/logfiles/log-path
  directory=`zenity --text-info \
         --title="$program_name" \
         --width=700 \
         --height=500 \
         --filename=$file \
         --checkbox="$text_new_installation_checkbox"`

  case $? in
      0)
          select-your-path-fusion360
          manager-extensions-custom
          program-exit-extensions
  	      ;;
      1)
          echo "Go back"
          new_modify_deinstall
  	      ;;
      -1)
        zenity --error \
          --text="$text_error"
          exit;
  	      ;;
  esac

}

###############################################################################################################################################################

# Deinstall a exist Autodesk Fusion 360 installation!

function deinstall-view-exist-fusion360 {
  file=`dirname $0`/data/logfiles/log-path
  directory=`zenity --text-info \
         --title="$program_name" \
         --width=700 \
         --height=500 \
         --filename=$file \
         --editable \
         --checkbox="$text_deinstall_checkbox"`

  case $? in
      0)
          zenity --question \
                 --title="$program_name" \
                 --text="$text_deinstall_question" \
                 --width=400 \
                 --height=100
          answer=$?

          if [ "$answer" -eq 0 ]; then
              echo "$directory" > $file
	      cp "$file" $HOME/.local/share/fusion360/logfiles
              deinstall-exist-fusion360
          elif [ "$answer" -eq 1 ]; then
              deinstall-view-exist-fusion360
          fi

  	      ;;
      1)
          echo "Go back"
          new_modify_deinstall
  	      ;;
      -1)
        zenity --error \
          --text="$text_error"
          exit;
  	      ;;
  esac

}

###############################################################################################################################################################

# Select your exist Autodesk Fusion 360 for the deinstallation!

function deinstall-select-fusion360 {
  deinstall_directory=`zenity --file-selection --directory --title="$text_select_location_deinstall"`
}

###############################################################################################################################################################

# The uninstallation is complete and will be terminated.

function program-exit-uninstall {
  zenity --info \
  --width=400 \
  --height=100 \
  --text="$text_completed_deinstallation"

  exit;
}

###############################################################################################################################################################

# Install some extensions with a manager! - Standard

function manager-extensions-standard {

response=$(zenity --list \
                  --checklist \
                  --title="$program_name" \
                  --width=1000 \
                  --height=500 \
                  --column="$text_select" --column="$text_extension" --column="$text_extension_description"\
                  FALSE "Airfoil Tools" "$text_extension_description_1" \
                  FALSE "Additive Assistant (FFF)" "$text_extension_description_2" \
                  FALSE "Czech localization for F360" "$text_extension_description_3" \
                  FALSE "HP 3D Printers for Autodesk® Fusion 360™" "$text_extension_description_4" \
                  FALSE "OctoPrint for Autodesk® Fusion 360™" "$text_extension_description_5" \
                  FALSE "RoboDK" "$text_extension_description_6" )

[[ $response = *"Airfoil Tools"* ]] && airfoil-tools-plugin-standard

[[ $response = *"Additive Assistant (FFF)"* ]] && additive-assistant-plugin-standard

[[ $response = *"Czech localization for F360"* ]] && czech-locale-plugin-standard

[[ $response = *"HP 3D Printers for Autodesk® Fusion 360™"* ]] && hp-3dprinter-connector-plugin-standard

[[ $response = *"OctoPrint for Autodesk® Fusion 360™"* ]] && octoprint-plugin-standard

[[ $response = *"RoboDK"* ]] && robodk-plugin-standard

[[ "$response" ]] || echo "Nothing selected!"
}

###############################################################################################################################################################

# Install some extensions with a manager! - Custom

function manager-extensions-custom {

response=$(zenity --list \
                  --checklist \
                  --title="$program_name" \
                  --width=1000 \
                  --height=500 \
                  --column="$text_select" --column="$text_extension" --column="$text_extension_description"\
                  FALSE "Airfoil Tools" "$text_extension_description_1" \
                  FALSE "Additive Assistant (FFF)" "$text_extension_description_2" \
                  FALSE "Czech localization for F360" "$text_extension_description_3" \
                  FALSE "HP 3D Printers for Autodesk® Fusion 360™" "$text_extension_description_4" \
                  FALSE "OctoPrint for Autodesk® Fusion 360™" "$text_extension_description_5" \
                  FALSE "RoboDK" "$text_extension_description_6" )

[[ $response = *"Airfoil Tools"* ]] && airfoil-tools-plugin-custom

[[ $response = *"Additive Assistant (FFF)"* ]] && additive-assistant-plugin-custom

[[ $response = *"Czech localization for F360"* ]] && czech-locale-plugin-custom

[[ $response = *"HP 3D Printers for Autodesk® Fusion 360™"* ]] && hp-3dprinter-connector-plugin-custom

[[ $response = *"OctoPrint for Autodesk® Fusion 360™"* ]] && octoprint-plugin-custom

[[ $response = *"RoboDK"* ]] && robodk-plugin-custom

[[ "$response" ]] || echo "Nothing selected!"
}

###############################################################################################################################################################

# Install some extensions with a manager! - Standard (Flatpak)

function manager-extensions-flatpak-standard {

response=$(zenity --list \
                  --checklist \
                  --title="$program_name" \
                  --width=1000 \
                  --height=500 \
                  --column="$text_select" --column="$text_extension" --column="$text_extension_description"\
                  FALSE "Airfoil Tools" "$text_extension_description_1" \
                  FALSE "Additive Assistant (FFF)" "$text_extension_description_2" \
                  FALSE "Czech localization for F360" "$text_extension_description_3" \
                  FALSE "HP 3D Printers for Autodesk® Fusion 360™" "$text_extension_description_4" \
                  FALSE "OctoPrint for Autodesk® Fusion 360™" "$text_extension_description_5" \
                  FALSE "RoboDK" "$text_extension_description_6" )

[[ $response = *"Airfoil Tools"* ]] && airfoil-tools-plugin-flatpak-standard

[[ $response = *"Additive Assistant (FFF)"* ]] && additive-assistant-plugin-flatpak-standard

[[ $response = *"Czech localization for F360"* ]] && czech-locale-plugin-flatpak-standard

[[ $response = *"HP 3D Printers for Autodesk® Fusion 360™"* ]] && hp-3dprinter-connector-plugin-flatpak-standard

[[ $response = *"OctoPrint for Autodesk® Fusion 360™"* ]] && octoprint-plugin-flatpak-standard

[[ $response = *"RoboDK"* ]] && robodk-plugin-flatpak-standard

[[ "$response" ]] || echo "Nothing selected!"
}

###############################################################################################################################################################

# Select the downloaded installer for this special extension!

function czech-locale-search-plugin-standard {
CZECH_LOCALE=`zenity --file-selection --title="$text_select_czech_plugin"`

case $? in
       0)
              echo "\"$FILE\" selected.";;
       1)
              zenity --info \
              --text="$text_info_czech_plugin"
              manager-extensions-standard
              ;;
       -1)
              zenity --error \
              --text="$text_error"
              exit;
              ;;
esac
}


function czech-locale-search-plugin-custom {
CZECH_LOCALE=`zenity --file-selection --title="$text_select_czech_plugin"`

case $? in
       0)
              echo "\"$FILE\" selected.";;
       1)
              zenity --info \
              --text="$text_info_czech_plugin"
              manager-extensions-custom
              ;;
       -1)
              zenity --error \
              --text="$text_error"
              exit;
              ;;
esac
}


function czech-locale-search-plugin-flatpak-standard {
CZECH_LOCALE=`zenity --file-selection --title="$text_select_czech_plugin"`

case $? in
       0)
              echo "\"$FILE\" selected.";;
       1)
              zenity --info \
              --text="$text_info_czech_plugin"
              manager-extensions-flatpak-standard
              ;;
       -1)
              zenity --error \
              --text="$text_error"
              exit;
              ;;
esac
}

###############################################################################################################################################################

# Abort the installation of Autodesk Fusion 360!

function abort-installation {
  zenity --question \
         --title="$program_name" \
         --text="$text_abort" \
         --width=400 \
         --height=100
  answer=$?

  if [ "$answer" -eq 0 ]; then
      exit;
  elif [ "$answer" -eq 1 ]; then
      select-your-path
  fi
}

###############################################################################################################################################################

# The installation is complete and will be terminated.

function program-exit {
  zenity --info \
  --width=400 \
  --height=100 \
  --text="$text_completed_installation"

  exit;
}

###############################################################################################################################################################

# The installation of the extensions is complete and will be terminated.

function program-exit-extensions {
  zenity --info \
  --width=400 \
  --height=100 \
  --text="$text_completed_installation_extensions"

  exit;
}

###############################################################################################################################################################

# The uninstallation is complete and will be terminated.

function program-exit-uninstall {
  zenity --info \
  --width=400 \
  --height=100 \
  --text="$text_completed_deinstallation"

  exit;
}

###############################################################################################################################################################
# THE INSTALLATION PROGRAM IS STARTED HERE:                                                                                                                   #
###############################################################################################################################################################

# Reset the driver-value for the installation of Autodesk Fusion 360!
driver_used=0

# Reset the logfile-value for the installation of Autodesk Fusion 360!
logfile_install=0

# Name of this program (Window Title)
program_name="Autodesk Fusion 360 for Linux - Setup Wizard"

logfile-installation
progress-indicator-dialog