#!/bin/bash
#set -e
###############################################################################
# Original Author	:	Erik Dubois
# Website	:	https://www.erikdubois.be
# Modified by : Chris Terrio
# Email : cterrio@posteo.net
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

cd $HOME
git clone git://github.com/void-linux/void-packages.git
cd void-packages
./xbps-src binary-bootstrap
./xbps-src bootstrap-update
sudo xbps-install -yv void-repo-nonfree
sudo xbps-install -Suv

###############################################################################
echo "Installation of the core software"
###############################################################################

list=(
rsync
xorg
zsh
antibody
lightdm
lightdm-gtk3-greeter
lightdm-gtk-greeter-settings
dbus
thunar
thunar-archive-plugin
thunar-volman
alacritty
rxvt-unicode
urxvt-perls
kitty
bspwm
sxhkd
dmenu
rofi
htop
lsof
xdo
xrdb
xsel
xset
xz
neovim
feh
dunst
picom
sutils
xtools
xtitle
font-awesome5
font-iosevka
xsettingsd
polybar
tmux
#byobu
xrandr
arandr
skippy-xd
nnn
fff
ranger
ConsoleKit2
ffmpeg
ntfs-3g
betterlockscreen
yadm
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
yadm clone https://github.com/Tangeant/dotfiles
chmod +x "$HOME/.config/yadm/bootstrap"
yadm bootstrap
chsh -s /bin/zsh && source ~/.zshrc
antibody update

tput setaf 5;echo "################################################################"
echo "Enabling lightdm as display manager"
echo "################################################################"
echo;tput sgr0
sudo ln -s /etc/sv/dbus /var/service/dbus
sudo ln -s /etc/sv/lightdm /var/service/lightdm

tput setaf 7;echo "################################################################"
echo "You now have a very minimal functional desktop"
echo "################################################################"
echo;tput sgr0

tput setaf 11;
echo "################################################################"
echo "Reboot your system"
echo "################################################################"
echo;tput sgr0
