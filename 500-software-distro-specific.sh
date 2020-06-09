#!/bin/bash
#set -e
###############################################################################
# Author	:	Erik Dubois
# Website	:	https://www.erikdubois.be
# Website	:	https://www.arcolinux.info
# Modified by : Chris Terrio
# Email : cterrio@gmail.com
###############################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
###############################################################################


###############################################################################
#
#   DECLARATION OF FUNCTIONS
#
###############################################################################


func_install() {
	if xbps-query $1 &> /dev/null; then
		tput setaf 2
  		echo "###############################################################################"
  		echo "################## The package "$1" is already installed"
      	echo "###############################################################################"
      	echo
		tput sgr0
	else
    	tput setaf 3
    	echo "###############################################################################"
    	echo "##################  Installing package "  $1
    	echo "###############################################################################"
    	echo
    	tput sgr0
    	sudo xbps-install -vy $1
    fi
}

func_category() {
	tput setaf 5;
	echo "################################################################"
	echo "Installing software for category " $1
	echo "################################################################"
	echo;tput sgr0
}

###############################################################################

func_category Additional-distro-specific

list=(
arandr
dmenu
feh
gmrun
gtk-engine-murrine
imagemagick
lxappearance
lxrandr
nitrogen
picom
playerctl
pywal
volumeicon
w3m
xfce4-appfinder
xfce4-notifyd
xfce4-power-manager
xfce4-screenshooter
xfce4-settings
xfce4-taskmanager
xfce4-terminal
skippy-xd
pcmanfm
neomutt
catfish
youtube-dl
irssi
newsboat
oblogout
i3lock
slop
)

count=0
for name in "${list[@]}" ; do
	count=$[count+1]
	tput setaf 3;echo "Installing package nr.  "$count " " $name;tput sgr0;
	func_install $name
done
###############################################################################
tput setaf 6;echo "################################################################"
echo "Copying Dotfiles from Config"
echo "################################################################"
echo;tput sgr0
chmod +x $HOME/.dotfiles/config/configbootstrap && bash $HOME/.dotfiles/config/configbootstrap
###############################################################################

tput setaf 11;
echo "################################################################"
echo "Software Installed"
echo "################################################################"

echo;tput sgr0
