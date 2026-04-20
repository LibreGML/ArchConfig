#!/bin/bash
# =============================================================================
# Universal Modern Bash Configuration
# Compatible with: Fedora, CentOS, RHEL, Debian, Ubuntu, Arch, macOS, Termux
# =============================================================================

export TERM=xterm

# Exit if not interactive shell
[[ $- != *i* ]] && return

# =============================================================================
# Environment Detection
# =============================================================================

# Detect special environments
if [[ -n "$TERMUX_VERSION" ]]; then
    SYSROOT="/data/data/com.termux/files"
elif [[ -d "/data/data/com.termux" ]]; then
    SYSROOT="/data/data/com.termux/files"
else
    SYSROOT=""
fi

# Runtime data directory (use PID to avoid conflicts)
RAMFS_DIR="${SYSROOT:-/tmp}/bashrc_data_$$"
mkdir -p "$RAMFS_DIR" 2>/dev/null || RAMFS_DIR="/tmp/bashrc_fallback_$$"
mkdir -p "$RAMFS_DIR" 2>/dev/null || true

# =============================================================================
# Shell Options & History
# =============================================================================

# History settings
HISTFILE="${HOME}/.bash_history"
HISTSIZE=100000
HISTFILESIZE=200000
HISTCONTROL="ignorespace:ignoredups"
shopt -s histappend

# Enhanced shell behavior
shopt -s autocd cdspell histverify checkwinsize globstar
shopt -s cdable_vars extglob dirspell dotglob
shopt -s no_empty_cmd_completion

# Color support
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export TERM="${TERM:-xterm-256color}"
export LESS="-R"  # Enable colors in less

# =============================================================================
# Path Management System
# =============================================================================

PATHS_SAVE_FILE="$RAMFS_DIR/saved_paths.txt"
CD_HISTFILE="${HOME}/.bash_cd_history"

# Initialize files safely
for _file in "$PATHS_SAVE_FILE" "$CD_HISTFILE"; do
    if [[ ! -f "$_file" ]]; then
        touch "$_file" 2>/dev/null || true
    fi
done
unset _file

# Save original PATH for restoration
ORIGINAL_PATH="$PATH"

# =============================================================================
# Core Utility Functions
# =============================================================================

# Command execution timer
__timing_start() {
    __cmd_start_time=$(date +%s%N 2>/dev/null) || __cmd_start_time=""
}

__timing_end() {
    local ret=$?
    
    if [[ -n "$__cmd_start_time" && -n "$__last_command" ]]; then
        local end_time
        end_time=$(date +%s%N 2>/dev/null) || end_time=""
        
        if [[ -n "$end_time" ]]; then
            local elapsed_ns=$(( end_time - __cmd_start_time ))
            local elapsed_sec
            
            # Use awk for floating point calculation (more portable than bc)
            elapsed_sec=$(awk "BEGIN {printf \"%.2f\", ${elapsed_ns}/1000000000}" 2>/dev/null) || elapsed_sec="?"
            
            if [[ $ret -eq 0 ]]; then
                printf "\r\033[K\033[1;32m✓ %s (%ss)\033[m\n" "${__last_command}" "$elapsed_sec"
            else
                printf "\r\033[K\033[1;31m✗ %s (exit: %d, %ss)\033[m\n" "${__last_command}" "$ret" "$elapsed_sec"
            fi
        fi
    fi
    
    unset __cmd_start_time __last_command
    return $ret
}

# Smart PWD display with path validation
__smart_pwd() {
    local home_tilde="\033[1;35m~\033[m"
    local root_slash="\033[1;34m/\033[m"
    local dir_color="\033[0;32m"
    local link_color="\033[1;36m"
    local error_color="\033[1;31m"
    
    # Handle special cases
    if [[ "$PWD" == "$HOME" ]]; then
        echo -e "$home_tilde"
        return
    elif [[ "$PWD" == "/" ]]; then
        echo -e "$root_slash"
        return
    fi
    
    # Convert home directory to tilde
    local display_path="${PWD/#$HOME/\~}"
    local result=""
    
    # Split path and process each component
    local IFS='/'
    local -a parts=($display_path)
    local accumulated_path=""
    
    for i in "${!parts[@]}"; do
        local part="${parts[$i]}"
        [[ -z "$part" ]] && continue
        
        # Build accumulated path for validation
        if [[ "$i" -eq 0 && "${parts[0]}" == "~" ]]; then
            accumulated_path="$HOME"
            result+="${home_tilde}/"
            continue
        else
            accumulated_path+="/${part}"
        fi
        
        # Determine color based on file type
        local color="$dir_color"
        if [[ -L "$accumulated_path" ]]; then
            color="$link_color"
        elif [[ ! -e "$accumulated_path" ]]; then
            color="$error_color"
        fi
        
        result+="${color}${part}\033[m/"
    done
    
    # Remove trailing slash
    echo -e "${result%/}"
}

# Git branch detection (safe for non-git directories)
__git_branch() {
    # Only run git commands if we're likely in a git repo
    [[ -d ".git" ]] || return 0
    
    local branch
    branch=$(git symbolic-ref --short HEAD 2>/dev/null) || \
    branch=$(git rev-parse --short HEAD 2>/dev/null) || \
    return 0
    
    if [[ -n "$branch" ]]; then
        printf " \033[1;31m[\033[m%s\033[1;31m]\033[m" "$branch"
    fi
}

# =============================================================================
# Enhanced CD with History Tracking
# =============================================================================

cd() {
    builtin cd "$@" || return $?
    
    # Record current directory to history
    if [[ -w "$CD_HISTFILE" ]]; then
        echo "$PWD" >> "$CD_HISTFILE"
        
        # Keep only last 100 unique entries
        if [[ -f "$CD_HISTFILE" ]]; then
            local tmp_file="${CD_HISTFILE}.tmp.$$"
            if tac "$CD_HISTFILE" 2>/dev/null | awk '!seen[$0]++' | tac > "$tmp_file" 2>/dev/null; then
                head -n 100 "$tmp_file" > "${tmp_file}.head" 2>/dev/null
                mv "${tmp_file}.head" "$CD_HISTFILE" 2>/dev/null
            fi
            rm -f "$tmp_file" "${tmp_file}.head" 2>/dev/null
        fi
    fi
    
    # Update terminal title
    printf '\033]0;%s@%s:%s\007' "${USER:-user}" "${HOSTNAME%%.*}" "$(basename "$PWD")" 2>/dev/null || true
}

# Undo last cd operation
uncd() {
    if [[ ! -s "$CD_HISTFILE" ]]; then
        echo "No cd history available" >&2
        return 1
    fi
    
    # Get previous directory (second to last entry)
    local prev_dir
    prev_dir=$(tail -n 2 "$CD_HISTFILE" 2>/dev/null | head -n 1)
    
    if [[ -n "$prev_dir" && -d "$prev_dir" ]]; then
        cd "$prev_dir"
        
        # Remove the last two entries from history
        local line_count
        line_count=$(wc -l < "$CD_HISTFILE" 2>/dev/null) || line_count=0
        
        if [[ "$line_count" -gt 2 ]]; then
            head -n -2 "$CD_HISTFILE" > "${CD_HISTFILE}.tmp" 2>/dev/null && \
            mv "${CD_HISTFILE}.tmp" "$CD_HISTFILE" 2>/dev/null
        else
            > "$CD_HISTFILE"
        fi
    else
        echo "Previous directory no longer exists: $prev_dir" >&2
        return 1
    fi
}

# =============================================================================
# Path Bookmark System
# =============================================================================

savepath() {
    local target_path="${1:-$PWD}"
    
    # Resolve to absolute path
    target_path=$(realpath "$target_path" 2>/dev/null || readlink -f "$target_path" 2>/dev/null) || {
        echo "Error: Cannot resolve path '$1'" >&2
        return 1
    }
    
    # Validate path exists
    if [[ ! -d "$target_path" ]]; then
        echo "Error: Directory does not exist: $target_path" >&2
        return 1
    fi
    
    # Find next available bookmark number
    local num=1
    while grep -q "^bpath${num}=" "$PATHS_SAVE_FILE" 2>/dev/null; do
        ((num++))
    done
    
    # Save bookmark
    echo "bpath${num}=${target_path}" >> "$PATHS_SAVE_FILE"
    echo "Saved: bpath${num} → ${target_path}"
}

rmpath() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: rmpath <bookmark_number> [number2 ...]" >&2
        return 1
    fi
    
    local removed=0
    for num in "$@"; do
        # Validate input is a number
        if [[ ! "$num" =~ ^[0-9]+$ ]]; then
            echo "Invalid bookmark number: $num" >&2
            continue
        fi
        
        if grep -q "^bpath${num}=" "$PATHS_SAVE_FILE" 2>/dev/null; then
            sed -i "/^bpath${num}=/d" "$PATHS_SAVE_FILE" 2>/dev/null && {
                echo "Removed: bpath${num}"
                ((removed++))
            }
        else
            echo "Not found: bpath${num}" >&2
        fi
    done
    
    [[ $removed -eq 0 ]] && return 1
    return 0
}

lspath() {
    if [[ ! -s "$PATHS_SAVE_FILE" ]]; then
        echo "No saved paths" >&2
        return 1
    fi
    
    # Display with formatting if column is available
    if command -v column &>/dev/null; then
        column -t -s '=' < "$PATHS_SAVE_FILE" 2>/dev/null || cat "$PATHS_SAVE_FILE"
    else
        cat "$PATHS_SAVE_FILE"
    fi
}

byd() {
    if [[ $# -lt 1 ]]; then
        echo "Usage: byd <command> [args...]" >&2
        return 1
    fi
    
    local cmd="$1"
    shift
    
    # Validate command exists
    if ! command -v "$cmd" &>/dev/null; then
        echo "Command not found: $cmd" >&2
        return 127
    fi
    
    local args=()
    for arg in "$@"; do
        if [[ "$arg" =~ ^bpath([0-9]+)$ ]]; then
            local num="${BASH_REMATCH[1]}"
            local path
            path=$(grep "^bpath${num}=" "$PATHS_SAVE_FILE" 2>/dev/null | head -n 1 | cut -d'=' -f2-)
            
            if [[ -z "$path" ]]; then
                echo "Error: Bookmark bpath${num} not found" >&2
                return 1
            fi
            
            args+=("$path")
        else
            args+=("$arg")
        fi
    done
    
    "$cmd" "${args[@]}"
}

clpath() {
    > "$PATHS_SAVE_FILE" 2>/dev/null || true
    echo "All bookmarks cleared"
}

# =============================================================================
# Loop Utility Function
# =============================================================================

loop() {
    local count=0
    local ignore_errors=false
    
    # Parse options
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -u|--until-fail) 
                ignore_errors=true
                shift 
                ;;
            -n|--count) 
                if [[ -n "$2" && "$2" =~ ^[0-9]+$ ]]; then
                    count="$2"
                    shift 2
                else
                    echo "Error: --count requires a numeric argument" >&2
                    return 1
                fi
                ;;
            *) 
                break 
                ;;
        esac
    done
    
    local cmd="$*"
    [[ -z "$cmd" ]] && return 0
    
    # Execute loop
    if [[ $count -gt 0 ]]; then
        for ((i=1; i<=count; i++)); do
            eval "$cmd" || { 
                if ! $ignore_errors; then 
                    return $?
                fi 
            }
        done
    else
        while true; do
            eval "$cmd" || { 
                if ! $ignore_errors; then 
                    return $?
                fi 
            }
        done
    fi
}

# =============================================================================
# Tmux Session Manager
# =============================================================================

tmuxmgr() {
    # Check if tmux is available
    if ! command -v tmux &>/dev/null; then
        echo "tmux is not installed" >&2
        return 127
    fi
    
    # Check if already in tmux
    if [[ -n "$TMUX" ]]; then
        echo "Already in a tmux session"
        return 1
    fi
    
    # List sessions
    local sessions
    sessions=$(tmux list-sessions -F "#{session_name}" 2>/dev/null)
    
    if [[ -z "$sessions" ]]; then
        tmux new-session -s main
        return $?
    fi
    
    # Display menu
    echo -e "\033[1;32mAvailable sessions:\033[m"
    echo "$sessions" | nl -w2 -s') '
    echo -e "\n[a]ttach  [n]ew  [k]ill  [q]uit"
    
    # Read choice
    local choice
    read -rsn1 choice 2>/dev/null || return 1
    echo  # New line after keypress
    
    case "$choice" in
        a|A)
            local target
            read -ep "Session number or name: " target
            if [[ -z "$target" ]]; then
                return 1
            elif [[ "$target" =~ ^[0-9]+$ ]]; then
                target=$(echo "$sessions" | sed -n "${target}p")
            fi
            [[ -n "$target" ]] && tmux attach -t "$target"
            ;;
        n|N)
            local name
            read -ep "New session name: " name
            [[ -n "$name" ]] && tmux new-session -s "$name"
            ;;
        k|K)
            local target
            read -ep "Session to kill: " target
            [[ -n "$target" ]] && tmux kill-session -t "$target"
            ;;
        *) 
            return 1 
            ;;
    esac
}

# =============================================================================
# Prompt Configuration
# =============================================================================

__set_prompt() {
    local exit_code=$?
    
    # Split time for the original format (HH:MM :SS)
    local full_time
    full_time=$(date +%T 2>/dev/null) || full_time="??:??:??"
    local time1="${full_time%:*}"  # HH:MM
    local time2="${full_time##*:}"  # SS
    
    # User@host with colors (red+underline+blink for root, blue for normal user)
    local user_color="\[\033[1;34m\]"
    [[ $UID -eq 0 ]] && user_color="\[\033[1;31m\]\[\033[4m\]\[\033[5m\]"
    local user_host="${user_color}$(whoami)\[\033[m\]"
    
    # Smart path display
    local smart_path
    smart_path="$(__smart_pwd)"
    
    # Git branch if in repo
    local git_info
    git_info="$(__git_branch)"
    
    # Status indicator (green for success, red with code for failure)
    local status_color="\[\033[1;32m\]"
    local status_text=""
    if [[ $exit_code -ne 0 ]]; then
        status_color="\[\033[1;31m\]"
        status_text="${exit_code}"
    fi
    
    # Build beautiful two-line PS1 (matching your original design)
    PS1="\[\033[m\]┌─\[\033[1;31m\][\[\033[m\]$0-$$ ${time1}\[\033[25m\]:\[\033[m\]${time2} ${user_host}\[\033[1;31m\]@\[\033[34m\]\h ${smart_path}\[\033[1;31m\]]\[\033[m\]${git_info}
└─${status_color}${status_text}\$>>_\[\033[m\] "
    
    # Secondary prompts
    PS2='\[\033[1;33m\][Line $LINENO]>\[\033[m\]'
    PS3='\[\033[1;35m\][[$0]Select > \[\033[m\]'
    PS4='\[\033[1;35m\][[$0] Line $LINENO:> \[\033[m\]'
}

# =============================================================================
# Pre/Post Command Execution Hooks
# =============================================================================

__pre_exec() {
    # Capture command before execution
    if [[ -z "$__in_prompt" ]]; then
        __last_command="$BASH_COMMAND"
        __timing_start
    fi
}

__post_exec() {
    __in_prompt=1
    __timing_end
    __set_prompt
    unset __in_prompt
}

# Set up execution hooks
trap '__pre_exec' DEBUG
PROMPT_COMMAND="__post_exec"

# =============================================================================
# Aliases - File Operations
# =============================================================================

# Use modern ls replacements if available
if command -v eza &>/dev/null; then
    alias ls='eza --color=auto --icons --group-directories-first'
    alias l='eza -lbah --icons'
    alias ll='eza -lbg --icons'
    alias la='eza -labgh --icons'
    alias lsa='eza -lbagR --icons'
    alias lst='eza -lTabgh --icons'
    alias sl='eza --icons'
elif command -v exa &>/dev/null; then
    alias ls='exa --color=auto --icons --group-directories-first'
    alias l='exa -lbah --icons'
    alias ll='exa -lbg --icons'
    alias la='exa -labgh --icons'
else
    alias ls='ls --color=auto -v -p --group-directories-first'
    alias l='ls -lh'
    alias ll='ls -la'
    alias la='ls -lah'
    alias sl='ls'
fi

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'

# =============================================================================
# Aliases - Navigation
# =============================================================================

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias cdl='cd -'
alias cdroot='cd /'
alias home='cd ~'
alias config='cd ~/.config'
alias cache='cd ~/.cache'
alias docs='cd ~/Documents 2>/dev/null || cd ~'
alias downloads='cd ~/Downloads 2>/dev/null || cd ~'

# =============================================================================
# Aliases - System Information
# =============================================================================

# System info with fallbacks
sysinfo() {
    if command -v fastfetch &>/dev/null; then
        fastfetch 2>/dev/null
    elif command -v neofetch &>/dev/null; then
        neofetch 2>/dev/null
    elif command -v screenfetch &>/dev/null; then
        screenfetch 2>/dev/null
    else
        echo "OS: $(uname -s) $(uname -r)"
        echo "Shell: $BASH_VERSION"
        echo "Uptime: $(uptime -p 2>/dev/null || uptime)"
    fi
}

alias sysenable='sudo systemctl enable --now'
alias sysdisable='sudo systemctl disable --now'
alias sysstart='sudo systemctl start'
alias sysrestart='sudo systemctl restart'
alias sysstop='sudo systemctl stop'
alias sysstatus='sudo systemctl status'
alias boottime='systemd-analyze 2>/dev/null || echo "systemd-analyze not available"'

# =============================================================================
# Aliases - Git (Comprehensive)
# =============================================================================

alias g='git'
alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git push'
alias gl='git pull'
alias gf='git fetch'
alias gd='git diff'
alias gds='git diff --staged'
alias glog='git log --oneline --graph --all'
alias gco='git checkout'
alias gb='git branch'
alias gba='git branch -a'
alias gm='git merge'
alias gr='git rebase'
alias gt='git tag'
alias gst='git stash'
alias gstp='git stash pop'
alias gstl='git stash list'
alias gclean='git clean -fd'
alias greset='git reset --hard'
alias grestore='git restore'
alias gclone='git clone --recursive --depth=1'
alias ginit='git init'

# Quick workflows
alias gupdate='git add . && git commit -m "update"'
alias gsync='git pull --rebase && git push'

# =============================================================================
# Aliases - Docker (if available)
# =============================================================================

if command -v docker &>/dev/null; then
    alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}\t{{.Image}}"'
    alias dpsa='docker ps -a'
    alias dimages='docker images'
    alias drun='docker run -it --rm'
    alias dstop='docker stop'
    alias dstart='docker start'
    alias drm='docker rm -f'
    alias drmi='docker rmi -f'
    alias dex='docker exec -it'
    alias dlog='docker logs -f --tail 100'
    alias dpull='docker pull'
    alias dpush='docker push'
    alias dlogin='docker login'
    
    # Helper functions
    denter() {
        local container
        container=$(docker ps --format '{{.Names}}' | grep "$1" | head -1)
        if [[ -z "$container" ]]; then
            echo "Container not found: $1" >&2
            return 1
        fi
        docker exec -it "$container" /bin/sh
    }
    
    dtopmem() {
        docker stats --no-stream --format "table {{.Name}}\t{{.MemPerc}}\t{{.MemUsage}}\t{{.CPUPerc}}" | \
        sort -k2 -hr | head -20
    }
fi

# =============================================================================
# Aliases - Common Utilities
# =============================================================================

# Sudo shortcuts
alias sudo='sudo '
alias _='sudo'
alias sus='sudo -s'

# Editor preferences (fallback chain)
if command -v micro &>/dev/null; then
    alias e='micro'
    alias vim='micro'
    alias nvim='micro'
elif command -v vim &>/dev/null; then
    alias e='vim'
elif command -v vi &>/dev/null; then
    alias e='vi'
fi

alias bashrc='${EDITOR:-micro} ~/.bashrc'

# Process monitoring (cross-platform compatible)
topcpu() {
    if command -v ps &>/dev/null; then
        # GNU ps (Linux)
        ps aux --sort=-%cpu 2>/dev/null | head -11 || \
        # BSD ps (macOS)
        ps aux -o %cpu,rss,command | sort -rn | head -11
    else
        top -o cpu 2>/dev/null || echo "Process monitoring not available"
    fi
}

topmem() {
    if command -v ps &>/dev/null; then
        ps aux --sort=-%mem 2>/dev/null | head -11 || \
        ps aux -o %mem,rss,command | sort -rn | head -11
    else
        top -o mem 2>/dev/null || echo "Process monitoring not available"
    fi
}

# Disk usage
alias ducks='du -cksh * 2>/dev/null | sort -hr | head'
alias dusort='du -sh * 2>/dev/null | sort -hr'
alias diskinfo='df -h 2>/dev/null && echo && lsblk 2>/dev/null'

# Network utilities
alias myip='curl -s https://api.ipify.org 2>/dev/null || echo "Cannot determine IP"'
alias ports='ss -tlnp 2>/dev/null || netstat -tlnp 2>/dev/null'

# Archive operations
alias mktar='tar -czvf'
alias untar='tar -xzvf'
alias mktbz='tar -cjvf'
alias untbz='tar -xjvf'

# Permissions
alias chmodx='chmod +x'
alias chownme='sudo chown -R $USER:$USER'

# DNS
alias flushdns='sudo resolvectl flush-caches 2>/dev/null || sudo systemd-resolve --flush-caches 2>/dev/null || echo "DNS flush not supported"'

alias py='python3'

# =============================================================================
# Completion Setup
# =============================================================================

if ! shopt -oq posix; then
    # Try multiple completion locations for portability
    for comp_file in \
        /usr/share/bash-completion/bash_completion \
        /etc/bash_completion \
        /usr/local/share/bash-completion/bash_completion \
        "${SYSROOT}/usr/share/bash-completion/bash_completion" \
        /usr/share/bash-completion/bash_completion.sh; do
        if [[ -f "$comp_file" ]]; then
            . "$comp_file"
            break
        fi
    done
fi

# Custom completions for path bookmarks
_comp_bookmarks() {
    local cur
    cur="${COMP_WORDS[COMP_CWORD]}"
    
    if [[ -r "$PATHS_SAVE_FILE" ]]; then
        COMPREPLY=($(compgen -W "$(cut -d'=' -f1 "$PATHS_SAVE_FILE" 2>/dev/null)" -- "$cur"))
    fi
}

complete -F _comp_bookmarks byd rmpath 2>/dev/null || true

# =============================================================================
# Key Bindings
# =============================================================================

# Enhanced tab completion
bind 'set show-all-if-ambiguous on'
bind 'set menu-complete-display-prefix on'
bind '"\t": menu-complete'
bind '"\e[Z": menu-complete-backward'
bind 'set colored-stats on'
bind 'set colored-completion-prefix on'

# Tmux manager shortcut
bind -x '"\C-x\C-t": tmuxmgr' 2>/dev/null || true

# History search
bind '"\C-r": reverse-search-history'

# =============================================================================
# Startup Display
# =============================================================================

if [[ -z "$SUDO_USER" && $$ -ne 1 ]]; then
    # Try system info tools in order of preference
    if command -v fastfetch &>/dev/null; then
        fastfetch --logo arch 2>/dev/null || fastfetch 2>/dev/null
    elif command -v neofetch &>/dev/null; then
        neofetch 2>/dev/null
    fi
fi

# =============================================================================
# Cleanup on Exit
# =============================================================================

__cleanup() {
    # Remove temporary runtime directory
    if [[ -d "$RAMFS_DIR" && "$RAMFS_DIR" =~ bashrc_data_[0-9]+$ ]]; then
        rm -rf "$RAMFS_DIR" 2>/dev/null
    fi
}

trap __cleanup EXIT

# =============================================================================
# User Customizations
# =============================================================================

# Load user-specific aliases and functions
[[ -f "${HOME}/.bash_aliases" ]] && source "${HOME}/.bash_aliases"
[[ -f "${HOME}/.bash_functions" ]] && source "${HOME}/.bash_functions"

# Initialize fzf if available
_fzf_init_paths=(
    /usr/share/fzf/shell/key-bindings.bash      
    /usr/share/fzf/key-bindings.bash           
    /usr/share/doc/fzf/examples/key-bindings.bash  
    "${SYSROOT}/usr/share/fzf/key-bindings.bash"  
)

for fzf_binding in "${_fzf_init_paths[@]}"; do
    if [[ -f "$fzf_binding" ]]; then
        source "$fzf_binding"
        break
    fi
done
unset _fzf_init_paths fzf_binding

# Initialize zoxide if available
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init bash 2>/dev/null)" || true
fi
