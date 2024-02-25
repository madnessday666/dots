

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

alias idea="$HOME/IntellijIdea/bin/idea.sh & disown && exit"
alias i="sudo xbps-install -S"
alias r="sudo xbps-remove -R"
alias q="xbps-query -Rs"
alias m="micro"
alias l="exa --long --all --group --total-size"
alias ra="ranger"
