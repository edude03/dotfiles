{ pkgs, ...}:
{
  config = ''
    # Mouse Config
    set -g mouse on
    bind -n WheelUpPane   select-pane -t= \; copy-mode -e \; send-keys -M
    bind -n WheelDownPane select-pane -t= \;                 send-keys -M

    # Load the daemon
    run-shell "${pkgs.python38Packages.powerline}/bin/powerline-daemon -q"
    # Loads Powerline
    source "${pkgs.python38Packages.powerline}/share/tmux/powerline.conf"

    # Prevents vim insert mode delay
    set -sg escape-time 0

    # Enables 24 bit color in tmux
    set -g default-terminal "xterm-256color"
    set-option -ga terminal-overrides ",*256col*:Tc"
'';
}
