#!/bin/bash

user="$(logname)"
home=$(sudo -u "$user" sh -c 'echo $HOME')
dir="$(dirname "$(readlink -f "$0")")"

#Run command as non root user
as_user() {
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

check_for_updates() {
  echo "================================Check for updates===============================\n"
  sleep 1

  xbps-install -Syu

  echo "\n==============================System files updated!=============================\n"
  sleep 2
}

clean_up() {
  echo "===================================Cleaning up==================================\n"
  sleep 1

  rm $home/Downloads/BitsNPicas.jar
  rm $home/Downloads/jdk17.tar.gz
  rm $home/Downloads/SourceCodePro.tar.xz
  rm -r -f $home/Downloads/compfy
  rm -r -f $home/Downloads/Graphite-gtk-theme
  rm -r -f $home/Downloads/lite-xl-plugins
  rm -r -f $home/Downloads/lite-xl-colors
  rm -r -f $home/Downloads/lite-xl-terminal
  rm -r -f $home/Downloads/scientifica

  xbps-remove -R sassc

  echo "==============================Сleanup is complete!==============================\n"
  sleep 2 
}

configure_path_var() {
  echo "===========================PATH variable configuration==========================\n"
  sleep 1

  export PATH=$PATH:$home/.local/bin:$home/.jdks/default/bin

  echo "====================PATH variable configuration is complete!====================\n"
  sleep 2
}

configure_services() {
  echo "==============================Configuring services==============================\n"
  sleep 1

  #Autostart settings
  ln -s /etc/sv/chronyd /var/service/
  ln -s /etc/sv/containerd /var/service/
  ln -s /etc/sv/dbus /var/service/
  ln -s /etc/sv/docker /var/service/
  ln -s /etc/sv/lightdm /var/service/
  ln -s /etc/sv/NetworkManager /var/service/
  ln -s /etc/sv/polkitd /var/service/

  #Remove conflicting services
  cd /var/service
  rm -rf acpid
  rm -rf wpa_supplicant
  rm -rf dhcpcd*

  echo "=======================Service configuration is complete!=======================\n"
  sleep 2
}

copy_user_files() {
  echo "===============================Copying user files===============================\n"
  sleep 1

  echo "                        What to do with the users files :\n
  1) Copy files 
  2) Symlink files
  3) Show user files
  4) Do nothing
  "
  while [ true ]; do
    read -r input
    case $input in
      1 )
      as_user "cp -r $dir/home/. $home"
      break
      ;;
      2 )
      #There's no point in symlinking the .icons/
      as_user "cp -r $dir/home/.icons $home"
      as_user "ln -sf $dir/home/.bashrc $home"
      as_user "ln -sf $dir/home/.xinitrc $home"
      as_user "ln -sf $dir/home/.xscreensaver $home"
      as_user "ln -sf $dir/home/.zshrc $home"
      as_user "ln -sf $dir/home/.oh-my-zsh/themes/* $home/.oh-my-zsh/themes"
      dirs=$(ls -Ap $dir/home/.config)
      for d in ${dirs}; do
        if [ -d $home/.config/$d ]; then
          as_user "ln -sf $dir/home/.config/$d* $home/.config/$d"
        else
          as_user "ln -sf $dir/home/.config/$d $home/.config"
        fi
      done
      break
      ;;
      3 )
      echo $(ls -Ap $dir/home/)
      ;;
      4 )
      break
      ;;
      * )
      echo "                               Enter valid number"
      ;;
    esac
  done
  cp -r $dir/dm/. /etc/lightdm

  echo "\n=======================Сopying of user files is complete!=======================\n"
  sleep 2
}

create_user_dir() {
  echo "============================Creating user directories===========================\n"
  sleep 1

  cd $home
  as_user "mkdir Downloads"
  as_user "mkdir Screenshots"
  as_user "mkdir Screenrecs"
  as_user "mkdir .ssh"
  as_user "mkdir .jdks"

  echo "======================User directory creation is complete!======================\n"
  sleep 2
}

init() {
echo "
     ██╗   ██╗ ██████╗ ██╗██████╗     ██╗     ██╗███╗   ██╗██╗   ██╗██╗  ██╗
     ██║   ██║██╔═══██╗██║██╔══██╗    ██║     ██║████╗  ██║██║   ██║╚██╗██╔╝
     ██║   ██║██║   ██║██║██║  ██║    ██║     ██║██╔██╗ ██║██║   ██║ ╚███╔╝
     ╚██╗ ██╔╝██║   ██║██║██║  ██║    ██║     ██║██║╚██╗██║██║   ██║ ██╔██╗
      ╚████╔╝ ╚██████╔╝██║██████╔╝    ███████╗██║██║ ╚████║╚██████╔╝██╔╝ ██╗
       ╚═══╝   ╚═════╝ ╚═╝╚═════╝     ╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝
 
                     ██████╗  ██████╗ ████████╗███████╗
                     ██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝
                     ██║  ██║██║   ██║   ██║   ███████╗
                     ██║  ██║██║   ██║   ██║   ╚════██║
                     ██████╔╝╚██████╔╝   ██║   ███████║
                     ╚═════╝  ╚═════╝    ╚═╝   ╚══════╝
 
     ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ███████╗██████╗
     ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██╔════╝██╔══██╗
     ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     █████╗  ██████╔╝
     ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██╔══╝  ██╔══██╗
     ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗███████╗██║  ██║
     ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝
"
  sleep 1
  echo "                       Do you want to continue? [y/N]:"
  check_condition start_installation quit_installation
}

install_external_packages() {
  echo "==========================Installing external packages==========================\n"
  sleep 1

  #Install ohmyzsh
  as_user "curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh" | as_user bash --unattended
  ##Change shell to zsh
  chsh -s /bin/zsh $user

  #Install ranger devicons
  as_user "git clone https://github.com/alexanderjeurissen/ranger_devicons $home/.config/ranger/plugins/ranger_devicons"

  #Install meson and ninja
  as_user "pipx install meson"
  as_user "pipx install ninja"

  #Install compfy
  as_user "git clone https://github.com/allusive-dev/compfy.git $home/Downloads/compfy"
  cd $home/Downloads/compfy \
  && meson setup . build \
  && ninja -C build \
  && ninja -C build install

  #Install JDK
  as_user "curl -L \
    "$(curl -fsSL https://api.github.com/repos/adoptium/temurin17-binaries/releases/latest \
    | grep -Eo "https.*OpenJDK17U-jdk.*x64_linux.*\.tar\.gz" \
    | head -n1)" \
  --output $home/Downloads/jdk17.tar.gz"
  as_user "tar xfv $home/Downloads/jdk17.tar.gz -C $home/.jdks"
  as_user "ln -s $home/.jdks/jdk* $home/.jdks/default"

  #Install JetBrainsMono font
  as_user "curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh" | as_user bash

  #Install scientifica font
  as_user "git clone https://github.com/Computer-M/scientifica.git $home/Downloads/scientifica"
  as_user "curl -L \
    "$(curl -fsSL \https://api.github.com/repos/kreativekorp/bitsnpicas/releases/latest \
    | grep -Eo "https.*BitsNPicas.jar" \
    | head -n1)" \
  --output $home/Downloads/BitsNPicas.jar"
  as_user "java -jar $home/Downloads/BitsNPicas.jar \
  convertbitmap -f ttf -o $home/.local/share/fonts/scientifica.ttf \
  $home/Downloads/scientifica/src/scientifica.sfd"

  #Install SourceCodePro (Nerd patched) font
  as_user "curl -L \
  https://github.com/ryanoasis/nerd-fonts/releases/latest/download/SourceCodePro.tar.xz \
  --output $home/Downloads/SourceCodePro.tar.xz"
  as_user "tar xfv $home/Downloads/SourceCodePro.tar.xz -C $home/.local/share/fonts"

  #Install Grpahite-gtk-theme
  as_user "git clone https://github.com/vinceliuice/Graphite-gtk-theme.git $home/Downloads/Graphite-gtk-theme"
  as_user "bash -c $home/Downloads/Graphite-gtk-theme/install.sh --tweaks rimless"

  #Install lite-xl plugins and colors
  as_user "git clone https://github.com/lite-xl/lite-xl-plugins.git $home/Downloads/lite-xl-plugins"
  as_user "git clone https://github.com/lite-xl/lite-xl-colors.git $home/Downloads/lite-xl-colors"
  as_user "git clone https://github.com/adamharrison/lite-xl-terminal.git $home/Downloads/lite-xl-terminal"
  as_user "mkdir -p $home/.config/lite-xl"
  ##Install lite-xl terminal plugin
  as_user "cp -R $home/Downloads/lite-xl-terminal/plugins $home/.config/lite-xl"
  as_user "curl -L \
  https://github.com/adamharrison/lite-xl-terminal/releases/download/latest/libterminal.x86_64-linux.so \
  --output $home/.config/lite-xl/plugins/terminal/libterminal.x86_64-linux.so"
  ##Get the colors from alacritty.toml and set them in the lite-xl terminal.
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
  done < "$dir/home/.config/scripts/theme-switcher/themes/dark/alacritty.toml"
  bgColor=$(cat $dir/home/.config/scripts/theme-switcher/themes/dark/alacritty.toml | grep background | cut -d ' ' -f 3)
  fgColor=$(cat $dir/home/.config/scripts/theme-switcher/themes/dark/alacritty.toml | grep foreground | cut -d ' ' -f 3)
  row=$row"s/.*background = { common.color \"#.*\".*/  background = { common.color $bgColor },/;"
  row=$row"s/.*text = { common.color \"#.*\".*/  text = { common.color $fgColor },/;"
  row=$row"s/.*\[  5\] = { common.color \"#.*\" },.*\s//;"
  row=$row"s/.*\[ 10\] = { common.color \"#.*\" },.*\s//;"
  row=$row"s/.*\[ 15\] = { common.color \"#.*\" },.*\s//;"
  row=$row"s/.*\[  0\] = { common.color \"#.*\" },.*\s/$replacement/"
  perl -pi -e "$row" $home/.config/lite-xl/plugins/terminal/init.lua
  ##Install the other plugins
  cd $home/Downloads/lite-xl-plugins/plugins \
  && as_user "cp \
  align_carets.lua \
  autoinsert.lua \
  autowrap.lua \
  bracketmatch.lua \
  colorpreview.lua \
  extend_selection_line.lua \
  fontconfig.lua \
  ghmarkdown.lua \
  indentguide.lua \
  language_*.lua \
  restoretabs.lua \
  selectionhighlight.lua \
  select_colorscheme.lua \
  sort.lua \
  sticky_scroll.lua \
  su_save.lua \
  $home/.config/lite-xl/plugins"
  ##Install the color schemes
  as_user "cp -R $home/Downloads/lite-xl-colors/colors $home/.config/lite-xl"

  echo "\n=================Installation of external packages is complete!=================\n"
  sleep 2
}

install_repo_packages() {
  echo "==================Installing packages from the main repository==================\n"
  sleep 1

  xbps-install -Sy \
  alacritty alsa-plugins-pulseaudio bluez blueman bspwm breeze-obsidian-cursor-theme breeze-snow-cursor-theme \
  btop chrony curl dbus dbus-devel dbus-libs dbus-x11 docker docker-compose dunst elogind exa feh ffmpeg firefox \
  flameshot font-awesome6 gcc libconfig libconfig-devel libconfig++ libconfig++-devel libev libev-devel libevdev \
  libglvnd libglvnd-devel libX11 libX11-devel libxcb libxcb-devel libxdg-basedir lightdm lightdm-mini-greeter \
  lite-xl make micro mpv neofetch NetworkManager numlockx pavucontrol pcre2 pcre2-devel pixman pixman-devel polkit \
  polybar pulseaudio python3-pipx python3-pkgconfig ranger rofi sassc slop sxhkd unzip uthash xcb-util-image \
  xcb-util-image-devel xcb-util-renderutil xcb-util-renderutil-devel xdg-utils xdotool xcmenu xorg xscreensaver zip zsh

  echo "\n===========Installation packages from the main repository is complete!==========\n"
  sleep 2
}

quit_installation() {
  echo "\n==============================Quit the installation============================="
  exit
}

reboot_system() {
  echo "\n====================================Rebooting==================================="
  sleep 1
  reboot
}

start_installation() {
  echo "\n===============================Start installation===============================\n"
  sleep 1

  configure_path_var
  check_for_updates
  create_user_dir
  install_repo_packages
  install_external_packages
  configure_services
  copy_user_files
  clean_up

  echo "Installation completed, reboot now? [y/N]:"
  check_condition reboot_system quit_installation
}

init

exit
