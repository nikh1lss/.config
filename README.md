<div align="center">

"Give me 6 hours to write a program and I will spend the first month tweaking my config" - Abraham Lincoln I think

<img width="1919" height="1079" alt="Image" src="https://github.com/user-attachments/assets/98b1a351-4c7f-476b-8421-fea90e144856" />

</div>

<br>

I manage the various configuration files in this repo using [GNU Stow](https://www.gnu.org/software/stow/). This allows me to set up symlinks for all of my dotfiles by stowing each package:
```sh
stow -d ~/dotfiles zsh git bash config shell
```

Each top-level directory is a stow package that mirrors the target path structure in `$HOME`. To add a new config, just place it in the correct relative path inside a package and run `stow -d ~/dotfiles <package>`.
