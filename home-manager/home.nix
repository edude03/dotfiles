{ pkgs, customPlugins, tmuxConfig, zshConfig, ... }:

{
  programs.home-manager.enable = true;
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
  };

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
    python39Packages.powerline
    bat
    nerdfonts

    # Kubernetes tooling
    kubectx
    k9s
    dive
    kubie
    kind
  ];

  programs.fzf = { enable = true; };

  programs.git = {
    enable = true;
    userName = "Michael Francis";
    userEmail = "michael@melenion.com";
    extraConfig = {
      submodule = {
        recurse = true;
      };
    };
  };

  home.file.".tmux.conf" = { text = tmuxConfig; };

  home.file.".hushlogin" = { text = ""; };

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
    # extraConfig = builtins.readFile ${git+file:../../}vim/.vimrc;

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
