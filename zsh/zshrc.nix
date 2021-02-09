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
      rev = "69e90b9bccecd84734948fb03087c2454a8522f6";
      sha256 = "0snhch9hfy83d4amkyxx33izvkhbwmindy0zjjk28hih1a9l2jmx";
    };

    installPhase = ''
      mkdir $out
      cp -a . $out
    '';
  };

  nord-dircolors = stdenv.mkDerivation rec {
    name = "nord-dircolors";
    version = "0.0.1";
    src = fetchgit {
      url = "https://github.com/arcticicestudio/nord-dircolors.git";
      rev = "96b20ecb385e2068bb313cf47bbcbba76ca27885";
      sha256 = "10pc0d09iyp5q0c0jz7plp0360fxaw2ajjgvnsprpfm6grx6fciz";
    };

    installPhase = ''
      mkdir $out
      cp -a . $out
    '';
  };

  zsh-histdb = stdenv.mkDerivation {
    name = "zsh-histdb";
    src = fetchgit {
      url = "https://github.com/larkery/zsh-histdb.git";
      rev = "7c34b558cca374b6c8727fc08868f2bc044fd162";
      sha256 = "04i8gsixjkqqq0nxmd45wp6irbfp9hy71qqxkq7f6b78aaknljwf";
    };

    installPhase = ''
      mkdir $out
      cp -a . $out
    '';
  };
in

{
zshConfig = ''

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

  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'

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

  # Setup zsh-histdb
  source ${zsh-histdb}/sqlite-history.zsh
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd histdb-update-outcome

  source ${zsh-histdb}/histdb-interactive.zsh
  bindkey '^r' _histdb-isearch

  # source ${zsh-nix-shell}/nix-shell.plugin.zsh
  # source ${pkgs.python36Packages.powerline}/share/zsh/site-contrib/powerline.zsh

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

  function start_ssh_agent() {
    # Setup GPG Agent
    export GPG_TTY="$(tty)"
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    gpgconf --launch gpg-agent
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
    /usr/local/bin
  )

  local nixPath=(
    ssh-auth-sock=$HOME/.gnupg/S.gpg-agent.ssh
    ssh-config-file=/etc/nix/ssh-config-file
    nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixpkgs
    /nix/var/nix/profiles/per-user/root/channels
  )

  NIX_PATH=$(IFS=: ; echo "''${nixPath[*]}")

  # Setup pretty ls colors
  unalias ls
  alias ls="${pkgs.coreutils}/bin/ls -l --color=auto"
  eval $(${pkgs.coreutils}/bin/dircolors ${nord-dircolors}/src/dir_colors)

  # Autojump
  [ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

  # Configure Google Cloud SDK
  source ${pkgs.google-cloud-sdk}/google-cloud-sdk/completion.zsh.inc

  start_ssh_agent
'';
}
