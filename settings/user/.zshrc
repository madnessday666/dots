

#  $██████╗$██████╗$███╗$$$██╗███████╗██╗$██████╗$
#  ██╔════╝██╔═══██╗████╗$$██║██╔════╝██║██╔════╝$
#  ██║$$$$$██║$$$██║██╔██╗$██║█████╗$$██║██║$$███╗
#  ██║$$$$$██║$$$██║██║╚██╗██║██╔══╝$$██║██║$$$██║
#  ╚██████╗╚██████╔╝██║$╚████║██║$$$$$██║╚██████╔╝
#  $╚═════╝$╚═════╝$╚═╝$$╚═══╝╚═╝$$$$$╚═╝$╚═════╝$
#  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="my"

plugins=(git)

source $HOME/.bashrc
source $ZSH/oh-my-zsh.sh

alias idea="nohup $HOME/Intellij-Idea/bin/idea.sh & disown && exit"
alias i="sudo xbps-install -S"
alias r="sudo xbps-remove -R"
alias q="xbps-query -Rs"
alias m="micro"
alias l="exa --long --all --group --total-size"

___MY_VMOPTIONS_SHELL_FILE="${HOME}/.jetbrains.vmoptions.sh"; if [ -f "${___MY_VMOPTIONS_SHELL_FILE}" ]; then . "${___MY_VMOPTIONS_SHELL_FILE}"; fi
