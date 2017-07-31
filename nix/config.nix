{
  allowUnfree = true;
  packageOverrides = defaultPkgs: with defaultPkgs; {
     home = with pkgs; buildEnv {
      # Make it easy to install with `nix-env -i home` [I believe]
      # TODO(akavel): verify that below line is required [or advised] for
      # `nix-env -i home`
      name = "home";

      paths = [
        wget
        tree
        pstree    # print an ascii-art tree of running processes
        nvim      # NeoVim + customized config (see below)
        nix-repl  # REPL for learning Nix
      ];
    };
  }


