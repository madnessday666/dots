# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

export SSH_AUTH_SOCK=${HOME}/.ssh/agent
if ! pgrep -u ${USER} ssh-agent > /dev/null; then
  rm -f ${SSH_AUTH_SOCK}
fi
if [ ! -S ${SSH_AUTH_SOCK} ]; then
  eval $(ssh-agent -a ${SSH_AUTH_SOCK} 2> /dev/null)
fi

export GRADLE_HOME=$HOME/.local/share/gradle/default
export JAVA_HOME=$HOME/.jdks/default
export PATH=${GRADLE_HOME}/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/sbin:/sbin:/bin:/$HOME/.local/bin:$HOME/.jdks/default/bin
