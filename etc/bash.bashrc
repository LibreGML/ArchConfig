#!/bin/bash

# =============================================================================
# 环境检测与初始化
# =============================================================================

export TERM=xterm

[[ $- != *i* ]] && return

if [[ -n "$TERMUX_VERSION" ]]; then
    SYSROOT="/data/data/com.termux/files"
elif [[ -d "/data/data/com.termux" ]]; then
    SYSROOT="/data/data/com.termux/files"
else
    SYSROOT=""
fi

# =============================================================================
# Shell选项与历史记录配置
# =============================================================================

HISTFILE="${HOME}/.bash_history"
HISTSIZE=100000
HISTFILESIZE=200000
HISTCONTROL="ignorespace:ignoredups"
shopt -s histappend
shopt -s autocd cdspell histverify checkwinsize globstar
shopt -s cdable_vars extglob dirspell dotglob
shopt -s no_empty_cmd_completion
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export LESS="-R"

# =============================================================================
# 文件查找函数
# =============================================================================

_parse_find_args() {
    local cmd_name="$1"
    shift
    local user_args=("$@")
    
    local search_path="."
    local pattern=""
    
    case ${#user_args[@]} in
        1)
            pattern="${user_args[0]}"
            ;;
        2)
            search_path="${user_args[0]}"
            pattern="${user_args[1]}"
            ;;
        *)
            echo "❌ 错误: 参数过多。用法: $cmd_name [路径] 模式" >&2
            return 1
            ;;
    esac
    
    if [[ "$search_path" == ~* ]]; then
        search_path=$(realpath -- "$search_path" 2>/dev/null || echo "$search_path")
    fi
    
    if [[ ! -e "$search_path" ]]; then
        printf "❌ 错误: 路径不存在: %s\n" "$search_path" >&2
        return 2
    fi
    
    if [[ ! -d "$search_path" ]]; then
        printf "❌ 错误: 路径不是目录: %s\n" "$search_path" >&2
        return 2
    fi
    
    if [[ -z "$pattern" ]]; then
        printf "❌ 错误: 搜索模式不能为空\n" >&2
        return 3
    fi
    
    echo "$search_path"
    echo "$pattern"
    return 0
}

findfile() {
    local parsed
    parsed=$(_parse_find_args findfile "$@") || return $?
    
    local search_path
    search_path=$(echo "$parsed" | head -1)
    local pattern
    pattern=$(echo "$parsed" | tail -1)
    
    find "$search_path" -type f -iname "*$pattern*" 2>/dev/null | head -1000
}

finddir() {
    local parsed
    parsed=$(_parse_find_args finddir "$@") || return $?
    
    local search_path
    search_path=$(echo "$parsed" | head -1)
    local pattern
    pattern=$(echo "$parsed" | tail -1)
    
    find "$search_path" -type d -iname "*$pattern*" 2>/dev/null | head -500
}

findtext() {
    local parsed
    parsed=$(_parse_find_args findtext "$@") || return $?
    
    local search_path
    search_path=$(echo "$parsed" | head -1)
    local pattern
    pattern=$(echo "$parsed" | tail -1)
    
    if command -v rg &>/dev/null; then
        rg --smart-case --hidden --no-ignore \
           --max-depth 8 --max-filesize 10M \
           --max-columns=150 \
           --glob='!{.git,.svn,.hg,node_modules,build,target,dist,.cache,__pycache__,.DS_Store}' \
           -- "$pattern" "$search_path" 2>/dev/null | head -500
    else
        echo "❌ 错误: 请安装 ripgrep (rg)" >&2
        return 127
    fi
}

# =============================================================================
# 空目录清理函数
# =============================================================================

rmemptydir() {
    local target="${1:-.}"
    
    if [[ ! -e "$target" ]]; then
        echo "❌ rmemptydir: 错误: 路径不存在" >&2
        return 1
    fi
    
    if [[ ! -d "$target" ]]; then
        echo "❌ rmemptydir: 错误: 不是目录" >&2
        return 1
    fi
    
    if [[ -L "$target" ]]; then
        echo "❌ rmemptydir: 错误: 拒绝操作符号链接" >&2
        return 1
    fi
    
    local abs_target
    abs_target=$(realpath "$target")
    
    local protected_dirs=("/" "/home" "/root" "/etc" "/var" "/usr" "/bin" "/sbin" "/lib" "/lib64" "/tmp" "/dev" "/proc" "/sys")
    for protected in "${protected_dirs[@]}"; do
        if [[ "$abs_target" == "$protected" ]]; then
            echo "🛡️ rmemptydir: 安全错误: 禁止操作系统关键目录" >&2
            return 1
        fi
    done
    
    local total_count=0
    local iteration=0
    local max_iterations=100
    
    while [[ $iteration -lt $max_iterations ]]; do
        ((iteration++))
        
        local tmpfile
        tmpfile=$(mktemp)
        local round_count=0
        
        find "$target" -mindepth 1 -depth -type d -empty \
             ! -type l ! -fstype proc ! -fstype sysfs ! -fstype devfs \
             -print0 2>/dev/null > "$tmpfile"
        
        if [[ ! -s "$tmpfile" ]]; then
            rm -f "$tmpfile"
            break
        fi
        
        while IFS= read -r -d '' dir; do
            if [[ -n "$dir" && -d "$dir" ]]; then
                if [[ -w "$dir" ]]; then
                    if rmdir "$dir" 2>/dev/null; then
                        local display="${dir//$'\n'/␊}"
                        printf "🗑️ 已删除: %s\n" "$display"
                        ((round_count++))
                        ((total_count++))
                    fi
                fi
            fi
        done < "$tmpfile"
        
        rm -f "$tmpfile"
        
        [[ $round_count -eq 0 ]] && break
    done
    
    if [[ $iteration -ge $max_iterations ]]; then
        echo "⚠️ rmemptydir: 警告: 达到最大迭代次数" >&2
    fi
    
    if [[ $total_count -eq 0 ]]; then
        echo "📂 未发现空目录"
    else
        echo "✅ 完成: 共删除 $total_count 个空目录（迭代 $iteration 轮）"
    fi
}

# =============================================================================
# HTTP请求封装函数
# =============================================================================

get() {
    # get "https://uapis.cn/api/v1/answerbook/ask" "question=人生的意义是什么"
    # get "https://uapis.cn/api/v1/convert/unixtime" "time=2023-10-27 10:30:00"
    # get "https://uapis.cn/api/v1/network/ping" "host=baidu.com"
    local url="$1"
    
    if [[ ! "$url" =~ ^https?:// ]]; then
        echo "❌ 必须要http:// 或 https:// 开头" >&2
        return 1
    fi
    
    local cmd=(curl -s -f -m 10 -X GET \
        -H "User-Agent: http_get/1.0" \
        -H "Accept: application/json, */*" \
        -H "Accept-Encoding: gzip, deflate" \
        -w "\n%{http_code}" \
        -G)
    
    shift  
    local param
    for param in "$@"; do
        if [[ "$param" =~ ^[^=]+= ]]; then
            cmd+=("--data-urlencode" "$param")
        else
            echo "⚠️ Warning: Skipping malformed parameter '$param'" >&2
        fi
    done
    
    cmd+=("$url")
    
    local response
    response=$( "${cmd[@]}" 2>&1 ) || {
        echo "❌ Error: Failed to execute curl" >&2
        return 1
    }
    
    local lines_array=()
    while IFS= read -r line; do
        lines_array+=("$line")
    done <<< "$response"
    
    local lines_count=${#lines_array[@]}
    if [[ $lines_count -lt 2 ]]; then
        echo "❌ Error: Invalid response from server" >&2
        return 1
    fi
    
    local status_code="${lines_array[$((lines_count-1))]}"
    local body_lines=("${lines_array[@]:0:$((lines_count-1))}")
    
    if [[ ! "$status_code" =~ ^2[0-9][0-9]$ ]]; then
        echo "🔴 HTTP $status_code" >&2
        if [[ ${#body_lines[@]} -gt 0 ]]; then
            printf '%s\n' "${body_lines[@]}" >&2
        fi
        return 1
    fi
    
    if [[ ${#body_lines[@]} -eq 0 ]]; then
        return 0
    fi
    
    local body_str
    body_str=$(printf '%s\n' "${body_lines[@]}")
    
    if command -v jq >/dev/null 2>&1; then
        echo "$body_str" | jq -e . 2>/dev/null || echo "$body_str"
    else
        echo "$body_str"
    fi
}


post() {
    local url="$1"
    local json="$2"
    
    local response
    response=$(curl -s -X POST \
        -H "Content-Type: application/json" \
        -d "$json" \
        "$url")
    
    if command -v jq &>/dev/null; then
        echo "$response" | jq .
    else
        echo "$response"
    fi
}

postfile() {
    local url="$1"
    shift
    
    local cmd=(curl -s -X POST)
    
    for part in "$@"; do
        cmd+=(-F "$part")
    done
    
    cmd+=("$url")
    
    "${cmd[@]}"
}

# =============================================================================
# 开发工具函数
# =============================================================================

genkey() {
    openssl rand -base64 32 | tr -d '\n=' | tr '/+' '_-'
    echo
}

mine() {
    local user
    user=$(whoami)
    
    for item in "$@"; do
        if [[ -d "$item" ]]; then
            sudo chown -R "$user:$user" "$item"
            echo "✓ $item/* → $user:$user"
        else
            sudo chown "$user:$user" "$item"
            echo "✓ $item → $user:$user"
        fi
    done
}

# =============================================================================
# 批量重命名函数
# =============================================================================

batchrename() {
    local regex="$1"
    local replacement="$2"
    shift 2
    local files=("$@")
    
    if [[ -z "$regex" ]]; then
        echo "❌ 错误: 正则表达式不能为空" >&2
        return 1
    fi
    
    for file in "${files[@]}"; do
        if [[ -e "$file" ]]; then
            local new_name
            new_name=$(echo "$file" | sed -E "s|${regex}|${replacement}|g")
            
            if [[ -z "$new_name" || "$file" == "$new_name" ]]; then
                continue
            fi
            
            if [[ "$new_name" == *..* ]]; then
                echo "⚠️ 跳过不安全的重命名: $file -> $new_name" >&2
                continue
            fi
            
            if [[ "$file" != /* && "$new_name" == /* ]]; then
                echo "⚠️ 跳过不安全的重命名（相对路径变为绝对路径）: $file -> $new_name" >&2
                continue
            fi
            
            mv -i "$file" "$new_name"
            echo "📝 Renamed: $file -> $new_name"
        fi
    done
}

multirename() {
    for file in "$@"; do
        echo "📄 当前文件: $file"
        read -rp "新文件名 (留空跳过，'q'退出): " new_name
        
        if [[ -z "$new_name" ]]; then
            echo "⏭️ 跳过: $file"
        elif [[ "$new_name" == "q" ]]; then
            echo "🚪 退出重命名"
            return
        else
            mv "$file" "$new_name"
            echo "✅ 已重命名: $file -> $new_name"
        fi
        echo "---"
    done
}

# =============================================================================
# 文本替换函数
# =============================================================================

replacetext() {
    local file_pattern="$1"
    local old_string="$2"
    local new_string="$3"
    
    if [[ -z "$old_string" ]]; then
        echo "❌ 错误：旧字符串不能为空" >&2
        return 1
    fi
    
    if ! command -v perl &>/dev/null; then
        echo "❌ 错误: 请安装 perl" >&2
        return 127
    fi
    
    export REPLACE_OLD="$old_string"
    export REPLACE_NEW="$new_string"
    
    find . -type f -name "$file_pattern" -exec perl -pi -e '
        use strict;
        use warnings;
        my $old = $ENV{REPLACE_OLD};
        my $new = $ENV{REPLACE_NEW};
        s/\Q$old\E/$new/g;
    ' {} +
    
    unset REPLACE_OLD REPLACE_NEW
    
    echo "✅ 替换完成"
}

# =============================================================================
# 压缩工具函数
# =============================================================================

mktar() {
    for target in "$@"; do
        if [[ ! -e "$target" ]]; then
            echo "❌ 错误: '$target' 不存在，跳过"
            continue
        fi
        
        local base_name
        base_name=$(basename "$target")
        local tar_name="$base_name.tar"
        
        if [[ -e "$tar_name" ]]; then
            read -rp "'$tar_name' 已存在，覆盖？(y/N): " confirm
            if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
                echo "⏭️ 跳过: $target (已存在 $tar_name)"
                continue
            fi
        fi
        
        echo "📦 正在创建: $tar_name"
        if tar -cvf "$tar_name" "$target" 2>/dev/null; then
            echo "✅ 已创建: $tar_name"
        else
            echo "❌ 创建失败: $tar_name"
        fi
    done
}

# =============================================================================
# 目录创建函数
# =============================================================================

mkcd() {
    if [[ $# -ne 1 ]]; then
        echo "📝 用法: mkcd 'My Directory'" >&2
        return 1
    fi
    
    if mkdir -p "$1" && cd "$1"; then
        :
    else
        echo "❌ 创建目录失败: $1" >&2
        return 1
    fi
}


# =============================================================================
# 智能路径显示函数
# =============================================================================

__smart_pwd() {
    local home_tilde="\033[1;35m~\033[m"
    local root_slash="\033[1;34m/\033[m"
    local dir_color="\033[0;32m"
    local link_color="\033[1;36m"
    local error_color="\033[1;31m"
    
    if [[ "$PWD" == "$HOME" ]]; then
        echo -e "$home_tilde"
        return
    elif [[ "$PWD" == "/" ]]; then
        echo -e "$root_slash"
        return
    fi
    
    local display_path="${PWD/#$HOME/\~}"
    local result=""
    local accumulated_path=""
    
    local -a parts
    IFS='/' read -ra parts <<< "$display_path"
    
    for i in "${!parts[@]}"; do
        local part="${parts[$i]}"
        [[ -z "$part" ]] && continue
        
        if [[ "$i" -eq 0 && "${parts[0]}" == "~" ]]; then
            accumulated_path="$HOME"
            result+="${home_tilde}/"
            continue
        else
            accumulated_path+="/${part}"
        fi
        
        local color="$dir_color"
        if [[ -L "$accumulated_path" ]]; then
            color="$link_color"
        elif [[ ! -e "$accumulated_path" ]]; then
            color="$error_color"
        fi
        
        result+="${color}${part}\033[m/"
    done
    
    echo -e "${result%/}"
}

# =============================================================================
# Git分支检测函数
# =============================================================================

__git_branch() {
    local branch
    branch=$(git rev-parse --short HEAD 2>/dev/null) || return 0    
    local branch_name
    branch_name=$(git symbolic-ref --short HEAD 2>/dev/null) || branch_name="$branch"
    
    if [[ -n "$branch_name" ]]; then
        printf " \033[1;31m[\033[m%s\033[1;31m]\033[m" "$branch_name"
    fi
}

# =============================================================================
# Tmux会话管理器
# =============================================================================

tmuxmgr() {
    if ! command -v tmux &>/dev/null; then
        echo "❌ 错误: tmux 未安装" >&2
        return 1
    fi
    
    if ! command -v fzf &>/dev/null; then
        echo "❌ 错误: fzf 未安装" >&2
        return 1
    fi
    
    if [[ -n "$TMUX" ]]; then
        echo "⚠️ 已在 tmux 会话中" >&2
        return 1
    fi
    
    while true; do
        local action
        action=$(printf "🔗 进入会话\n➕ 创建新会话\n🗑️ 删除会话\n❌ 退出" | fzf --height=40% --border --prompt="Tmux Manager > " --header="按 ESC 取消")
        
        if [[ -z "$action" ]]; then
            break
        fi
        
        case "$action" in
            "🔗 进入会话")
                local sessions
                sessions=$(tmux ls 2>/dev/null | cut -d: -f1)
                
                if [[ -z "$sessions" ]]; then
                    echo "📭 没有活跃的 tmux 会话" >&2
                    read -rp "按任意键继续..." -n 1 -s
                    continue
                fi
                
                local target_session
                target_session=$(echo "$sessions" | fzf --prompt="选择要进入的会话 > " --header="按 ESC 返回")
                
                if [[ -n "$target_session" ]]; then
                    tmux attach-session -t "$target_session"
                fi
                ;;
                
            "➕ 创建新会话")
                read -rp "输入会话名称: " session_name
                
                if [[ -z "$session_name" ]]; then
                    echo "❌ 会话名称不能为空" >&2
                    read -rp "按任意键继续..." -n 1 -s
                    continue
                fi
                
                if tmux has-session -t="$session_name" 2>/dev/null; then
                    echo "⚠️ 会话 '$session_name' 已存在" >&2
                    read -rp "按任意键继续..." -n 1 -s
                else
                    tmux new-session -d -s "$session_name"
                    echo "✅ 已创建并连接到会话 '$session_name'" >&2
                    tmux attach-session -t "$session_name"
                fi
                ;;
                
            "🗑️ 删除会话")
                local sessions
                sessions=$(tmux ls 2>/dev/null | cut -d: -f1)
                
                if [[ -z "$sessions" ]]; then
                    echo "📭 没有活跃的 tmux 会话" >&2
                    read -rp "按任意键继续..." -n 1 -s
                    continue
                fi
                
                local target_session
                target_session=$(echo "$sessions" | fzf --prompt="选择要删除的会话 > " --header="按 ESC 返回")
                
                if [[ -n "$target_session" ]]; then
                    tmux kill-session -t "$target_session"
                    echo "✅ 已删除会话 '$target_session'" >&2
                    read -rp "按任意键继续..." -n 1 -s
                fi
                ;;
                
            "❌ 退出")
                break
                ;;
                
            *)
                break
                ;;
        esac
    done
}

# =============================================================================
# 提示符配置
# =============================================================================

__set_prompt() {
    local exit_code=$?
    
    local full_time
    full_time=$(date +%T 2>/dev/null) || full_time="??:??:??"
    local time1="${full_time%:*}"
    local time2="${full_time##*:}"
    
    local user_color="\[\033[1;34m\]"
    [[ $UID -eq 0 ]] && user_color="\[\033[1;31m\]\[\033[4m\]\[\033[5m\]"
    local user_host="${user_color}$(whoami)\[\033[m\]"
    
    local smart_path
    smart_path="$(__smart_pwd)"
    
    local git_info
    git_info="$(__git_branch)"
    
    local status_color="\[\033[1;32m\]"
    local status_text=""
    if [[ $exit_code -ne 0 ]]; then
        status_color="\[\033[1;31m\]"
        status_text="${exit_code}"
    fi
    
    PS1="\[\033[m\]┌─\[\033[1;31m\][\[\033[m\]$0-$$ ${time1}\[\033[25m\]:\[\033[m\]${time2} ${user_host}\[\033[1;31m\]@\[\033[34m\]\h ${smart_path}\[\033[1;31m\]]\[\033[m\]${git_info}
└─${status_color}${status_text}\$>>_\[\033[m\] "
    
    PS2='\[\033[1;33m\][Line $LINENO]>\[\033[m\]'
    PS3='\[\033[1;35m\][[$0]Select > \[\033[m\]'
    PS4='\[\033[1;35m\][[$0] Line $LINENO:> \[\033[m\]'
}

PROMPT_COMMAND='__set_prompt'

# =============================================================================
# 文件操作别名
# =============================================================================

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
alias diff='diff --color=auto'

# =============================================================================
# 导航别名
# =============================================================================

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias cdroot='cd /'
alias home='cd ~'
alias config='cd ~/.config'
alias cache='cd ~/.cache'
alias doc='cd ~/Documents 2>/dev/null || cd ~'
alias down='cd ~/Downloads 2>/dev/null || cd ~'

# =============================================================================
# 系统管理别名
# =============================================================================

alias sysenable='sudo systemctl enable --now'
alias sysdisable='sudo systemctl disable --now'
alias sysstart='sudo systemctl start'
alias sysrestart='sudo systemctl restart'
alias sysstop='sudo systemctl stop'
alias sysstatus='sudo systemctl status'
alias boottime='systemd-analyze 2>/dev/null || echo "systemd-analyze not available"'

# =============================================================================
# Git别名
# =============================================================================

alias g='git'
alias ginit='git init'
alias gclone='git clone --recursive --depth=1'
alias gadd='git add'
alias gcommit='git commit'
alias gpush='git push'
alias gpull='git pull'
alias gfetch='git fetch'
alias gmerge='git merge'
alias grebase='git rebase'
alias gstatus='git status'
alias gbranch='git branch'
alias gcheckout='git checkout'
alias glog='git log'
alias gloggraph='git log --graph --oneline --all'
alias gdiff='git diff'
alias gdiffstaged='git diff --staged'
alias gupdate='git add . && git commit -m "fix bugs and add new features"'
alias pushremote='git add . && git commit -m "fix bugs and add new features" && git pull origin master && git push origin master'
alias gc1='git clone --recursive --depth=1'
alias gnewbranch='git checkout -b'
alias gswitch='git switch'
alias gsync='git pull origin'
alias gsyncrebase='git pull --rebase origin'
alias greset='git reset --hard'
alias grestore='git restore'
alias grestorestaged='git restore --staged'
alias gclean='git clean -fd'
alias gtag='git tag'
alias gstash='git stash'
alias gstashpop='git stash pop'
alias gstashlist='git stash list'
alias gremote='git remote'
alias gremoteadd='git remote add'
alias gremoteurl='git remote set-url'
alias gprune='git remote prune origin'

gwhatchange() {
    git log --oneline | head -20
    read -rp "📝 输入哈希值查看文件: " hash
    if [[ -n "$hash" ]]; then
        git show "$hash"
    fi
}

# =============================================================================
# Docker别名和函数
# =============================================================================

if command -v docker &>/dev/null; then
    alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}\t{{.Image}}"'
    alias dpsa='docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}\t{{.Image}}"'
    alias dex='docker exec -it'
    alias dlogs='docker logs -f --tail 100'
    alias dstart='docker start'
    alias dstop='docker stop'
    alias drestart='docker restart'
    alias dkill='docker kill'
    alias drm='docker rm -f'
    alias drun='docker run -it --rm'
    alias dimages='docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.ID}}"'
    alias drmi='docker rmi -f'
    alias dbuild='docker build --no-cache -t'
    alias dpull='docker pull'
    
    if command -v docker-compose &>/dev/null; then
        COMPOSE_CMD="docker-compose"
    else
        COMPOSE_CMD="docker compose"
    fi
    
    alias dcup="$COMPOSE_CMD up -d"
    alias dcdown="$COMPOSE_CMD down"
    alias dcbuild="$COMPOSE_CMD build --no-cache"
    alias dcrestart="$COMPOSE_CMD restart"

    dtop() {
        if ! docker ps -q 2>/dev/null | grep -q .; then
            echo "🚫 没有运行中的容器"
            return 1
        fi
        docker stats --no-stream --format "table {{.Name}}\t{{.MemPerc}}\t{{.MemUsage}}\t{{.CPUPerc}}" | \
        sort -k2 -hr | head -21
    }
    
    dip() {
        if [[ $# -eq 0 ]]; then
            docker ps --format '{{.Names}}' | while read -r container; do
                local ip
                ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}}' "$container" 2>/dev/null)
                if [[ -n "$ip" ]]; then
                    printf "%-30s %s\n" "$container" "$ip"
                fi
            done
        else
            for container in "$@"; do
                local ip
                ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$container" 2>/dev/null)
                if [[ -n "$ip" ]]; then
                    echo "🌐 $ip"
                else
                    echo "❌ 容器 '$container' 不存在" >&2
                    return 1
                fi
            done
        fi
    }
    
    denter() {
        if [[ $# -eq 0 ]]; then
            echo "📝 Usage: denter <container>"
            return 1
        fi
        
        local container="$1"
        
        if ! docker ps --format '{{.Names}}' | grep -qx "$container"; then
            if docker ps -a --format '{{.Names}}' | grep -qx "$container"; then
                docker start "$container"
            else
                echo "❌ 容器不存在" >&2
                return 1
            fi
        fi
        
        if docker exec "$container" test -f /bin/bash 2>/dev/null; then
            docker exec -it "$container" bash
        elif docker exec "$container" test -f /bin/sh 2>/dev/null; then
            docker exec -it "$container" sh
        else
            echo "❌ 未找到 shell" >&2
            return 1
        fi
    }
    
    dcp() {
        if [[ $# -ne 2 ]]; then
            echo "📝 Usage: dcp <src> <dst>"
            return 1
        fi
        docker cp "$1" "$2"
    }
    
    drestore() {
        local running
        running=$(docker ps -q 2>/dev/null)
        [[ -n "$running" ]] && docker stop $running 2>/dev/null
        
        local all
        all=$(docker ps -aq 2>/dev/null)
        [[ -n "$all" ]] && docker rm -f $all 2>/dev/null
        
        local volumes
        volumes=$(docker volume ls -q 2>/dev/null)
        [[ -n "$volumes" ]] && docker volume rm -f $volumes 2>/dev/null
        
        local images
        images=$(docker images -q 2>/dev/null)
        [[ -n "$images" ]] && docker rmi -f $images 2>/dev/null
        
        local networks
        networks=$(docker network ls -q -f type=custom 2>/dev/null)
        [[ -n "$networks" ]] && docker network rm $networks 2>/dev/null
        
        docker builder prune -af 2>/dev/null
        docker system prune -af --volumes 2>/dev/null
        
        echo "🔄 Docker 已重置"
    }

    dvol() {
        if [[ $# -lt 3 ]]; then
            echo "📝 Usage: dvol <volume-name> <container-path> <image> [args...]"
            echo "💡 Example: dvol my-data /app/data nginx"
            return 1
        fi
        
        local vol="$1"
        local mount="$2"
        local image="$3"
        shift 3
        local rest=("$@")
        
        if ! docker volume inspect "$vol" >/dev/null 2>&1; then
            echo "📦 Creating volume '$vol'..."
            docker volume create "$vol"
        fi
        
        echo "🚀 Running $image with $vol → $mount"
        docker run -v "$vol:$mount" "${rest[@]}" "$image"
    }

    dvollist() {
        if ! command -v docker &>/dev/null; then
            echo "❌ Docker not installed" >&2
            return 1
        fi
        
        if ! docker info >/dev/null 2>&1; then
            echo "❌ Docker daemon not running" >&2
            return 1
        fi

        local is_first=1
        
        while IFS= read -r vol; do
            local mountpoint
            mountpoint=$(docker volume inspect --format '{{.Mountpoint}}' "$vol" 2>/dev/null)
            
            if [[ $is_first -eq 0 ]]; then
                echo ""
            fi
            is_first=0
            
            echo "📦 $vol"
            echo "   🖥️  Host: $mountpoint"
            
            local used=0
            while IFS= read -r cid; do
                local cname
                cname=$(docker inspect --format '{{.Name}}' "$cid" 2>/dev/null | sed 's/^\///')
                
                local mounts
                mounts=$(docker inspect --format '{{range .Mounts}}{{if eq .Type "volume"}}{{.Name}}|{{.Destination}}{{println}}{{end}}{{end}}' "$cid" 2>/dev/null)
                
                while IFS= read -r mount_info; do
                    if [[ -n "$mount_info" ]]; then
                        local m_vol="${mount_info%%|*}"
                        local m_dest="${mount_info##*|}"
                        
                        if [[ "$m_vol" == "$vol" ]]; then
                            used=1
                            echo "   └── 🐳 $cname → $m_dest"
                        fi
                    fi
                done <<< "$mounts"
            done < <(docker ps -aq 2>/dev/null)
            
            if [[ $used -eq 0 ]]; then
                echo "   └── ⚪ (not mounted by any container)"
            fi
        done < <(docker volume ls -q 2>/dev/null)
        
        if [[ $is_first -eq 1 ]]; then
            echo "📭 No volumes found"
        fi
    }
    
fi


# =============================================================================
# 常用工具别名
# =============================================================================

alias sudo='sudo '
alias _='sudo'
alias sus='sudo -s'
alias uncd='cd -'


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

topcpu() {
    if command -v ps &>/dev/null; then
        ps aux --sort=-%cpu 2>/dev/null | head -11 || \
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

alias ducks='du -cksh * 2>/dev/null | sort -hr | head'
alias dusort='du -sh * 2>/dev/null | sort -hr'
alias diskinfo='df -h 2>/dev/null && echo && lsblk 2>/dev/null'

alias ports='ss -tlnp 2>/dev/null || netstat -tlnp 2>/dev/null'

alias untar='tar -xzvf'
alias mktbz='tar -cjvf'
alias untbz='tar -xjvf'

alias chmodx='chmod +x'
alias chownme='sudo chown -R $USER:$USER'

alias flushdns='sudo resolvectl flush-caches 2>/dev/null || sudo systemd-resolve --flush-caches 2>/dev/null || echo "DNS flush not supported"'

alias py='python3'

# =============================================================================
# 补全配置
# =============================================================================

if ! shopt -oq posix; then
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

# =============================================================================
# 按键绑定
# =============================================================================

bind 'set show-all-if-ambiguous on'
bind 'set menu-complete-display-prefix on'
bind '"\t": menu-complete'
bind '"\e[Z": menu-complete-backward'
bind 'set colored-stats on'
bind 'set colored-completion-prefix on'

bind -x '"\C-x\C-t": tmuxmgr' 2>/dev/null || true

bind '"\C-r": reverse-search-history'


# =============================================================================
# 用户自定义配置加载
# =============================================================================

[[ -f "${HOME}/.bash_aliases" ]] && source "${HOME}/.bash_aliases"
[[ -f "${HOME}/.bash_functions" ]] && source "${HOME}/.bash_functions"

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


