#!/bin/bash

user="$(logname)"
home="/home/$user"
dir="$(dirname "$(readlink -f "$0")")"

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

check_env() {
	e="$(sudo -Hiu $user env | grep ^PATH)"
	#If user have PATH variable proceed with the installation
	case $e in
		*$home/.local/bin* && *$home/.jdks/default/bin*)
		echo "PATH variable is OK";
		;;
		*)
		echo "
			\r====================================================
			\nPATH variable needs to be updated to continue \
			\n(this will be done automatically), \
			\nyou will need to log in and rerun the script.
			\n[Press Enter to continue]
			\n====================================================\n"
			#Set PATH variable
			read input
				if [ ! -f $home/.bashrc ]; then
					nr "echo -e \
					#!/bin/bash\n\nexport $e:$home/.local/bin:$home/.jdks/default/bin" \
					tee -a $home/.bashrc >/dev/null
						else
					nr "echo -e \
					\nexport $e:$home/.local/bin:$home/.jdks/default/bin" \
					| tee -a $home/.bashrc >/dev/null
				fi
			#Logout
			pid="$(who -u | awk '{print $6}')"
			kill $pid
			;;
	esac
}

check_for_updates() {
	echo "
	\r====================================================
	\nCheck for updates...\n"
	sleep 1
	xbps-install -Syu
	echo "
	\rSystem files updated!
	\n====================================================\n"
	sleep 2
}

clean_up() {
	rm $home/Downloads/SourceCodePro.tar.xz
	rm $home/Downloads/cursor.tar.gz
	rm -r -f $home/Downloads/compfy
	rm -r -f $home/Downloads/lite-xl
	rm -r -f $home/Downloads/scientifica
	xbps-remove -R fontforge
}

copy_user_files() {
	cd $dir
	nr "cp -r .config $home"
	nr "cp -r settings/user/. $home"
	nr "cp -r settings/zsh/. $home/.oh-my-zsh/themes"
	cp .config/wallpapers/wallpapers.png /etc/lightdm/ && cp -r settings/dm/. /etc/lightdm/
}

create_dirs() {
	cd $home
	nr "mkdir Downloads"
	nr "mkdir Screenshots"
	nr "mkdir Screenrecs"
	nr "mkdir .icons"
	nr "mkdir .jdks"
	nr "mkdir -p $home/.config/lite-xl/plugins"
	nr "mkdir -p $home/.local/share/fonts"
}

init() {
	
echo "
             ██╗   ██╗ ██████╗ ██╗██████╗     ██╗     ██╗███╗   ██╗██╗   ██╗██╗  ██╗               
             ██║   ██║██╔═══██╗██║██╔══██╗    ██║     ██║████╗  ██║██║   ██║╚██╗██╔╝               
             ██║   ██║██║   ██║██║██║  ██║    ██║     ██║██╔██╗ ██║██║   ██║ ╚███╔╝                
             ╚██╗ ██╔╝██║   ██║██║██║  ██║    ██║     ██║██║╚██╗██║██║   ██║ ██╔██╗                
              ╚████╔╝ ╚██████╔╝██║██████╔╝    ███████╗██║██║ ╚████║╚██████╔╝██╔╝ ██╗               
               ╚═══╝   ╚═════╝ ╚═╝╚═════╝     ╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝               
                                                                                              
███████╗███████╗████████╗██╗   ██╗██████╗     ██╗  ██╗███████╗██╗     ██████╗ ███████╗██████╗ 
██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗    ██║  ██║██╔════╝██║     ██╔══██╗██╔════╝██╔══██╗
███████╗█████╗     ██║   ██║   ██║██████╔╝    ███████║█████╗  ██║     ██████╔╝█████╗  ██████╔╝
╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝     ██╔══██║██╔══╝  ██║     ██╔═══╝ ██╔══╝  ██╔══██╗
███████║███████╗   ██║   ╚██████╔╝██║         ██║  ██║███████╗███████╗██║     ███████╗██║  ██║
╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝         ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝     ╚══════╝╚═╝  ╚═╝
                                                                                              
                                ██╗   ██╗     ██╗    ██████╗                                          
                                ██║   ██║    ███║   ██╔═████╗                                         
                                ██║   ██║    ╚██║   ██║██╔██║                                         
                                ╚██╗ ██╔╝     ██║   ████╔╝██║                                         
                                 ╚████╔╝      ██║██╗╚██████╔╝                                         
                                  ╚═══╝       ╚═╝╚═╝ ╚═════╝                                          
                                                                                              "
	sleep 1
	echo "Do you want to continue? [y/N]:"
	check_condition start_installation quit_installation
}

install_main_packages() {
	xbps-install -y \
	alacritty alsa-plugins-pulseaudio bspwm chrony curl dbus dbus-devel dbus-libs dbus-x11 \
	docker docker-compose dunst elogind exa feh ffmpeg firefox flameshot font-awesome6 \
	fontforge gcc htop libconfig libconfig-devel libconfig++ libconfig++-devel libev \
	libev-devel libevdev libglvnd libglvnd-devel libX11 libX11-devel libxcb libxcb-devel \
	libxdg-basedir lightdm lightdm-gtk3-greeter lite-xl make micro mpv neofetch NetworkManager \
	numlockx pavucontrol pcre2 pcre2-devel pixman pixman-devel polkit polybar pulseaudio \
	python3-pipx python3-pkgconfig ranger rofi slop sxhkd unzip uthash xcb-util-image \
	xcb-util-image-devel xcb-util-renderutil xcb-util-renderutil-devel xdg-utils xdotool \
	xorg xscreensaver zsh
}

start_installation() {
	echo "Start installation...\n"
	sleep 1

	check_env
	check_for_updates
	create_dirs
	install_main_packages
	install_external_packages
	copy_user_files
	manage_service
	clean_up
	
	echo "Installation completed, reboot now? [y/N]:"
	check_condition reboot_system quit_installation  
}

install_external_packages() {
	#Install JetBrainsMono font
	nr "curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh" | nr bash
	
	#Install ohmyzsh
	nr "curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh" | nr bash --unattended

	#Install ranger devicons
	nr "git clone https://github.com/alexanderjeurissen/ranger_devicons $home/.config/ranger/plugins/ranger_devicons"

	#Install JDK
	nr "curl -L \
	"$(curl -fsSL https://api.github.com/repos/adoptium/temurin17-binaries/releases/latest \
	| grep -Eo "https.*OpenJDK17U-jdk.*x64_linux.*\.tar\.gz" \
	| head -n1)" \
	--output $home/Downloads/jdk17.tar.gz"
	nr "tar xfv $home/Downloads/jdk17.tar.gz -C $home/.jdks"
	nr "ln -s $home/.jdks/jdk* $home/.jdks/default"

	#Install scientifica font
	nr "git clone https://github.com/Computer-M/scientifica.git $home/Downloads/scientifica"
	nr "curl -o BitsNPicas.jar \
	https://github.com/kreativekorp/bitsnpicas/blob/master/downloads/BitsNPicas.jar \
	--output-dir $home/Downloads/scientifica"
	cd $home/Downloads/scientifica && nr "bash $home/Downloads/scientifica/build.sh"
	nr "cp $home/Downloads/scientifica/build/scientifica/otb/scientifica.otb \
	$home/.local/share/fonts"
	
	#Install SourceCodePro (Nerd patched) font
	nr "curl -L \
	https://github.com/ryanoasis/nerd-fonts/releases/latest/download/SourceCodePro.tar.xz \
	--output $home/Downloads/SourceCodePro.tar.xz"
	nr "tar xfv $home/Downloads/SourceCodePro.tar.xz -C $home/.local/share/fonts"

	#Install Breeze Light cursor
	nr "curl -L \
	"$(curl -fsSL https://api.github.com/repos/ful1e5/BreezeX_Cursor/releases/latest \
	| grep -Eo 'http.*Light*\.tar\.gz' \
	| head -n1)" \
	--output $home/Downloads/cursor.tar.gz"
	nr "tar xfv $home/Downloads/cursor.tar.gz -C $home/.icons"

	#Install meson and ninja
	nr "pipx install meson"
	nr "pipx install ninja"
	nr "pipx ensurepath"

	#Install compfy
	nr "git clone https://github.com/allusive-dev/compfy.git $home/Downloads/compfy"
	cd $home/Downloads/compfy \
	&& meson setup . build \
	&& ninja -C build \
	&& ninja -C build install

	#Install lite-xl and plugins
	nr "git clone https://github.com/lite-xl/lite-xl-plugins.git $home/Downloads/lite-xl"
	cd $home/Downloads/lite-xl/plugins \
	&& nr "cp \
	align_carets.lua \
	autoinsert.lua \
	autowrap.lua \
	ghmarkdown.lua \
	colorpreview.lua \
	selectionhighlight.lua \
	language_*.lua \
	$home/.config/lite-xl/plugins"
}

manage_service() {
	echo "
	\r====================================================
	\nManaging Services..."
	sleep 1
	
	#Autostart settings
	ln -s /etc/sv/chronyd /var/service/
	ln -s /etc/sv/containerd /var/service/
	ln -s /etc/sv/dbus /var/service/
	ln -s /etc/sv/docker /var/service/
	ln -s /etc/sv/elogind /var/service/
	ln -s /etc/sv/lightdm /var/service/
	ln -s /etc/sv/NetworkManager /var/service/
	ln -s /etc/sv/polkitd /var/service/

	#Remove conflicting services
	cd /var/service
	rm -rf acpid
	rm -rf wpa_supplicant
	rm -rf dhcpcd*

	#Add user to group 'power' and create rule for non root power management 
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
 	})' | tee -a /etc/polkit-1/rules.d/*.rules >/dev/null

	#Change shell to zsh
	chsh -s /bin/zsh $user

	echo "
	\rService managing completed!
	\n====================================================\n"
 	
	sleep 2
}

#Run command as non root user
nr() {
	runuser -u $user -- $1
}

reboot_system() {
	echo "
	\r====================================================
	\nReboot in progress...
	\n====================================================\n"
	sleep 2
	reboot
}

quit_installation() {
	echo "
	\r====================================================
	\nQuit installation...
	\n====================================================\n"
	exit
}

check_env

exit
