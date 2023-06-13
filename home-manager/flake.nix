{
    inputs = {
        flake-utils.url = "github:numtide/flake-utils";
        home-manager.url = "github:nix-community/home-manager";
        nixpkgs.url = "github:nixos/nixpkgs";
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
    };

    outputs = { flake-utils, home-manager, nixpkgs, vim-quantum, vim-oceanic-next, tmuxConf, zshConf, ...}:
        flake-utils.lib.eachDefaultSystem (system:
            let
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
                tmuxConfig = (import tmuxConf {inherit pkgs; }).config;
                zshConfig = (import zshConf {inherit pkgs; }).zshConfig;

        in rec {
            packages = {
                homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
                    # Specify the path to your home configuration here
                    configuration = import ./home.nix { inherit customPlugins pkgs tmuxConfig zshConfig; };

                    inherit system username;
                    homeDirectory = "/Users/${username}";
                    # Update the state version as needed.
                    # See the changelog here:
                    stateVersion = "21.11";
                };
            };
        });
}
