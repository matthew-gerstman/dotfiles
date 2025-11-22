# Starship prompt
eval "$(starship init zsh)"

# Enhanced command replacements (drop-in replacements for standard commands)
alias ls='eza --icons --group-directories-first'
alias l='eza --icons --group-directories-first -l --git'
alias ll='eza --icons --group-directories-first -l'
alias la='eza --icons --group-directories-first -la'
alias cat='bat'
alias grep='rg'
alias find='fd'

# Git shortcuts and typo fixes
alias g='git'
alias gti='git'
alias got='git'

# Reload shell configuration
alias reload='source ~/.zshrc'

# bun completions
[ -s "/Users/matthew/.bun/_bun" ] && source "/Users/matthew/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export GITHUB_USERNAME="matthew-gerstman"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# opencode
export PATH=/Users/matthew/.opencode/bin:$PATH

# ============================================================================
# ZSH Configuration (replaces old .inputrc + bash dotfiles)
# ============================================================================

# ----------------------------------------------------------------------------
# History Configuration
# ----------------------------------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=32768                    # History in memory
SAVEHIST=32768                    # History saved to file
setopt HIST_IGNORE_DUPS           # Don't save duplicate commands
setopt HIST_IGNORE_SPACE          # Don't save commands starting with space
setopt HIST_FIND_NO_DUPS          # Don't show duplicates when searching
setopt SHARE_HISTORY              # Share history between sessions
setopt APPEND_HISTORY             # Append to history file
setopt INC_APPEND_HISTORY         # Write to history immediately

# ----------------------------------------------------------------------------
# Smart History Search (replaces .inputrc Up/Down arrow behavior)
# ----------------------------------------------------------------------------
# Type partial command and press Up/Down to search history
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search    # Up arrow
bindkey "^[[B" down-line-or-beginning-search  # Down arrow

# ----------------------------------------------------------------------------
# Tab Completion Configuration (replaces .inputrc completion settings)
# ----------------------------------------------------------------------------
autoload -Uz compinit && compinit

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Show file type indicators (like ls -F)
setopt LIST_TYPES

# Automatically add trailing slash for directory symlinks
setopt AUTO_PARAM_SLASH

# Complete in the middle of words
setopt COMPLETE_IN_WORD

# Move cursor to end of word after completion
setopt ALWAYS_TO_END

# Show completion menu on successive tab press
setopt AUTO_MENU

# Don't show hidden files in completion unless explicitly typed
_comp_options+=(globdots)

# Better completion display
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'

# ----------------------------------------------------------------------------
# Navigation Aliases (from old .aliases)
# ----------------------------------------------------------------------------
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias -- -='cd -'

# ----------------------------------------------------------------------------
# Useful Shortcuts (from old .aliases)
# ----------------------------------------------------------------------------
alias h='history'
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"
alias week='date +%V'

# Show/hide hidden files in Finder
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# Flush DNS cache
alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder"

# ----------------------------------------------------------------------------
# Useful Functions (from old .functions)
# ----------------------------------------------------------------------------

# Create a new directory and enter it
mkd() {
    mkdir -p "$@" && cd "$_"
}

# Simple calculator
calc() {
    local result=""
    result="$(printf "scale=10;$*\n" | bc --mathlib | tr -d '\\\n')"
    if [[ "$result" == *.* ]]; then
        printf "$result" |
        sed -e 's/^\./0./' \
            -e 's/^-\./-0./' \
            -e 's/0*$//;s/\.$//'
    else
        printf "$result"
    fi
    printf "\n"
}

# Determine size of a file or total size of a directory
fs() {
    if du -b /dev/null > /dev/null 2>&1; then
        local arg=-sbh
    else
        local arg=-sh
    fi
    if [[ -n "$@" ]]; then
        du $arg -- "$@"
    else
        du $arg .[^.]* ./*
    fi
}

# Open current directory or file in Finder
o() {
    if [ $# -eq 0 ]; then
        open .
    else
        open "$@"
    fi
}

# Better tree command (requires tree: brew install tree)
tre() {
    tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX
}

# Compare original and gzipped file size
gz() {
    local origsize=$(wc -c < "$1")
    local gzipsize=$(gzip -c "$1" | wc -c)
    local ratio=$(echo "$gzipsize * 100 / $origsize" | bc -l)
    printf "orig: %d bytes\n" "$origsize"
    printf "gzip: %d bytes (%2.2f%%)\n" "$gzipsize" "$ratio"
}

# ----------------------------------------------------------------------------
# Environment Variables
# ----------------------------------------------------------------------------
export EDITOR='vim'
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'
