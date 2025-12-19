#!/bin/zsh

DOTFILES_DIR="$HOME/dotfiles"

backup_if_exists() {
    if [ -e "$1" ] && [ ! -L "$1" ]; then
        echo "Backing up existing $1 to $1.backup"
        mv "$1" "$1.backup"
    fi
}

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
ln -sf "$DOTFILES_DIR/profile" "$HOME/.oh-my-zsh/custom/functions.zsh"

backup_if_exists "$HOME/.oh-my-zsh/custom/macros.zsh"
ln -sf "$DOTFILES_DIR/profile" "$HOME/.oh-my-zsh/custom/macros.zsh"


if [ ! -f "$HOME/.gitconfig.local" ]; then
    cat > "$HOME/.gitconfig.local" << 'EOF'
[user]
    name = YOUR_NAME
    email = YOUR_EMAIL
EOF
    echo "Created .gitconfig.local, update with your info"
fi


echo "Dotfiles installed"


# refactor this, it sucks
