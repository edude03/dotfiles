# Dotfiles

Originally was just normal dotfiles, now this is how I manage my home on multiple systems. 

## Install steps

This is how I setup a new Mac after getting past the setup screen

```
# Install Nix in multiuser mode
curl https://nixos.org/nix/install | sh -s -- --daemon

# Start a shell with git in it, avoiding apple's command line tools
nix run nixpkgs.git

# Clone this repo
git clone https://github.com/edude03/dotfiles

# Make a config dir, and link the dotfiles version of nixpkgs to it
mkdir -p ~/.config
ln -s $HOME/dotfiles/nix/nixpkgs ~/.config/nixpkgs

# Install home manager
HM_PATH=https://github.com/rycee/home-manager/archive/master.tar.gz
nix-shell $HM_PATH -A install

# (TODO) Install the powerline fonts & configure iTerm2 to use them
```
