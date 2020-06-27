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
	if pacman -Qi $1 &> /dev/null; then
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
    	sudo pacman -S --needed --noconfirm $1
    fi
}

###############################################################################
echo "Updating System"
###############################################################################

eos-rankmirrors
sudo pacman -S --needed --noconfirm reflector-auto

if [ ! -f /etc/reflector-auto.conf ]
	then
		touch /etc/reflector-auto.conf
fi
sudo echo "-c Canada -c United States -f 10 -p https -a 2" >> /etc/reflector-auto.conf
sudo systemctl start reflector-auto.timer
sudo systemctl enable reflector-auto.timer

sudo pacman -Syyu

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
thunar
thunar-archive-plugin
thunar-volman
alacritty
rxvt-unicode
urxvt-perls
kitty
termite
bspwm
sxhkd
openbox
obconf
dmenu
rofi
htop
lsof
xdo
xsel
xorg-xset
xz
neovim
feh
dunst
ttf-font-awesome
xsettingsd
tmux
#byobu
xrandr
arandr
nnn
fff
ranger
ntfs-3g
yay
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
sudo yay -S yadm
yadm clone https://github.com/Tangeant/dotfiles
chmod +x "$HOME/.config/yadm/bootstrap"
yadm bootstrap
chsh -s /bin/zsh && source ~/.zshrc
antibody update


###Enable Lightdm as Display Manager if none enabled

if [ systemctl is-enabled lightdm.service sddm.service gdm.service lxdm.service &> /dev/null ]
	then
		tput setaf 5;echo "################################################################"
		echo "Enabling lightdm as display manager"
		echo "################################################################"
		echo;tput sgr0
		sudo systemctl enable lightdm.service
fi

tput setaf 7;echo "################################################################"
echo "You now have a functional desktop"
echo "################################################################"
echo;tput sgr0

tput setaf 11;
echo "################################################################"
echo "Reboot your system"
echo "################################################################"
echo;tput sgr0
