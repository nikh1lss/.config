#!/bin/zsh

DOTFILES_DIR="$HOME/dotfiles"

# only for linux-amd64, no error handling either, if any issues, check mason and install manually
install_go() {
    # install latest version, can hardcode version if you'd like
    local version
    version=$(curl -fsSL 'https://golang.org/VERSION?m=text' | head -1 | sed 's/go//')

    curl -fLO "https://go.dev/dl/go${version}.linux-amd64.tar.gz" || return 1
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf "go${version}.linux-amd64.tar.gz" || return 1
    rm "go${version}.linux-amd64.tar.gz"

    grep -q '/usr/local/go/bin' ~/.zshrc || echo 'export PATH="/usr/local/go/bin:$PATH"' >>~/.zshrc

    # verify with go version after source ~/.zshrc
    source ~/.zshrc
    go version

    echo "Go installed"
}

backup_if_exists() {
    if [ -e "$1" ] && [ ! -L "$1" ]; then
        echo "Backing up existing $1 to $1.backup"
        mv "$1" "$1.backup"
    fi
}

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh-My-Zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
    echo "Installing Powerlevel10k"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

backup_if_exists "$HOME/.config"
mkdir -p "$HOME/.config"
ln -sf "$DOTFILES_DIR/config" "$HOME/.config"

backup_if_exists "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"

backup_if_exists "$HOME/.gitconfig"
ln -sf "$DOTFILES_DIR/gitconfig" "$HOME/.gitconfig"

backup_if_exists "$HOME/.bashrc"
ln -sf "$DOTFILES_DIR/bashrc" "$HOME/.bashrc"

backup_if_exists "$HOME/.p10k.zsh"
ln -sf "$DOTFILES_DIR/p10k.zsh" "$HOME/.p10k.zsh"

backup_if_exists "$HOME/.profile"
ln -sf "$DOTFILES_DIR/profile" "$HOME/.profile"

backup_if_exists "$HOME/.oh-my-zsh/custom/aliases.zsh"
ln -sf "$DOTFILES_DIR/aliases.zsh" "$HOME/.oh-my-zsh/custom/aliases.zsh"

backup_if_exists "$HOME/.oh-my-zsh/custom/functions.zsh"
ln -sf "$DOTFILES_DIR/functions.zsh" "$HOME/.oh-my-zsh/custom/functions.zsh"

backup_if_exists "$HOME/.oh-my-zsh/custom/macros.zsh"
ln -sf "$DOTFILES_DIR/macros.zsh" "$HOME/.oh-my-zsh/custom/macros.zsh"

if [ ! -f "$HOME/.gitconfig.local" ]; then
    cat >"$HOME/.gitconfig.local" <<'EOF'
[user]
    name = YOUR_NAME
    email = YOUR_EMAIL
EOF
    echo "Created .gitconfig.local, update with your info"
fi

# language install
install_go

# can always change this here and community.lua if
# language is not desired (i.e. prolog)
sudo apt update
sudo apt install -y \
    build-essential \
    clang clangd make gdb \
    openjdk-25-jdk \
    python3 python3-pip python3-venv \
    lua5.4 \
    docker.io docker-compose \
    maven \
    shellcheck \
    postgresql-client \
    swi-prolog

# Rust
if ! command -v rustc &>/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

# Node.js (via nvm)
if ! command -v node &>/dev/null; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    source ~/.nvm/nvm.sh
    nvm install --lts
fi

# Zig
if ! command -v zig &>/dev/null; then
    sudo snap install zig --classic --beta
fi

# Haskell (ghcup)
if ! command -v ghc &>/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
fi

echo "Dotfiles installed, restart zsh!"

source ~/.zshrc

# refactor this, it sucks
