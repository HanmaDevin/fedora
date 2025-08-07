#  _________  _   _    ____ ___  _   _ _____ ___ ____
# |__  / ___|| | | |  / ___/ _ \| \ | |  ___|_ _/ ___|
#   / /\___ \| |_| | | |  | | | |  \| | |_   | | |  _
#  / /_ ___) |  _  | | |__| |_| | |\  |  _|  | | |_| |
# /____|____/|_| |_|  \____\___/|_| \_|_|   |___\____|

# Set environment for plugin manager
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# check if already installed, if not install it - useful for new machines
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# Add plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

# Add snippets
zinit snippet OMZP::sudo

autoload -Uz compinit && compinit
zinit cdreplay -q

zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath' 
zstyle ':completion:*' fzf-search-display true

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
# Print tree structure in the preview window
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'tree -C {}'"export FZF_COMPLETION_TRIGGER='**'

# CTRL-Y to copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'

export FZF_COMPLETION_PATH_OPTS="--walker file,dir,follow,hidden"
export FZF_COMPLETION_DIR_OPTS="--walker dir,follow"

export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/go/bin"

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd) fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \$' {}" "$@" ;;
    ssh) fzf --preview 'dig {}' "$@" ;;
    *) fzf --preview "--preview 'bat -n --color=always --line-range :500'" "$@" ;;
  esac
}

# Helpful aliases
alias  c='clear' 
alias ls='lsd -a -l -h -g --group-directories-first'  
alias lt='lsd --tree --depth=3' 
alias cd="z"
alias refresh="source ~/.zshrc"

# pacman
alias get="sudo dnf install -y"
alias remove="sudo dnf remove -y"
alias update="sudo dnf upgrade"

alias copy="xsel -i -b"
alias paste="xsel -o -b"

alias editzsh="nvim ~/.zshrc"

cowsay -p "Don't forget to pull from github!"

# visual
alias open="xdg-open"
alias q="exit"
alias lg="lazygit"
alias bat='bat -p --color=always --theme="Dracula"'

alias v="nvim"
alias vim="nvim"
alias vi="nvim"
alias grep="grep --color=always"
alias find="fd --color=always"

alias ..='z ..'
# you may also use the following one
bindkey -s '^o' 'nvim $(fzf)\n'

# python environments
alias deac="deactivate"
function createnv() {
  envpath=$1
  python3 -m venv "$PWD/$envpath"
  cd "$PWD/$envpath"
}

# Always mkdir a path (this doesn't inhibit functionality to make a single dir)
alias mkdir='mkdir -p'

export EDITOR=nvim

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_save_no_dups
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

setopt correct
setopt notify
setopt numericglobsort

# fnm
FNM_PATH="/home/devin/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "`fnm env`"
fi

# fnm
FNM_PATH="/home/devin/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/home/devin/.local/share/fnm:$PATH"
  eval "`fnm env`"
fi
