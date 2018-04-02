{pkgs}:

let 
  customPlugins.vim-quantum = pkgs.vimUtils.buildVimPlugin {
    name = "vim-quantum";
    src = pkgs.fetchFromGitHub {
      owner = "tyrannicaltoucan";
      repo = "vim-quantum";
      rev = "9bd62f60623ef369f95686157a4d99b3817357eb";
      sha256 = "0kvlv5bbs4pipaa78hf9lggkkx5b6icv590fzz1f9p3xzsyk0kwx";
    };
  };

in
with pkgs; rec {
    allowBroken = true;

    packageOverrides = pkgs_: with pkgs_; {
      nvimOverridden = pkgs.neovim.override {
        withPython  = false;  # I think I don't need it for now; [NOTE: rebuilds]
        withPython3 = true;  #
        vimAlias = true;
        configure = { 
          customRC = ''
            " vim config
            " Enable Line Numbers
            set number
            let g:airline_powerline_fonts = 1
            " Show the name of the buffers in the tabline
            let g:airline#extensions#tabline#enabled = 1

            " Use spaces instead of tab char
            set expandtab

            " Intend by 2 chars
            set shiftwidth=2
            set tabstop=2

            " Turn on autoindent
            set autoindent

            " Set color scheme
            set background=dark
            let g:airline_theme='quantum'
            let g:quantum_italics=1
            set termguicolors
            colorscheme quantum
          '';

          vam.knownPlugins = vimPlugins // customPlugins;
          vam.pluginDictionaries = [
            { names = [
                "vim-airline"
                "vim-indent-guides"
                "nerdtree"
                "fzf-vim"
                "YouCompleteMe"
                "fugitive"
                "syntastic"

                # Syntax support
                "vim-nix"

                # Themes
                "vim-quantum"
              ];
            }
          ];
        };
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
          silver-searcher
          cmake
          tree
          gist
          pstree
          hugo

          # Scala tools
          ammonite
          httpie

          # JS tools
          yarn
        ];
    };
  };
}
