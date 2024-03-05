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
alias clion="$HOME/Clion/bin/clion.sh & disown && exit"
alias addssh="ssh-add $HOME/.ssh/auth_ed25519 && ssh-add $HOME/.ssh/sign_ed25519"
alias i="sudo xbps-install -S"
alias r="sudo xbps-remove -R"
alias q="xbps-query -Rs"
alias m="micro"
alias l="exa --long --all --group --total-size"
alias ra="ranger"
