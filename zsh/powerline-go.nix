{ pkgs, ... }: ''
  POWERLINE_GO_MODULES="nix-shell,ssh,cwd,perms,git,hg,jobs,exit,root"

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

  # This is what's been hanging my terminal all along 
  if [ "$TERM" != "linux" ]; then
    install_powerline_precmd
  fi

''