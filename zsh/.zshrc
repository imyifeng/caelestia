# History
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY

# Starship custom prompt
command -v starship &> /dev/null && eval "$(starship init zsh)"

# Direnv
command -v direnv &> /dev/null && eval "$(direnv hook zsh)"

# Zoxide
command -v zoxide &> /dev/null && eval "$(zoxide init zsh --cmd cd)"

# Better ls
command -v eza &> /dev/null && alias ls='eza --icons --group-directories-first -1'

# Aliases
alias lg='lazygit'
alias gd='git diff'
alias ga='git add .'
alias gc='git commit -am'
alias gl='git log'
alias gs='git status'
alias gst='git stash'
alias gsp='git stash pop'
alias gp='git push'
alias gpl='git pull'
alias gsw='git switch'
alias gsm='git switch main'
alias gb='git branch'
alias gbd='git branch -d'
alias gco='git checkout'
alias gsh='git show'
alias l='ls'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'

# Custom colours
cat ~/.local/state/caelestia/sequences.txt 2> /dev/null

# zsh-autosuggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# zsh-completions
zstyle ':completion:*' menu select
autoload -Uz compinit
compinit

# zsh-syntax-highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Custom zsh config
[[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/caelestia/user-config.zsh" ]] && source "${XDG_CONFIG_HOME:-$HOME/.config}/caelestia/user-config.zsh"
