{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    vim-quantum = {
      flake = false;
      url = "github:tyrannicaltoucan/vim-quantum";
    };
    vim-oceanic-next = {
      flake = false;
      url = "github:mhartington/oceanic-next";
    };
    tmuxConf = {
      url = "../tmux/tmux.nix";
      flake = false;
    };
    zshConf = {
      url = "../zsh/zshrc.nix";
      flake = false;
    };
    nvimConfig = {
      url = "../vim/.vimrc";
      flake = false;
    };
    atuinPkg.url = "github:atuinsh/atuin";
    nilPkg.url =  "github:oxalica/nil";
  };

  outputs = {
    flake-utils,
    home-manager,
    nixpkgs,
    vim-quantum,
    vim-oceanic-next,
    tmuxConf,
    zshConf,
    nvimConfig,
    atuinPkg,
    nilPkg,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      username = "edude03";
      customPlugins = {
        vim-quantum = pkgs.vimUtils.buildVimPlugin {
          name = "vim-quantum";
          src = vim-quantum;
        };
        vim-oceanic-next = pkgs.vimUtils.buildVimPlugin {
          name = "vim-oceanic-next";
          src = vim-oceanic-next;
        };
      };
      tmuxConfig = (import tmuxConf {inherit pkgs;}).config;
      zshConfig = (import zshConf {inherit pkgs;}).zshConfig;
      atuin = atuinPkg.packages.${system}.atuin;
      nil = nilPkg.packages.${system}.nil;
    in rec {
      packages = {
        homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = {
            inherit nvimConfig tmuxConfig customPlugins zshConfig atuin nil;
          };
          modules = [
            ./home.nix
            {
              home = {
                inherit username;
                homeDirectory = "/Users/edude03";
                stateVersion = "22.05";
              };
            }
          ];
        };
      };
    });
}
