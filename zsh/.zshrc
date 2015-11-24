# Load Antibody (Plugin Manager)
source ~/.zsh/antibody.zsh

# Turn on Prompt Substitution
setopt PROMPT_SUBST

# Load specific oh-my-zsh bits I want / need
source ~/oh-my-zsh/lib/git.zsh
source ~/oh-my-zsh/lib/theme-and-appearance.zsh

# Get Antibody to load plugins
antibody bundle < ~/.zsh/plugins.txt
