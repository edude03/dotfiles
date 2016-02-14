#zmodload zsh/zprof

# Load Antibody (Plugin Manager)
source ~/.zsh/antibody.zsh

# Turn on Prompt Substitution
setopt PROMPT_SUBST

# Load specific oh-my-zsh bits I want / need
source ~/oh-my-zsh/lib/git.zsh
source ~/oh-my-zsh/lib/theme-and-appearance.zsh
source ~/oh-my-zsh/lib/completion.zsh
source ~/oh-my-zsh/lib/directories.zsh
source ~/oh-my-zsh/lib/key-bindings.zsh
source ~/oh-my-zsh/lib/spectrum.zsh
source ~/oh-my-zsh/lib/history.zsh

# Load secrets
if [ -e "~/secrets" ]; then
  source ~/secrets
fi

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

# RBENV
export PATH="/usr/local/sbin:$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"


export GOPATH="$HOME/golang"
export GOROOT=/usr/local/opt/go/libexec

path=(
 $path
 $HOME/.nodenv/bin
 $GOPATH/bin
 $GOROOT/bin
)

eval "$(nodenv init -)"


# Get Antibody to load plugins
antibody bundle < ~/.zsh/plugins.txt

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
