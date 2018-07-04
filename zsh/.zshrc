# zmodload zsh/zprof
export POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
export POWERLEVEL9K_SHORTEN_STRATEGY='truncate_from_right'

# Fixes moving on mac
bindkey "\e\e[D" backward-word 
bindkey "\e\e[C" forward-word

# Load Antibody (Plugin Manager)
if [[ -x "${HOME}/.zsh/plugins.sh" ]]; then
  source "${HOME}/.zsh/plugins.sh"
fi

# Load specific oh-my-zsh bits I want / need
source ~/oh-my-zsh/lib/git.zsh
source ~/oh-my-zsh/lib/theme-and-appearance.zsh
source ~/oh-my-zsh/lib/completion.zsh
source ~/oh-my-zsh/lib/directories.zsh
source ~/oh-my-zsh/lib/key-bindings.zsh
source ~/oh-my-zsh/lib/spectrum.zsh
source ~/oh-my-zsh/lib/history.zsh


autoload -Uz compinit
if [[ -n ${ZDOTDIR:-${HOME}}/$ZSH_COMPDUMP(#qN.mh+24) ]]; then
	compinit -d $ZSH_COMPDUMP;
else
	compinit -C;
fi;

# Ensure nvim is used as editor
export EDITOR=nvim

# Load secrets
if [[ -a "${HOME}/secrets.sh" ]]; then
  source ${HOME}/secrets.sh
fi

if [[ $(command -v rbenv)  ]]; then
  eval "$(rbenv init -)"
fi

export GOPATH="$HOME/golang"
export GOROOT=/usr/local/opt/go/libexec
export NVM_DIR="$HOME/.nvm"

path+=(
#  $HOME/.jenv/bin
  /usr/local/bin
  $HOME/.cargo/bin
  $GOPATH/bin
  $GOROOT/bin
  $HOME/miniconda3/bin
  $HOME/anaconda3/bin
)

# Load fzf if installed
#[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
if [ -n "${commands[fzf-share]}" ]; then
  source "$(fzf-share)/key-bindings.zsh"
fi

#eval "$(jenv init -)"

# Autojump
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"

# NVM stuff 
declare -a NODE_GLOBALS=(`find ~/.nvm/versions/node -maxdepth 3 -type l -wholename '*/bin/*' | xargs -n1 basename | sort | uniq`)

NODE_GLOBALS+=("node")
NODE_GLOBALS+=("nvm")

load_nvm () {
    export NVM_DIR=~/.nvm
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
}

for cmd in "${NODE_GLOBALS[@]}"; do
  eval "${cmd}(){ unset -f ${NODE_GLOBALS}; load_nvm; ${cmd} \$@ }"
done

# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
# add-zsh-hook chpwd load-nvmrc
# load-nvmrc

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/edude03/Downloads/google-cloud-sdk/path.zsh.inc' ]; then source '/Users/edude03/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/edude03/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then source '/Users/edude03/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
