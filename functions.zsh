# zshrc functions

# Function to find directory and cd or for a file, extract its parent directory with dirname and cd
# old fzf config: fzf --preview 'bat --color=always {} 2>/dev/null || cat {}'
# new fzf config requires bat in replacement of cat, install with brew install bat or apt install bat
function lcd() {
  setopt localoptions nomonitor localtraps
  
  local file pid
  local tmpfifo=$(mktemp -u)
  mkfifo "$tmpfifo" || { echo "Failed to create FIFO" >&2; return 1; }

  trap 'kill $pid 2>/dev/null; wait $pid 2>/dev/null; rm -f "$tmpfifo"' EXIT INT TERM

  locate -i "$1" > "$tmpfifo" 2>/dev/null &
  pid=$!

  file=$(fzf --preview 'bat --style=numbers --color=always --line-range :500 {} 2>/dev/null || ls -lah --color=always {} 2>/dev/null || echo "¯\_(ツ)_/¯"' \
    --preview-window right:50%:border-left < "$tmpfifo")

  trap - EXIT INT TERM
  kill $pid 2>/dev/null
  wait $pid 2>/dev/null
  rm -f "$tmpfifo"

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
  setopt localoptions nomonitor localtraps

  local file pid
  local tmpfifo=$(mktemp -u)
  mkfifo "$tmpfifo" || { echo "Failed to create FIFO" >&2; return 1; }

  trap 'kill $pid 2>/dev/null; wait $pid 2>/dev/null; rm -f "$tmpfifo"' EXIT INT TERM

  locate -i "$1" > "$tmpfifo" 2>/dev/null &
  pid=$!

  file=$(fzf --preview 'bat --style=numbers --color=always --line-range :500 {} 2>/dev/null || ls -lah --color=always {} 2>/dev/null || echo "¯\_(ツ)_/¯"' \
    --preview-window right:50%:border-left < "$tmpfifo")

  trap - EXIT INT TERM
  kill $pid 2>/dev/null
  wait $pid 2>/dev/null
  rm -f "$tmpfifo"

  if [[ -n "$file" ]]; then
    nvim "$file"
  fi
}
