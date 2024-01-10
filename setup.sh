#!/bin/bash

delimiter() {

	echo "\n====================================================\n"

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

	xbps-install -y \
	alacritty bspwm dbus dbus-devel dbus-libs dbus-x11 docker dunst elogind gcc htop neofetch libconfig \
	libconfig-devel libconfig++ libconfig++-devel libev libev-devel libevdev libglvnd libglvnd-devel libX11 \
	libX11-devel libxcb libxcb-devel libxdg-basedir pcre2 pixman uthash xcb-util-image xcb-util-renderutil \
	pavucontrol polybar polkit pulseaudio python3-pipx ranger rofi sxhkd xscreensaver \

	pipx ensurepath

	pipx install meson && pipx install ninja

	cd ~

	mkdir Downloads

	cd Downloads

	git clone https://github.com/allusive-dev/compfy.git

	cd compfy

	meson setup . build

	ninja -C build

	ninja -C build install

	cd ~/Downloads

	rm -r -f compfy

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
