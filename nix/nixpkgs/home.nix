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
      rev = "166a409f1ddade37d1cfd25ba7c6b60270831a95";
      sha256 = "0c63sv7vy7yzh8hvy5a5i3amnpk4kklkkm4kimgw2dzm1pqfz5y4";
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

  customPlugins.dhall-lang = pkgs.vimUtils.buildVimPlugin {
    name = "dhall-lang";
    src = pkgs.fetchFromGitHub {
      owner = "vmchale";
      repo = "dhall-vim";
      rev = "54a0f463d098abf72c76a233a6a3f0f9dd069dfe";
      sha256 = "0yacjv7kv79yilsyij43m378shzln0qra5c3nc5g2mc2i9hxcial";
    };
  };
in
{
  programs.home-manager.enable = true;
  programs.home-manager.path = https://github.com/rycee/home-manager/archive/master.tar.gz;

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
    gnupg
    direnv
    fzf

    # Scala tools
    ammonite
    httpie

    # JS tools
    yarn

    # Random tools
    google-cloud-sdk
    python38Packages.powerline
    bat
    gitAndTools.hub

    # Kubernetes tooling
    kubectx
    k9s
    dive
  ];

  programs.fzf = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userName = "Michael Francis";
    userEmail = "michael@melenion.com";
  };

 home.file.".tmux.conf" = {
   text = tmuxConfig;
 };

 home.file.".hushlogin" = {
   text = '''';
 };

 home.file.".bash_profile" = {
   text = ''
    exec zsh
   '';
 };

 home.file.".gnupg/gpg-agent.conf" = {
   text = ''
    enable-ssh-support
    default-cache-ttl 60
    max-cache-ttl 120
   '';
 };

  programs.zsh = {
   enable = true;
   initExtra = zshConfig;
  };

  programs.neovim = {
		enable = true;
		withPython  = false;  # I think I don't need it for now; [NOTE: rebuilds]
		withPython3 = true;  #
		vimAlias = true;
			extraConfig = ''
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

        " Easy clearing of last search term
        nnoremap <CR> :noh<CR><CR>

        function! s:find_files()
          let git_dir = system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
          if git_dir !=# '''
            call fzf#vim#gitfiles(git_dir, fzf#vim#with_preview('right'))
          else
            call fzf#vim#files('.', fzf#vim#with_preview('right'))
          endif
        endfunction
        command! ProjectFiles execute s:find_files()
        nnoremap <silent> <C-p> :ProjectFiles<CR>
			'';

      plugins = with pkgs.vimPlugins // customPlugins; [
        vim-airline
        vim-indent-guides
        nerdtree
        fzf-vim
        fugitive
        ale
        vim-better-whitespace
        vim-gitgutter

        # Syntax support
        vim-nix
        dhall-lang

        # Themes
        vim-quantum
        vim-oceanic-next
      ];
	};
}
