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

install_fonts() {
    local font_dir="$HOME/.local/share/fonts"
    mkdir -p "$font_dir"
    cd "$font_dir"
    local base_url="https://github.com/romkatv/powerlevel10k-media/raw/master"
    curl -fLO "$base_url/MesloLGS%20NF%20Regular.ttf"
    curl -fLO "$base_url/MesloLGS%20NF%20Bold.ttf"
    curl -fLO "$base_url/MesloLGS%20NF%20Italic.ttf"
    curl -fLO "$base_url/MesloLGS%20NF%20Bold%20Italic.ttf"

    # refresh font cache
    fc-cache -fv
    cd -
    echo "MesloLGS NF installed and set"
    echo "Install MesloLGM Nerd Font instead if not working"
}

# Install stow if not present
if ! command -v stow &>/dev/null; then
    sudo apt install -y stow
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh-My-Zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
    echo "Installing Powerlevel10k"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# Remove existing files/symlinks that would conflict with stow
for f in ~/.zshrc ~/.p10k.zsh ~/.gitconfig ~/.bashrc ~/.profile ~/.config \
         ~/.oh-my-zsh/custom/aliases.zsh ~/.oh-my-zsh/custom/functions.zsh \
         ~/.oh-my-zsh/custom/macros.zsh; do
    if [ -L "$f" ]; then
        rm "$f"
    elif [ -e "$f" ]; then
        echo "Backing up $f to $f.backup"
        mv "$f" "$f.backup"
    fi
done

# Stow all packages
cd "$DOTFILES_DIR"
stow zsh git bash config shell

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

# font install for powerlevel10k
install_fonts

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
    swi-prolog \
    fzf \
    plocate \
    fd-find \
    cppcheck

# ln -s /usr/bin/fdfind ~/.local/bin/fd

# Update locate database
echo "Updating locate database, this may take a while"
sudo updatedb

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
