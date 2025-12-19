DOTFILES_DIR  = "$HOME/dotfiles"

ln -sf "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/gitconfig" "$HOME/.gitconfig"    
ln -sf "$DOTFILES_DIR/config" "$HOME/.config" 
ln -sf "$DOTFILES_DIR/bashrc" "$HOME/.bashrc"
ln -sf "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/p10k.zsh" "$HOME/.p10k.zsh"
ln -sf "$DOTFILES_DIR/profile" "$HOME/.profile"

mkdir -p "$HOME/.config" 

ln -sf "$DOTFILES_DIR/config/nvim" "$HOME/.config/nvim"

if [ ! -f "$HOME/.gitconfig.local" ]; then
    cat > "$HOME/.gitconfig.local" << 'EOF'
[user]
    name = YOUR_NAME
    email = YOUR_EMAIL
EOF
    echo "Created .gitconfig.local, update with your info"
fi


echo "Dotfiles installed"
