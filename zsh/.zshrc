zmodload zsh/zprof
export POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
export POWERLEVEL9K_SHORTEN_STRATEGY='truncate_from_right'

# Load Antibody (Plugin Manager)
source <(antibody init)

# Turn on Prompt Substitution
setopt PROMPT_SUBST

#Load specific oh-my-zsh bits I want / need
source ~/oh-my-zsh/lib/git.zsh
source ~/oh-my-zsh/lib/theme-and-appearance.zsh
source ~/oh-my-zsh/lib/completion.zsh
source ~/oh-my-zsh/lib/directories.zsh
source ~/oh-my-zsh/lib/key-bindings.zsh
source ~/oh-my-zsh/lib/spectrum.zsh
source ~/oh-my-zsh/lib/history.zsh

# Stuff I hacked in from OMZ init
autoload -U compaudit compinit
# Save the location of the current completion dump file.
if [ -z "$ZSH_COMPDUMP" ]; then
  ZSH_COMPDUMP="${ZDOTDIR:-${HOME}}/.zcompdump-${SHORT_HOST}-${ZSH_VERSION}"
fi

if [[ $ZSH_DISABLE_COMPFIX != true ]]; then
  # If completion insecurities exist, warn the user without enabling completions.
  if ! compaudit &>/dev/null; then
    # This function resides in the "lib/compfix.zsh" script sourced above.
    handle_completion_insecurities
  # Else, enable and cache completions to the desired file.
  else
    compinit -d "${ZSH_COMPDUMP}"
  fi
else
  compinit -i -d "${ZSH_COMPDUMP}"
fi


# Load secrets
if [[ -a "${HOME}/secrets.sh" ]]; then
  source ${HOME}/secrets.sh
fi

# Stuff I hacked in from OMZ init
#autoload -U compaudit compinit
# Save the location of the current completion dump file.
#if [ -z "$ZSH_COMPDUMP" ]; then
#  ZSH_COMPDUMP="${ZDOTDIR:-${HOME}}/.zcompdump-${SHORT_HOST}-${ZSH_VERSION}"
#fi

if [[ -a "${HOME}/.rbenv/bin" ]]; then
  # Load RBENV
  export PATH="/usr/local/sbin:$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

# TODO: Fix hardcoded path
# for nodenv & rbenv
# Maybe source nix first then use the return of which
if [[ -a "${HOME}/.nodenv/bin" ]]; then
  # Load nodenv
  path += ('$HOME/.nodenv/bin')
  eval "$(nodenv init -)"
fi

if [[ -a "${HOME}/.nix-profile/etc/profile.d/nix.sh" ]]; then
  source "${HOME}/.nix-profile/etc/profile.d/nix.sh"
fi

export GOPATH="$HOME/golang"
# On OSX this is where it is, on linux it's not
export GOROOT=/usr/local/opt/go/libexec
#export GOROOT=/usr/local/go
path=(
 $path
 $HOME/.nodenv/bin
 $HOME/.cargo/bin
 $GOPATH/bin
 $GOROOT/bin
 $HOME/anaconda3/bin
)

# Get Antibody to load plugins
antibody bundle < ~/.zsh/plugins.txt

# Load fzf if installed
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Autojump
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
