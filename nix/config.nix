{
    allowBroken = true;
    packageOverrides = pkgs_: with pkgs_; {
      nix-home = import ./nix-home.nix {
        inherit (pkgs) stdenv python fetchFromGitHub;
      };

      nvimOverridden = pkgs.neovim.override {
        withPython  = false;  # I think I don't need it for now; [NOTE: rebuilds]
        withPython3 = true;  #
        vimAlias = true;
        withJemalloc = true;
      };

      all = with pkgs; buildEnv {
        name = "all";
        paths = [
          git
          zsh
          tmux
          wget
          fzf
          nvimOverridden
          cmake
          tree
          gist
          pstree
          hugo
          ammonite
          httpie
          yarn
        ];
    };
  };
}
