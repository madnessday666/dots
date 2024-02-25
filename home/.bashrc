# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

export GRADLE_HOME=/usr/share/gradle/default
export JAVA_HOME=$HOME/.jdks/default
export PATH=${GRADLE_HOME}/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/sbin:/sbin:/bin:/$HOME/.local/bin:$HOME/.jdks/default/bin
