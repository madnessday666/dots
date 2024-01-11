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

check_env() {

	e="$(sudo -Hiu $user env | grep ^PATH)"

	case $e in

		*$home/.local/bin*)

		install_packages;

		exit

		;;

	esac

	delimiter

	echo "An environment variable must be set to continue,\nyou must log in again and run the script \n[Press Enter to continue]"

	delimiter

	echo $e":"$home/.local/bin >> $home/.bashrc

	read input

	pid="$(who -u | awk '{print $6}')"

	kill $pid

}

create_dirs_and_move_files() {

	cd $home

	nonroot 'mkdir Downloads'

	nonroot 'mkdir Screenshots'

	nonroot "mkdir -p $home/.local/share/fonts"

	cd $dir

	nonroot "cp -r fonts/. $home/.local/share/fonts"

	nonroot "cp -r settings/. $home"

	nonroot "cp -r .config $home"

}

service_setup() {

	ln -s /etc/sv/containerd /var/service/

	ln -s /etc/sv/dbus /var/service/

	ln -s /etc/sv/docker /var/service/

	ln -s /etc/sv/elogind /var/service/

	ln -s /etc/sv/NetworkManager /var/service/

	ln -s /etc/sv/polkitd /var/service/

	cd /var/service

	rm -rf acpid

	rm -rf wpa_supplicant

	rm -rf dhcpcd*

	groupadd power

	usermod -aG power $user

	echo '\npolkit.addRule(function(action, subject) {
	if ((action.id == "org.freedesktop.login1.reboot" ||
          	action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
          	action.id == "org.freedesktop.login1.power-off" ||
          	action.id == "org.freedesktop.login1.power-off-multiple-sessions" ||
          	action.id == "org.freedesktop.login1.suspend" ||
          	action.id == "org.freedesktop.login1.suspend-multiple-sessions" ||
          	action.id == "org.freedesktop.login1.hibernate" ||
          	action.id == "org.freedesktop.login1.hibernate-multiple-sessions") && subject.isInGroup("power"))
     	{
     	return polkit.Result.YES;
     	}
 	})' | tee -a /etc/polkit-1/rules.d/*.rules

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

	create_dirs_and_move_files

	xbps-install -y \
	alacritty bspwm curl dbus dbus-devel dbus-libs dbus-x11 docker dunst elogind feh firefox flameshot \
	gcc htop leafpad libconfig libconfig-devel libconfig++ libconfig++-devel libev libev-devel libevdev \
	libglvnd libglvnd-devel libX11 libX11-devel libxcb libxcb-devel libxdg-basedir make nano neofetch \
	NetworkManager numlockx pavucontrol pcre2 pcre2-devel pixman pixman-devel polkit polybar pulseaudio \
	python3-pipx python3-pkgconfig ranger rofi sxhkd unzip uthash xcb-util-image xcb-util-image-devel \
	xcb-util-renderutil xcb-util-renderutil-devel xorg xscreensaver zsh

	runuser -u $user -- bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"

	runuser -u $user -- bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

	cd .oh-my-zsh/custom && nonroot 'git clone https://github.com/spaceship-prompt/spaceship-prompt.git'

	ln -s $home/.oh-my-zsh/custom/spaceship-prompt/spaceship.zsh-theme $home/.oh-my-zsh/themes/spaceship.zsh-theme

	echo "default_linemode devicons" >> $home/.config/ranger/rc.conf

	nonroot "git clone https://github.com/alexanderjeurissen/ranger_devicons $home/.config/ranger/plugins/ranger_devicons"

	nonroot 'pipx install meson'

	nonroot 'pipx install ninja'

	nonroot 'pipx ensurepath'

	cd $home/Downloads && nonroot 'git clone https://github.com/allusive-dev/compfy.git' && cd compfy

	meson setup . build && ninja -C build && ninja -C build install

	cd $home/Downloads && rm -r -f compfy

	cd $home/.config/polybar && chmod +x launch.sh

	chsh -s /bin/zsh $user

	service_setup

	delimiter

	echo "Installation completed, reboot now? [y/N]:"

	check_condition reboot_system quit_installation

}

init() {

	delimiter

	echo "\nSetup script v1.0 for Void Linux\n"

	delimiter

	#sleep 2

	echo "Do you want to continue? [y/N]:"

	check_condition check_env quit_installation

}

create_dirs_and_move_files

exit

#init
