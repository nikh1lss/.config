#!/bin/zsh

DOTFILES_DIR="$HOME/dotfiles"

# only for linux-amd64, no error handling either, if any issues, check mason and install manually
install_go() {
    if command -v go &>/dev/null; then
        return
    fi

    # install latest version, can hardcode version if you'd like
    local version
    version=$(curl -fsSL 'https://golang.org/VERSION?m=text' | head -1 | sed 's/go//')

    curl -fLO "https://go.dev/dl/go${version}.linux-amd64.tar.gz" || return 1
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf "go${version}.linux-amd64.tar.gz" || return 1
    rm "go${version}.linux-amd64.tar.gz"

    # /usr/local/go/bin is already on PATH in .zshrc
    export PATH="/usr/local/go/bin:$PATH"
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

# neovim nightly, built from source into /usr/local
install_neovim() {
    if command -v nvim &>/dev/null; then
        return
    fi

    local src="$HOME/.local/src/neovim"
    [ -d "$src" ] || git clone https://github.com/neovim/neovim.git "$src"
    git -C "$src" pull
    make -C "$src" CMAKE_BUILD_TYPE=RelWithDebInfo || return 1
    sudo make -C "$src" install
    nvim --version | head -1
}

# tmux from master (next-3.x), built from source into /usr/local
install_tmux() {
    if command -v tmux &>/dev/null; then
        return
    fi

    local src="$HOME/.local/src/tmux"
    [ -d "$src" ] || git clone https://github.com/tmux/tmux.git "$src"
    git -C "$src" pull
    (cd "$src" && sh autogen.sh && ./configure && make) || return 1
    sudo make -C "$src" install
    tmux -V
}

# tpm lives inside the repo (gitignored), see TMUX_PLUGIN_MANAGER_PATH in tmux.conf
install_tpm() {
    local plugin_dir="$DOTFILES_DIR/config/.config/tmux/plugins"
    if [ ! -d "$plugin_dir/tpm" ]; then
        git clone --depth=1 https://github.com/tmux-plugins/tpm "$plugin_dir/tpm"
    fi
    TMUX_PLUGIN_MANAGER_PATH="$plugin_dir" "$plugin_dir/tpm/bin/install_plugins"
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
for f in ~/.zshrc ~/.p10k.zsh ~/.gitconfig ~/.bashrc ~/.profile ~/.config ~/.ignore \
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
    dotnet-sdk-10.0 \
    fzf \
    plocate \
    fd-find \
    ripgrep \
    zoxide \
    cppcheck \
    unzip zip \
    xclip \
    cmake ninja-build gettext \
    autoconf automake bison pkg-config libevent-dev libncurses-dev

# fd-find installs as fdfind on ubuntu
mkdir -p ~/.local/bin
[ -e ~/.local/bin/fd ] || ln -s /usr/bin/fdfind ~/.local/bin/fd

# Update locate database
echo "Updating locate database, this may take a while"
sudo updatedb

# editor + multiplexer
install_neovim
install_tmux
install_tpm

# language install
install_go

# font install for powerlevel10k
install_fonts

# Homebrew (.zshrc evals brew shellenv unconditionally)
if [ ! -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Rust
if ! command -v rustc &>/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi
source "$HOME/.cargo/env"

# cargo tools: tms (tmux-sessionizer), lsd (structure alias), bat (f alias),
# stylua, tree-sitter cli (nvim-treesitter parser builds)
for crate in tmux-sessionizer lsd bat stylua tree-sitter-cli; do
    cargo install --locked "$crate"
done

# Node.js (via nvm)
if ! command -v node &>/dev/null; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    source ~/.nvm/nvm.sh
    nvm install --lts
fi

# uv (python tooling)
if ! command -v uv &>/dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# SDKMAN (kotlin, gradle)
if [ ! -d "$HOME/.sdkman" ]; then
    curl -s "https://get.sdkman.io?rcupdate=false" | bash
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    sdk install kotlin
    sdk install gradle
fi

# Zig
if ! command -v zig &>/dev/null; then
    sudo snap install zig --classic --beta
fi

# Haskell (ghcup)
if ! command -v ghc &>/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | BOOTSTRAP_HASKELL_NONINTERACTIVE=1 sh
fi

echo "Dotfiles installed, restart zsh!"

exec zsh
