# zshrc functions

# es.exe blocks while indexing, therefore exit code of 0 means indexing is complete
_es_wait_for_index() {
  es.exe -max-results 1 "" &>/dev/null
}

# function for reindexing es.exe db
function esreindex() {
  Everything.exe -reindex -close
  echo "Reindexing..."
  _es_wait_for_index
  echo "Done"
}

# Ensure services are running prior to function usage
_ensure_services() {
  if ! es.exe -max-results 1 >/dev/null 2>&1; then
    echo "Waiting for es.exe service"
    sleep 2
    if ! es.exe -max-results 1 >/dev/null 2>&1; then
      echo "es.exe service not available"
      return 1
    fi
  fi
  return 0
}

# Function to find directory and cd or for a file, extract its parent directory with dirname and cd
# old fzf config: fzf --preview 'bat --color=always {} 2>/dev/null || cat {}'
# new fzf config requires bat in replacement of cat, install with brew install bat or apt install bat
# <C-p> to move up and <C-n> to move down
function lcd() {
  _ensure_services || return 1

  local file
  file=$(es.exe "nocase:$1" 2>/dev/null | tr -d '\r' | fzf \
    --preview 'bat --style=numbers --color=always --line-range :500 {} 2>/dev/null || ls -lah --color=always {} 2>/dev/null || echo "¯\_(ツ)_/¯"' \
    --preview-window right:0%:border-left)
  
  # Convert paths to WSL format
  if [[ "$file" == *'\'* ]]; then
    # Convert backslashes to forward slashes first
    file="${file//\\//}"
    
    if [[ "$file" == //wsl\$/* ]]; then
      # WSL path: //wsl$/Distro/path → /path
      file=$(echo "$file" | sed 's|^//wsl\$/[^/]*/|/|')
    elif [[ "$file" == ?:/* ]]; then
      # Windows path: C:/path → /mnt/c/path
      file=$(wslpath "$file")
    fi
  fi

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
# <C-p> to move up and <C-n> to move down
function led() {
  _ensure_services || return 1

  local file
  file=$(es.exe "nocase:$1" 2>/dev/null | tr -d '\r' | fzf \
    --preview 'bat --style=numbers --color=always --line-range :500 {} 2>/dev/null || ls -lah --color=always {} 2>/dev/null || echo "¯\_(ツ)_/¯"' \
    --preview-window right:50%:border-left)
  
  # Convert paths to WSL format
  if [[ "$file" == *'\'* ]]; then
    # Convert backslashes to forward slashes first
    file="${file//\\//}"
    
    if [[ "$file" == //wsl\$/* ]]; then
      # WSL path: //wsl$/Distro/path → /path
      file=$(echo "$file" | sed 's|^//wsl\$/[^/]*/|/|')
    elif [[ "$file" == ?:/* ]]; then
      # Windows path: C:/path → /mnt/c/path
      file=$(wslpath "$file")
    fi
  fi

  if [[ -n "$file" ]]; then
    nvim "$file"
  fi
}

# Find pdf and open with zathura in a new tmux window, 
# <C-p> to move up and <C-n> to move down
function zpdf() {
  _ensure_services || return 1
  local file
  file=$(es.exe ext:pdf "nocase:$1" 2>/dev/null | tr -d '\r' | fzf)

  # Convert paths to WSL format
  if [[ "$file" == *'\'* ]]; then
    file="${file//\\//}"

    if [[ "$file" == //wsl\$/* ]]; then
      file=$(echo "$file" | sed 's|^//wsl\$/[^/]*/|/|')
    elif [[ "$file" == ?:/* ]]; then
      file=$(wslpath "$file")
    fi
  fi

  if [[ -n "$file" ]]; then
    if [[ -n "$TMUX" ]]; then
      tmux new-window "zathura '${file}'"
    else
      zathura "$file" &
      disown
    fi
  fi
}
