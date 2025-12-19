# zshrc functions

# Function to find directory and cd or for a file, extract its parent directory with dirname and cd
# old fzf config: fzf --preview 'bat --color=always {} 2>/dev/null || cat {}'
# new fzf config requires bat in replacement of cat, install with brew install bat or apt install bat

function lcd() {
  local file=$(locate -i "$1" | fzf --preview 'bat --style=numbers --color=always --line-range :500 {} 2>/dev/null || ls -lah --color=always {} 2>/dev/null || echo "¯\(ツ)/¯"' \
    --preview-window right:50%:border-left)

  if [[ -n "$file" ]]; then
    if [[ -d "$file" ]]; then
      cd "$file" && pwd
    else
      cd "$(dirname "$file")" && pwd
    fi
  fi
}

# Find file and edit it - does not cd to its directory, we stay in our current directory 
# If we led to a directory and not a file, it will open that directory in nvim which is fine
function led() {
  local file=$(locate -i "$1" | fzf --preview 'bat --style=numbers --color=always --line-range :500 {} 2>/dev/null || ls -lah --color=always {} 2>/dev/null || echo "¯\(ツ)/¯"' \
    --preview-window right:50%:border-left)

  if [[ -n "$file" ]]; then
    nvim "$file"
  fi
}

# add function with fzf config to search current directory
