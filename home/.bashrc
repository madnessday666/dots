# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

[ ! -d $HOME/.config/wallpapers/ ] && mkdir $HOME/.config/wallpapers && ln -s $HOME/.config/scripts/theme-switcher/themes/dark/wallpapers.png $HOME/.config/wallpapers/wallpapers.png

export GPG_TTY=$(tty)
export GRADLE_HOME=$HOME/.local/share/gradle/default
export JAVA_HOME=$HOME/.jdks/default
export PATH=${GRADLE_HOME}/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/sbin:/sbin:/bin:/$HOME/.local/bin:$HOME/.jdks/default/bin
