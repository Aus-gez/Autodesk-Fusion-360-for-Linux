#!/bin/bash

################################################################################
# Name:         Autodesk Fusion 360 - Uninstall the software (Linux)           #
# Description:  With this file you delete Autodesk Fusion 360 on your system.  #
# Author:       Steve Zabka                                                    #
# Author URI:   https://cryinkfly.com                                          #
# License:      MIT                                                            #
# Copyright (c) 2020-2022                                                      #
# Time/Date:    14:15/02.02.2023                                               #
# Version:      0.9                                                            #
################################################################################

# Path: /$HOME/.fusion360/bin/uninstall.sh

###############################################################################################################################################################
# THE INITIALIZATION OF DEPENDENCIES STARTS HERE:                                                                                                             #
###############################################################################################################################################################

# Default-Path:
DL_PATH="$HOME/.fusion360"

REQUIRED_COMMANDS=(
    "yad"
)

###############################################################################################################################################################

function SP_CHECK_REQUIRED_COMMANDS {
    for cmd in "${REQUIRED_COMMANDS[@]}"; do
        echo "Testing presence of ${cmd} ..."
        local path="$(command -v "${cmd}")"
        if [ -n "${path}" ]; then
            echo "Found: ${path}"
        else
            echo "No ${cmd} found in \$PATH!"
            exit 1
        fi
    done
}

# Copy the file where the user can see the exits Wineprefixes of Autodesk Fusion 360 on the system.
function DL_GET_FILES {
  mkdir -p "/tmp/fusion360/logs"
  cp "$HOME/.fusion360/logs/wineprefixes.log" "/tmp/fusion360/logs"
  cp "$HOME/.fusion360/config/settings.txt" "/tmp/fusion360/config"
}

###############################################################################################################################################################

function DL_LOAD_LOCALE {
  DL_LOCALE=$(awk 'NR == 1' /tmp/fusion360/settings.txt)
  if [[ $DL_LOCALE = "Czech" ]]; then
    echo "CS"
    # shellcheck source=../locale/cs-CZ/locale-cs.sh
    source "$DL_PATH/locale/cs-CZ/locale-cs.sh"
  elif [[ $DL_LOCALE = "English" ]]; then
    echo "EN"
    # shellcheck source=../locale/en-US/locale-en.sh
    source "$DL_PATH/locale/en-US/locale-en.sh"
  elif [[ $DL_LOCALE = "German" ]]; then
    echo "DE"
    # shellcheck source=../locale/de-DE/locale-de.sh
    source "$DL_PATH/locale/de-DE/locale-de.sh"
  elif [[ $DL_LOCALE = "Spanish" ]]; then
    echo "ES"
    # shellcheck source=../locale/es-ES/locale-es.sh
    source "$DL_PATH/locale/es-ES/locale-es.sh"
  elif [[ $DL_LOCALE = "French" ]]; then
    echo "FR"
    # shellcheck source=../locale/fr-FR/locale-fr.sh
    source "$DL_PATH/locale/fr-FR/locale-fr.sh"
  elif [[ $DL_LOCALE = "Italian" ]]; then
    echo "IT"
    # shellcheck source=../locale/it-IT/locale-it.sh
    source "$DL_PATH/locale/it-IT/locale-it.sh"
  elif [[ $DL_LOCALE = "Japanese" ]]; then
    echo "JP"
    # shellcheck source=../locale/ja-JP/locale-ja.sh
    source "$DL_PATH/locale/ja-JP/locale-ja.sh"
  elif [[ $DL_LOCALE = "Korean" ]]; then
    echo "KO"
    # shellcheck source=../locale/ko-KR/locale-ko.sh
    source "$DL_PATH/locale/ko-KR/locale-ko.sh"
  elif [[ $DL_LOCALE = "Chinese" ]]; then
    echo "ZH"
    # shellcheck source=../locale/zh-CN/locale-zh.sh
    source "$DL_PATH/locale/zh-CN/locale-zh.sh"
  else
   echo "EN"
   # shellcheck source=../locale/en-US/locale-en.sh
   source "$DL_PATH/locale/en-US/locale-en.sh"
  fi
}

###############################################################################################################################################################
# ALL DEL-FUNCTIONS ARE ARRANGED HERE:                                                                                                                        #
###############################################################################################################################################################

function DL_WINEPREFIXES_ACT {
  # For examble:
  # VAR 1 = FALSE
  # VAR 2 = default
  # VAR 3 = DXVK
  # VAR 4 = $HOME/.fusion360/wineprefixes/default

  # Get info if the user is sure with there choise ...
  DL_WINEPREFIXES_DEL_INFO
}

###############################################################################################################################################################

function DL_WINEPREFIXES_DEL {
  # Get the line numbers of your selected Wineprefixes:
  # Filtering (Wineprefix-Directory):
  DL_WINEPREFIXES=${DL_WINEPREFIXES_STRING/#TRUE}
  # Remove VAR 3 (line)
  DL_WINEPREFIXES_VAR_4=$(grep -n "$DL_WINEPREFIXES" /tmp/fusion360/logs/wineprefixes.log | grep -Eo '^[^:]+')
  DL_WINEPREFIXES_VAR_3=1
  DL_WINEPREFIXES_VAR_SUM=$(( DL_WINEPREFIXES_VAR_4 - DL_WINEPREFIXES_VAR_3 ))
  sed --in-place "${DL_WINEPREFIXES_VAR_SUM}d" /tmp/fusion360/logs/wineprefixes.log
  # Remove VAR 2 (line)
  DL_WINEPREFIXES_VAR_4=$(grep -n "$DL_WINEPREFIXES" /tmp/fusion360/logs/wineprefixes.log | grep -Eo '^[^:]+')
  DL_WINEPREFIXES_VAR_2=1
  DL_WINEPREFIXES_VAR_SUM=$(( DL_WINEPREFIXES_VAR_4 - DL_WINEPREFIXES_VAR_2 ))
  DL_SHORTCUTS=$(awk -v nr="$DL_WINEPREFIXES_VAR_SUM" 'NR==nr' /tmp/fusion360/logs/wineprefixes.log)
  sed --in-place "${DL_WINEPREFIXES_VAR_SUM}d" /tmp/fusion360/logs/wineprefixes.log
  # Remove VAR 1 (line)
  DL_WINEPREFIXES_VAR_4=$(grep -n "$DL_WINEPREFIXES" /tmp/fusion360/logs/wineprefixes.log | grep -Eo '^[^:]+')
  DL_WINEPREFIXES_VAR_1=1
  DL_WINEPREFIXES_VAR_SUM=$(( DL_WINEPREFIXES_VAR_4 - DL_WINEPREFIXES_VAR_1 ))
  sed --in-place "${DL_WINEPREFIXES_VAR_SUM}d" /tmp/fusion360/logs/wineprefixes.log
  # Remove VAR 4 (line)
  DL_WINEPREFIXES_VAR_4=$(grep -n "$DL_WINEPREFIXES" /tmp/fusion360/logs/wineprefixes.log | grep -Eo '^[^:]+')
  sed --in-place "${DL_WINEPREFIXES_VAR_1}d" /tmp/fusion360/logs/wineprefixes.log
  # Continue with removing ...
  rmdir "$DL_WINEPREFIXES"
  rmdir "$HOME/.local/share/applications/wine/Programs/Autodesk/Fusion360/$DL_SHORTCUTS"
  DL_WINEPREFIXES_DEL_ALL
}

###############################################################################################################################################################

function DL_WINEPREFIXES_DEL_ALL {
 if [[ -n $(cat /tmp/fusion360/logs/wineprefixes.log) ]] ; then
   # Do nothing!
   echo "There is at least one installed Wineprefix on your system!"
 else
   echo "There are no more Wineprefixes installed on your system!"
   rmdir "$DL_PATH"
   rmdir "$HOME/.local/share/applications/wine/Programs/Autodesk/Fusion360"
 fi
}

###############################################################################################################################################################
# ALL DIALOGS ARE ARRANGED HERE:                                                                                                                              #
###############################################################################################################################################################

function DL_WELCOME {
  yad \
  --form \
  --separator="" \
  --center \
  --height=125 \
  --width=750 \
  --buttons-layout=center \
  --title="$DL_TITLE" \
  --field="<big>$DL_SUBTITLE</big>:LBL" \
  --field="$DL_WELCOME_LABEL_1:LBL" \
  --field="$DL_WELCOME_LABEL_2:LBL" \
  --align=center \
  --button=gtk-about!!"$DL_WELCOME_TOOLTIP_1":1 \
  --button=gtk-cancel:99 \
  --button=gtk-ok:2

  ret=$?

  # Responses to above button presses are below:
  if [[ $ret -eq 1 ]]; then
    xdg-open https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux
    DL-WELCOME
  elif [[ $ret -eq 2 ]]; then
    DL_WINEPREFIXES_LIST
  else
    exit;
  fi
}

###############################################################################################################################################################

function DL_WINEPREFIXES_LIST {
  DL_WINEPREFIXES_STRING=$(yad --title="$DL_TITLE" --height=300 --separator="" --list --radiolist --column="$SELECT" --column="$WINEPREFIXES_TYPE" --column="$WINEPREFIXES_DRIVER" --column="$WINEPREFIXES_DIRECTORY" < /tmp/fusion360/logs/wineprefixes.log)
  DL_WINEPREFIXES_ACT
}

###############################################################################################################################################################

function DL_WINEPREFIXES_DEL_INFO {
  DL_WINEPREFIXES_DEL_CHECK=$(yad \
  --title="$DL_TITLE" \
  --form \
  --borders=15 \
  --width=550 \
  --height=450 \
  --buttons-layout=center \
  --align=center \
  --field=":TXT" "$DL_WINEPREFIXES_DEL_INFO_TEXT" \
  --field="$DL_WINEPREFIXES_DEL_INFO_LABEL:CHK" )

  if [[ $DL_WINEPREFIXES_DEL_CHECK = *"TRUE"* ]]; then
    echo "TRUE"
    DL_WINEPREFIXES_DEL
    DL_WINEPREFIXES_DEL_ALL
  else
    echo "FALSE"
    DL_WELCOME
  fi
}

###############################################################################################################################################################
# THE INSTALLATION PROGRAM IS STARTED HERE:                                                                                                                   #
###############################################################################################################################################################

SP_CHECK_REQUIRED_COMMANDS
DL_GET_FILES
DL_LOAD_LOCALE
DL_WELCOME
