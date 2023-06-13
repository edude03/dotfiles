{ pkgs, ...}:
let
  mkc = pkgs.stdenv.mkDerivation {
    name = "mkc";
    src = pkgs.fetchgit {
      url = "https://github.com/caarlos0/zsh-mkc.git";
      rev = "8d5293f009c9b7170ffa991afd0b5eb7d9e5325b";
      sha256 = "0np1vpgvr7345zf29mac77fzaaggcwwdfy4l2g04sjmz2jighgw4";
    };

    installPhase = ''
      mkdir $out
      cp -a . $out
    '';
  };

  zsh-nix-shell = pkgs.stdenv.mkDerivation {
    name = "zsh-nix-shell";
    src = pkgs.fetchgit {
      url = "https://github.com/chisui/zsh-nix-shell.git";
      rev = "69e90b9bccecd84734948fb03087c2454a8522f6";
      sha256 = "0snhch9hfy83d4amkyxx33izvkhbwmindy0zjjk28hih1a9l2jmx";
    };

    installPhase = ''
      mkdir $out
      cp -a . $out
    '';
  };

  nord-dircolors = pkgs.stdenv.mkDerivation {
    name = "nord-dircolors";
    version = "0.0.1";
    src = pkgs.fetchgit {
      url = "https://github.com/arcticicestudio/nord-dircolors.git";
      rev = "96b20ecb385e2068bb313cf47bbcbba76ca27885";
      sha256 = "10pc0d09iyp5q0c0jz7plp0360fxaw2ajjgvnsprpfm6grx6fciz";
    };

    installPhase = ''
      mkdir $out
      cp -a . $out
    '';
  };

  zsh-histdb = pkgs.stdenv.mkDerivation {
    name = "zsh-histdb";
    src = pkgs.fetchgit {
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

  if [[ "$OSTYPE" == "darwin"* ]]; then
    # Fixes moving on mac
    bindkey "\e\e[D" backward-word
    bindkey "\e\e[C" forward-word
  fi

  if [[ -z $NIX_PATH ]]; then
    source $HOME/.nix-profile/etc/profile.d/nix.sh
  fi

  # Load specific oh-my-zsh bits I want / need
  OMZ_LIBS=(git theme-and-appearance completion directories key-bindings spectrum history)
  
  for mod in $OMZ_LIBS[@]; do
    source ${pkgs.oh-my-zsh}/share/oh-my-zsh/lib/"$mod".zsh
  done

  source ${pkgs.fzf}/share/fzf/completion.zsh
  source ${pkgs.fzf}/share/fzf/key-bindings.zsh

  source ${mkc}/mkc.plugin.zsh

  eval "$(${pkgs.direnv}/bin/direnv hook zsh)"

  function start_ssh_agent() {
    # Setup GPG Agent
    export GPG_TTY="$(tty)"
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    gpgconf --launch gpg-agent
  }

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

  path=(
    $HOME/.bin
    $HOME/.cargo/bin
    $HOME/.nix-profile/bin
    /usr/local/bin
    $path
  )

  # Setup pretty ls colors
  unalias ls
  alias ls="${pkgs.coreutils}/bin/ls -l --color=auto"
  eval $(${pkgs.coreutils}/bin/dircolors ${nord-dircolors}/src/dir_colors)

  # Autojump
  [ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh


  eval "$(${pkgs.starship}/bin/starship init zsh)"

  # start_ssh_agent

  umask 022
'';
}
