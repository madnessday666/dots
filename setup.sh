#!/bin/bash

user="$(logname)"
home=/home/$user
dir="$(dirname "$(readlink -f "$0")")"

delimiter() {

	echo "\n====================================================\n"

}

nonroot() {

	runuser -u $user -- $1

}

check_condition() {

	while [ true ]; do

		read -r input

		if [ $input = "y" ] || [ $input = "Y" ]; then

			($1)

			break

		elif [ $input = "n" ] || [ $input = "N" ]; then

			($2)

			break

		fi

	done

}

quit_installation() {

	delimiter

	echo "\nQuit installation...\n"

	delimiter

	exit

}

reboot_system() {

	delimiter

	echo "\nReboot in progress...\n"

	delimiter

	reboot

}

check_for_updates() {

	echo "\nCheck for updates...\n"

	xbps-install -Syu
}

install_packages() {

	check_for_updates

	echo "\nStart installation...\n"

	cd $dir && cd .. && nonroot 'cp -r dots/. '$home && rm setup.sh

	exit

	xbps-install -y \
	alacritty bspwm dbus dbus-devel dbus-libs dbus-x11 docker dunst elogind firefox flameshot \
	gcc htop leafpad libconfig libconfig-devel libconfig++ libconfig++-devel libev libev-devel \
	libevdev libglvnd libglvnd-devel libX11 libX11-devel libxcb libxcb-devel libxdg-basedir nano \
	neofetch NetworkManager numlockx pavucontrol pcre2 pcre2-devel pixman pixman-devel polkit \
	polybar pulseaudio python3-pipx python3-pkgconfig ranger rofi sxhkd uthash xcb-util-image \
	xcb-util-image-devel xcb-util-renderutil xcb-util-renderutil-devel xorg xscreensaver

	nonroot 'pipx install meson'

	nonroot 'pipx install ninja'

	nonroot 'pipx ensurepath'

	cd $home && nonroot 'mkdir Downloads'

	cd Downloads && nonroot 'git clone https://github.com/allusive-dev/compfy.git' && cd compfy

	nonroot 'meson setup . build' && nonroot 'ninja -C build' && nonroot 'ninja -C build install'

	cd $home/Downloads && rm -r -f compfy

	ln -s /etc/sv/containerd /var/service/

	ln -s /etc/sv/dbus /var/service/

	ln -s /etc/sv/docker /var/service/

	ln -s /etc/sv/elogind /var/service/

	ln -s /etc/sv/NetworkManager /var/service/

	ln -s /etc/sv/polkitd /var/service/

	cd /etc/sv
	
	rm acpid 
	
	rm wpa_supplicant
	
	rm dhcpcd*

	delimiter

	echo "Installation completed, reboot now? [y/N]:"

	check_condition reboot_system quit_installation

}

init() {

	delimiter

	echo "\nSetup script v1.0 for Void Linux\n"

	delimiter

	sleep 2

	echo "Do you want to continue? [y/N]:"

	check_condition install_packages quit_installation

}

init
