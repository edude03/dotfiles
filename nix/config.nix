{
  packageOverrides = pkgs_: with pkgs_; {  # pkgs_ is the original set of packages
    all = with pkgs; buildEnv {  # pkgs is your overriden set of packages itself
      name = "all";
      paths = [
      	vim
        stow
        zsh
      ];
    };
  };
}
