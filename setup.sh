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
		*$home/.local/bin*|*$home/.jdks/default/bin*)
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
	rm $home/Downloads/BitsNPicas.jar
	rm $home/Downloads/BreezeX_Cursor.tar.gz
	rm $home/Downloads/jdk17.tar.gz
	rm $home/Downloads/SourceCodePro.tar.xz
	rm -r -f $home/Downloads/compfy
	rm -r -f $home/Downloads/lite-xl-plugins
	rm -r -f $home/Downloads/lite-xl-colors
	rm -r -f $home/Downloads/lite-xl-terminal
	rm -r -f $home/Downloads/scientifica
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
	nr "mkdir -p .config/lite-xl"
	nr "mkdir .icons"
	nr "mkdir .jdks"
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
	xbps-install -Sy \
	alacritty alsa-plugins-pulseaudio bspwm chrony clipit curl dbus dbus-devel dbus-libs dbus-x11 \
	docker docker-compose dunst elogind exa feh ffmpeg firefox flameshot font-awesome6 gcc htop \
	libconfig libconfig-devel libconfig++ libconfig++-devel libev libev-devel libevdev libglvnd \
	libglvnd-devel libX11 libX11-devel libxcb libxcb-devel libxdg-basedir lightdm lightdm-gtk3-greeter \
	lite-xl make micro mpv neofetch NetworkManager numlockx pavucontrol pcre2 pcre2-devel pixman \
	pixman-devel polkit polybar pulseaudio python3-pipx python3-pkgconfig ranger rofi slop sxhkd \
	unzip uthash xcb-util-image xcb-util-image-devel xcb-util-renderutil xcb-util-renderutil-devel \
	xdg-utils xdotool xorg xscreensaver zsh
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
	nr "curl -L \
	"$(curl -fsSL \https://api.github.com/repos/kreativekorp/bitsnpicas/releases/latest \
				| grep -Eo "https.*BitsNPicas.jar" \
				| head -n1)" \
	--output $home/Downloads/BitsNPicas.jar"
	nr "java -jar $home/Downloads/BitsNPicas.jar \
	convertbitmap -f ttf -o $home/.local/share/fonts/scientifica.ttf \
	$home/Downloads/scientifica/src/scientifica.sfd"
	
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
	--output $home/Downloads/BreezeX_Cursor.tar.gz"
	nr "tar xfv $home/Downloads/BreezeX_Cursor.tar.gz -C $home/.icons"

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

	#Install lite-xl plugins and colorschemes
	nr "git clone https://github.com/lite-xl/lite-xl-plugins.git $home/Downloads/lite-xl-plugins"
	nr "git clone https://github.com/lite-xl/lite-xl-colors.git $home/Downloads/lite-xl-colors"
	nr "git clone https://github.com/adamharrison/lite-xl-terminal.git $home/Downloads/lite-xl-terminal"
	##Plugins
	nr "cp -R $home/Downloads/lite-xl-terminal/plugins $home/.config/lite-xl"
	nr "curl -L \
	https://github.com/adamharrison/lite-xl-terminal/releases/download/latest/libterminal.x86_64-linux.so \
	--output $home/.config/lite-xl/plugins/terminal/libterminal.x86_64-linux.so"
	while read line
		do
			case $line in
				*black* )
				replacement=$replacement"    \[  0\] = { common.color $(echo $line | sed -E -e 's/.*(.*\"#.*).*/\1/g') },\n";
				replacement=$replacement"    \[  8\] = { common.color $(echo $line | sed -E -e 's/.*(.*\"#.*).*/\1/g') },\n";
				;;
				*blue* )
				replacement=$replacement"    \[  4\] = { common.color $(echo $line | sed -E -e 's/.*(.*\"#.*).*/\1/g') },\n";
				replacement=$replacement"    \[ 12\] = { common.color $(echo $line | sed -E -e 's/.*(.*\"#.*).*/\1/g') },\n";
				;;
				*cyan* )
				replacement=$replacement"    \[  6\] = { common.color $(echo $line | sed -E -e 's/.*(.*\"#.*).*/\1/g') },\n";
				replacement=$replacement"    \[ 14\] = { common.color $(echo $line | sed -E -e 's/.*(.*\"#.*).*/\1/g') },\n";
				;;
				*green* )
				replacement=$replacement"    \[  2\] = { common.color $(echo $line | sed -E -e 's/.*(.*\"#.*).*/\1/g') },\n";
				replacement=$replacement"    \[ 10\] = { common.color $(echo $line | sed -E -e 's/.*(.*\"#.*).*/\1/g') },\n";
				;;
				*magenta* )
				replacement=$replacement"    \[  5\] = { common.color $(echo $line | sed -E -e 's/.*(.*\"#.*).*/\1/g') },\n";
				replacement=$replacement"    \[ 13\] = { common.color $(echo $line | sed -E -e 's/.*(.*\"#.*).*/\1/g') },\n";
				;;
				*red* )
				replacement=$replacement"    \[  1\] = { common.color $(echo $line | sed -E -e 's/.*(.*\"#.*).*/\1/g') },\n";
				replacement=$replacement"    \[  9\] = { common.color $(echo $line | sed -E -e 's/.*(.*\"#.*).*/\1/g') },\n";
				;;
				*white* )
				replacement=$replacement"    \[  7\] = { common.color $(echo $line | sed -E -e 's/.*(.*\"#.*).*/\1/g') },\n";
				replacement=$replacement"    \[ 15\] = { common.color $(echo $line | sed -E -e 's/.*(.*\"#.*).*/\1/g') },\n";
				;;
				*yellow* )
				replacement=$replacement"    \[  3\] = { common.color $(echo $line | sed -E -e 's/.*(.*\"#.*).*/\1/g') },\n";
				replacement=$replacement"    \[ 11\] = { common.color $(echo $line | sed -E -e 's/.*(.*\"#.*).*/\1/g') },\n";
				;;
				*colors.normal* )
				break
				;;
			esac
		done < "$dir/.config/alacritty/alacritty.toml"
	row=$row"s/.*background = { common.color \"#.*\" },.*\s/  background = { common.color \"#404040\" },/;"
	row=$row"s/.*\[  5\] = { common.color \"#.*\" },.*\s//;"
	row=$row"s/.*\[ 10\] = { common.color \"#.*\" },.*\s//;"
	row=$row"s/.*\[ 15\] = { common.color \"#.*\" },.*\s//;"
	row=$row"s/.*\[  0\] = { common.color \"#.*\" },.*\s/$replacement/"
	perl -pi -e "$row" $home/.config/lite-xl/plugins/terminal/init.lua
	cd $home/Downloads/lite-xl-plugins/plugins \
	&& nr "cp \
	align_carets.lua \
	autoinsert.lua \
	autowrap.lua \
	bracketmatch.lua \
	colorpreview.lua \
	extend_selection_line.lua \
	ghmarkdown.lua \
	indentguide.lua \
	language_*.lua \
	restoretabs.lua \
	selectionhighlight.lua \
	sort.lua \
	sticky_scroll.lua \
	su_save.lua \
	$home/.config/lite-xl/plugins"
	##Colorschemes
	nr "cp -R $home/Downloads/lite-xl-colors/colors $home/.config/lite-xl"
}

manage_services() {
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

start_installation() {
	echo "Start installation...\n"
	sleep 1

	check_env
	check_for_updates
	create_dirs
	install_main_packages
	install_external_packages
	copy_user_files
	manage_services
	clean_up
	
	echo "Installation completed, reboot now? [y/N]:"
	check_condition reboot_system quit_installation  
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

init

exit
