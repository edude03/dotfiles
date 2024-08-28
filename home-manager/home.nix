{
  pkgs,
  customPlugins,
  tmuxConfig,
  zshConfig,
  nvimConfig,
  atuin,
  ...
}: {
  programs.home-manager.enable = true;
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    package = atuin;
  };
  # programs.doom-emacs = {
  #             enable = true;
  #             doomPrivateDir = ./doom.d; # Directory containing your config.el, init.el
  #                                        # and packages.el files
  #           };

  home.packages = with pkgs; [
    gh
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

    # Scala tools
    ammonite
    httpie

    # JS tools
    yarn

    # Random tools
    google-cloud-sdk
    python310Packages.powerline
    bat
    nerdfonts
    helix
    jq

    # Nix tools
    alejandra
    nixd

    # Kubernetes tooling
    kubectx
    k9s
    dive
    kubie
    kind
    kubelogin-oidc
  ];

  programs.fzf = {enable = true;};

  programs.git = {
    enable = true;
    userName = "Michael Francis";
    userEmail = "michael@melenion.com";
    extraConfig = {
      submodule = {
        recurse = true;
      };
      pull = {
        rebase = true;
      };
      rebase = {
        autoStash = true;
      };
      core = {
        excludesFile = "~/dotfiles/.gitignore";
      };
    };
  };

  # home.file.".tmux.conf" = { text = tmuxConfig; };

  home.file.".hushlogin" = {text = "";};

  home.file.".gnupg/gpg-agent.conf" = {
    text = ''
      enable-ssh-support
      default-cache-ttl 60
      max-cache-ttl 120
    '';
  };

  home.file.".bash_profile" = {
    text = ''
      [ -t 0 ] && exec zsh
    '';
  };

  programs.zsh = {
    enable = true;
    initExtra = zshConfig;
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    extraConfig = builtins.readFile nvimConfig;

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
      # dhall-lang

      # Themes
      vim-quantum
      vim-oceanic-next
    ];
  };
}
