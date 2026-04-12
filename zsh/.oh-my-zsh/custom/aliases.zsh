# Towared root navigations
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# General Shortcuts
alias structure="lsd --tree --depth 3"
alias n="nvim ."
alias c="clear"
alias ccd="pwd | c" # copy current directory

# Print each PATH entry on a seperate line
alias path='echo -e ${PATH//:/\\n}'

# refresh terminal
alias so="source ~/.zshrc"

# maybe use locate function instead of fzf?
alias f='fzf --height=90% --preview "bat --style=numbers --color=always --line-range :500 {}" --preview-window right,border-left  --padding=0'

# tmux
alias t=tmux
alias tns='tmux new -s '
alias tls='tmux ls'

# git 
alias g=git
alias gs="git status"
alias total="git log --oneline | wc -l"
