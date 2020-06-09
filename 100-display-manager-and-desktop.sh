#!/bin/bash
#set -e
###############################################################################
# Original Author	:	Erik Dubois
# Website	:	https://www.erikdubois.be
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

###############################################################################
echo "Updating System"
###############################################################################

sudo xbps-install -yv void-repo-nonfree
sudo xbps-install -Suv

###############################################################################
echo "Installation of the core software"
###############################################################################

list=(
xorg
zsh
antibody
slim
slim-void-theme
dbus
thunar
thunar-archive-plugin
thunar-volman
alacritty
rxvt-unicode
urxvt-perls
bspwm
sxhkd
dmenu
rofi
xdo
xrdb
xsel
xset
neovim
feh
dunst
picom
sutils
xtitle
font-awesome5
font-iosevka
xsettingsd
polybar
tmux
xrandr
arandr
skippy-xd
nnn
ranger
ConsoleKit2
ffmpeg
ntfs-3g
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
chmod +x $HOME/.dotfiles/bootstrap && bash $HOME/.dotfiles/bootstrap
ln -s $HOME/.dotfiles/config/bspwm.symlink $HOME/.config/bspwm
ln-s $HOME/.dotfiles/config/sxhkd.symlink $HOME/.config/sxhkd
ln -s $HOME/.dotfiles/config/nvim.symlink $HOME/.config/nvim
ln -s $HOME/.dotfiles/config/picom.conf.symlink $HOME/.config/picom.conf
ln -s $HOME/.dotfiles/config/dunst.symlink $HOME/.config/dunst

tput setaf 5;echo "################################################################"
echo "Enabling slim as display manager"
echo "################################################################"
echo;tput sgr0
sudo ln -s /etc/sv/dbus /var/service/dbus
sudo ln -s /etc/sv/slim /var/service/slim

tput setaf 7;echo "################################################################"
echo "You now have a very minimal functional desktop"
echo "################################################################"
echo;tput sgr0

tput setaf 11;
echo "################################################################"
echo "Reboot your system"
echo "################################################################"
echo;tput sgr0
