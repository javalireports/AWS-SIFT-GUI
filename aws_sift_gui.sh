#!/bin/bash

c='\e[32m' # Coloured echo (Green)
y=$'\033[38;5;11m' # Coloured echo (yellow)
r='tput sgr0' #Reset colour after echo

#Display Banner
if [[ ! -z $(which figlet) ]]; then
    figlet -f slant AWS-SIFT-GUI -c
    echo -e "${y}                       - By Arvind Javali"
else 
echo -e "\n
        ___ _       _______      _____ ________________    ________  ______
       /   | |     / / ___/     / ___//  _/ ____/_  __/   / ____/ / / /  _/
      / /| | | /| / /\__ \______\__ \ / // /_    / /_____/ / __/ / / // /  
     / ___ | |/ |/ /___/ /_____/__/ // // __/   / /_____/ /_/ / /_/ // /   
    /_/  |_|__/|__//____/     /____/___/_/     /_/      \____/\____/___/   
										- By Arvind Javali\n\n\n"
fi
echo -e "\n
#########################################################################################
# Author: Arvind Javali                                                                 #
# Description: Bash script to setup GUI for AWS SIFT and access SIFT workstation using  #
# Remote Desktop Protocol.                                                              #
# Tested against Debian based distributions like AWS SIFT AMI [ami-0b9ef98f6dbcfe23d]   #
# Version: 1.00                                                                         #
#########################################################################################
\n"

# 3 seconds wait time to start the setup
for i in `seq 3 -1 1` ; do echo -ne "$i\rThe setup will start in... " ; sleep 1 ; done

echo -e "\n"
# Required dependencies for all softwares (important)
echo -e "${c}Installing complete dependencies pack.\n"; $r
#Nothing at the moment


# Show Battery Percentage on Top Bar [Debian (gnome)]
if [[ $XDG_CURRENT_DESKTOP =~ 'GNOME' ]]; then
	gsettings set org.gnome.desktop.interface show-battery-percentage true
fi


# Upgrade and Update Command
echo -e "${c}Updating and upgrading before performing further operations."; $r
sudo apt update


#Executing Install Dialog
dialogbox=(whiptail --separate-output --ok-button "Install" --title "AWS SIFT Tools Setup " --checklist "\nPlease select required software(s):\n(Press 'Space' to Select/Deselect, 'Enter' to Install and 'Esc' to Cancel)" 30 80 20)
options=(1 "RDP setup for SIFT (aws)" off
		 2 "Wine" off
         3 "Just run the upgrades for me" off)

selected=$("${dialogbox[@]}" "${options[@]}" 2>&1 >/dev/tty)

for choices in $selected
do
	case $choices in
		1) 
		echo -e "${c}Installing GUI for SIFT Workstation AWS"; $r
		sudo apt-get install -y lxde xrdp xfce4 xfce4-goodies tightvncserver
		echo -e "\n\nSetup password for root user"
		sudo passwd root
		sudo service xrdp start
		echo xfce4-session> /home/sansforensics/.xsession
		sudo cp /home/sansforensics/.xsession /etc/skel
		sudo sed -i '0,/-1/s//ask-1/' /etc/xrdp/xrdp.ini
		echo -e "\n
       /   | |     / / ___/     / ___//  _/ ____/_  __/   / ____/ / / /  _/
      / /| | | /| / /\__ \______\__ \ / // /_    / /_____/ / __/ / / // /  
     / ___ | |/ |/ /___/ /_____/__/ // // __/   / /_____/ /_/ / /_/ // /   
    /_/  |_|__/|__//____/     /____/___/_/     /_/      \____/\____/___/   
		\n"
		echo -e "${c}GUI for SIFT Installed Successfully."; $r
		echo -e "To access GUI, use RDP (MSTSC.exe) from your Windows machine and enter login details"
		echo -e "\nYour public IP:" && curl ifconfig.me
		echo -e "\n\nUsername:" && whoami
		echo -e "\nPassword: \nforensics"
		;;

		2)
		echo -e "${c}Installing Wine"; $r
		sudo apt-get install -y wget
		wget -O- -q https://dl.winehq.org/wine-builds/winehq.key | sudo apt-key add -
		sudo add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ xenial main'
		sudo apt-get update -y
		sudo apt install -y --install-recommends winehq-stable
		echo -e "${c}Wine Installed Successfully.\n"; $r
		;;

		3)
		echo -e "${c}Cancel the Setup"; $r
		echo -e "Atleast do you want to do the upgardes?" 
		sudo apt upgrade -y
		sudo apt --fix-broken install -y
		sudo apt autoremove -y
	esac
done
