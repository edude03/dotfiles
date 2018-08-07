{ pkgs, ...}:

let
  zshConfig = (import ../../zsh/zshrc.nix).zshConfig;
  tmuxConfig = (import ../../tmux/tmux.nix).config;

  customPlugins.vim-quantum = pkgs.vimUtils.buildVimPlugin {
    name = "vim-quantum";
    src = pkgs.fetchFromGitHub {
      owner = "tyrannicaltoucan";
      repo = "vim-quantum";
      rev = "9bd62f60623ef369f95686157a4d99b3817357eb";
      sha256 = "0kvlv5bbs4pipaa78hf9lggkkx5b6icv590fzz1f9p3xzsyk0kwx";
    };
  };

  customPlugins.vim-better-whitespace = pkgs.vimUtils.buildVimPlugin {
    name = "vim-better-whitespace";
    src = pkgs.fetchFromGitHub {
      owner = "ntpeters";
      repo = "vim-better-whitespace";
      rev = "70a38fa9683e8cd0635264dd1b69c6ccbee4e3e7";
      sha256 = "1w16mrvydbvj9msi8p4ym1vasjx6kr4yd8jdhndz0pr3qasn2ix9";
    };
  };

  customPlugins.vim-oceanic-next = pkgs.vimUtils.buildVimPlugin {
    name = "vim-oceanic-next";
    src = pkgs.fetchFromGitHub {
      owner = "mhartington";
      repo = "oceanic-next";
      rev = "021c281ba959d4ba91bdf7dca4cae47a35789386";
      sha256 = "1vvjll44596905m9yxp33ac9sx2nq8l3kli2wjxi82hdah3xc3sm";
    };
  };
in
{
  programs.home-manager.enable = true;
  programs.home-manager.path = https://github.com/rycee/home-manager/archive/release-18.03.tar.gz;

  home.packages = with pkgs; [
    git
    zsh
    tmux
    wget
    silver-searcher
    cmake
    tree
    gist
    pstree
    hugo
    git-crypt

    # Scala tools
    ammonite
    httpie

    # JS tools
    yarn

    # Random tools
    google-cloud-sdk
    python36Packages.powerline
  ];

  programs.fzf = {
    enable = true; 
  };

 home.file.".tmux.conf" = {
   text = tmuxConfig;
 };

  programs.zsh = {
   enable = true;
   initExtra = zshConfig;
  };

  programs.neovim = {
		enable = true;
		withPython  = false;  # I think I don't need it for now; [NOTE: rebuilds]
		withPython3 = true;  #
		#vimAlias = true;
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

        " let g:airline_theme='quantum'
				" let g:quantum_italics=1
				set termguicolors
				" colorscheme quantum

				" Oceanic Next settings
				syntax enable
				colorscheme OceanicNext
				let g:airline_theme='oceanicnext'

				" Highlight the current line
				set cursorline

				" Enable indent guide on startup
				let g:indent_guides_enable_on_vim_startup = 1

				" Enables block folding
				set foldmethod=syntax
			'';

			vam.knownPlugins = pkgs.vimPlugins // customPlugins;
			vam.pluginDictionaries = [
				{ names = [
						"vim-airline"
						"vim-indent-guides"
						"nerdtree"
						"fzf-vim"
						"fugitive"
						"ale"
						"vim-better-whitespace"
						"vim-gitgutter"

						# Syntax support
						"vim-nix"

						# Themes
						"vim-quantum"
						"vim-oceanic-next"
					];
				}
			];
		};
	};
}
