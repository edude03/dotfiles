with import <nixpkgs> {};

let
  mkc = stdenv.mkDerivation { 
    name = "mkc";
    src = fetchgit {
      url = "https://github.com/caarlos0/zsh-mkc.git";
      rev = "8d5293f009c9b7170ffa991afd0b5eb7d9e5325b";
      sha256 = "0np1vpgvr7345zf29mac77fzaaggcwwdfy4l2g04sjmz2jighgw4";
    };

    installPhase = ''
      mkdir $out
      cp -a . $out
    '';
  };
  
  zsh-nix-shell = stdenv.mkDerivation { 
    name = "zsh-nix-shell";
    src = fetchgit {
      url = "https://github.com/chisui/zsh-nix-shell.git";
      rev = "5c3204ee128b9b70606651c8e063f681cb3785ae";
      sha256 = "1ynj2rsr193lkaaf5gdzhfnyxj2svqqqqyj7i2h8ha434ay3c52p";
    };

    installPhase = ''
      mkdir $out
      cp -a . $out
    '';
  };
in

pkgs.writeText "zshrc" ''

  # zmodload zsh/zprof
  export POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
  export POWERLEVEL9K_SHORTEN_STRATEGY='truncate_from_right'
  DEFAULT_USER="edude03"
  export TERM="xterm-256color"

  POWERLINE_GO_MODULES="nix-shell,ssh,cwd,perms,git,hg,jobs,exit,root"

  if [[ "$OSTYPE" == "darwin"* ]]; then
    # Fixes moving on mac
    bindkey "\e\e[D" backward-word 
    bindkey "\e\e[C" forward-word
  fi

  # Load specific oh-my-zsh bits I want / need
  source ${pkgs.oh-my-zsh}/share/oh-my-zsh/lib/git.zsh
  source ${pkgs.oh-my-zsh}/share/oh-my-zsh/lib/theme-and-appearance.zsh
  source ${pkgs.oh-my-zsh}/share/oh-my-zsh/lib/completion.zsh
  source ${pkgs.oh-my-zsh}/share/oh-my-zsh/lib/directories.zsh
  source ${pkgs.oh-my-zsh}/share/oh-my-zsh/lib/key-bindings.zsh
  source ${pkgs.oh-my-zsh}/share/oh-my-zsh/lib/spectrum.zsh
  source ${pkgs.oh-my-zsh}/share/oh-my-zsh/lib/history.zsh

  source ${pkgs.fzf}/share/fzf/completion.zsh
  source ${pkgs.fzf}/share/fzf/key-bindings.zsh

  source ${mkc}/mkc.plugin.zsh

  source ${zsh-nix-shell}/nix-shell.plugin.zsh
  #source ${pkgs.python36Packages.powerline}/share/zsh/site-contrib/powerline.zsh

  function powerline_precmd() {
    PS1="$(${pkgs.powerline-go}/bin/powerline-go -error $? -shell zsh -modules $POWERLINE_GO_MODULES)"
  }

  function install_powerline_precmd() {
    for s in "''${precmd_functions[@]}"; do
      if [ "$s" = "powerline_precmd" ]; then
        return
      fi
    done
    
    precmd_functions+=(powerline_precmd)
  }

  if [ "$TERM" != "linux" ]; then
    install_powerline_precmd
  fi

  autoload -Uz compinit
  if [[ -n ''${ZDOTDIR:-''${HOME}}/$ZSH_COMPDUMP(#qN.mh+24) ]]; then
	  compinit -d $ZSH_COMPDUMP;
  else
	  compinit -C;
  fi;

  # Ensure nvim is used as editor
  export EDITOR=nvim


  if [[ $(command -v rbenv)  ]]; then
    eval "$(rbenv init -)"
  fi

  export GOPATH="$HOME/golang"
  export NVM_DIR="$HOME/.nvm"

  path+=(
    #$HOME/.jenv/bin
    /usr/local/bin
    $HOME/.cargo/bin
    $GOPATH/bin
    $GOROOT/bin
    $HOME/miniconda3/bin
    $HOME/anaconda3/bin
  )

  # Autojump
  [ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

  # The next line updates PATH for the Google Cloud SDK.
  if [ -f '/Users/edude03/Downloads/google-cloud-sdk/path.zsh.inc' ]; then 
    source '/Users/edude03/Downloads/google-cloud-sdk/path.zsh.inc'; 
  fi

  # The next line enables shell command completion for gcloud.
    if [ -f '/Users/edude03/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then 
    source '/Users/edude03/Downloads/google-cloud-sdk/completion.zsh.inc'; 
  fi

''
