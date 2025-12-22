# Towared root navigations
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# General Shortcuts
alias g=git
alias gs="git status"
alias n="nvim"

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

alias discord='(cd /mnt/c/Users/nsing/AppData/Local/Discord/app-1.0.9219; cmd.exe /c start Discord.exe)'
alias steam='(cd /mnt/c/Program\ Files\ \(x86\)/Steam; cmd.exe /c start steam.exe)'
