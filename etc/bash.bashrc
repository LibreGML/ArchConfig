#!/bin/bash

# =============================================================================
# 🌟 Bash 配置文件
# ✨ 支持 RedHat / Debian / Arch Linux 全系列发行版
# =============================================================================

export TERM=xterm

bind '"\t": menu-complete'
bind '"\e[Z": menu-complete-backward'

[[ $- != *i* ]] && return

# =============================================================================
# 🏠 环境检测与初始化 - 人家会自动识别你的系统哦～
# =============================================================================

if [[ -n "$TERMUX_VERSION" ]]; then
    SYSROOT="/data/data/com.termux/files"
elif [[ -d "/data/data/com.termux" ]]; then
    SYSROOT="/data/data/com.termux/files"
else
    SYSROOT=""
fi

_detect_distro() {
    if [[ -f /etc/redhat-release ]]; then
        echo "redhat"
    elif [[ -f /etc/debian_version ]]; then
        echo "debian"
    elif [[ -f /etc/arch-release ]]; then
        echo "arch"
    else
        echo "unknown"
    fi
}

DISTRO_TYPE=$(_detect_distro)

# =============================================================================
# ⚙️ Shell 选项与历史记录 - 让人家变得更聪明吧～
# =============================================================================

HISTFILE="${HOME}/.bash_history"
HISTSIZE=100000
HISTFILESIZE=200000
HISTCONTROL="ignorespace:ignoredups"

shopt -s histappend
shopt -s autocd
shopt -s cdspell
shopt -s histverify
shopt -s checkwinsize
shopt -s globstar
shopt -s cdable_vars
shopt -s extglob
shopt -s dirspell
shopt -s dotglob
shopt -s no_empty_cmd_completion

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export LESS="-R"

# =============================================================================
# 🔍 智能文件查找函数 - 帮主人快速找到想要的东西～
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
            echo "😿 哎呀～参数太多啦！用法: $cmd_name [路径] 模式" >&2
            return 1
            ;;
    esac
    
    if [[ "$search_path" == "~/"* || "$search_path" == "~" ]]; then
        search_path="${search_path/#\~/$HOME}"
    fi
    
    if [[ ! -e "$search_path" ]]; then
        echo "😢 呜呜～路径不存在呢: $search_path" >&2
        return 2
    fi
    
    if [[ ! -d "$search_path" ]]; then
        echo "🤔 咦？这不是目录哦: $search_path" >&2
        return 2
    fi
    
    if [[ -z "$pattern" ]]; then
        echo "💭 人家需要搜索模式嘛～不能为空哦" >&2
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
    
    echo "🔍 正在查找文件: $pattern ..."
    find "$search_path" -type f -iname "*$pattern*" 2>/dev/null | head -1000
}

finddir() {
    local parsed
    parsed=$(_parse_find_args finddir "$@") || return $?
    
    local search_path
    search_path=$(echo "$parsed" | head -1)
    local pattern
    pattern=$(echo "$parsed" | tail -1)
    
    echo "📁 正在查找目录: $pattern ..."
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
        echo "⚡ 使用 ripgrep 快速搜索: $pattern ..."
        rg --smart-case --hidden --no-ignore \
           --max-depth 8 --max-filesize 10M \
           --max-columns=150 \
           --glob='!{.git,.cargo,.lingma,.local,.java,.svn,.hg,node_modules,build,target,dist,.cache,__pycache__,.DS_Store}' \
           -- "$pattern" "$search_path" 2>/dev/null | head -500
    else
        echo "😅 抱歉呢～请先安装 ripgrep (rg) 才能使用这个功能哦" >&2
        echo "💡 安装方法:"
        echo "   sudo pacman -S ripgrep"
        return 127
    fi
}



# =============================================================================
# 🧹 空目录清理函数 - 帮主人打扫干净的房间～
# =============================================================================

rmemptydir() {
    local target="${1:-.}"
    
    if [[ ! -e "$target" ]]; then
        echo "😢 路径不存在呢: $target" >&2
        return 1
    fi
    
    if [[ ! -d "$target" ]]; then
        echo "🤔 这不是目录哦: $target" >&2
        return 1
    fi
    
    if [[ -L "$target" ]]; then
        echo "🛡️ 为了安全起见，人家不会操作符号链接的啦～" >&2
        return 1
    fi
    
    local abs_target
    abs_target=$(realpath "$target")
    
    local protected_dirs=("/" "/home" "/root" "/etc" "/var" "/usr" "/bin" "/sbin" "/lib" "/lib64" "/tmp" "/dev" "/proc" "/sys")
    for protected in "${protected_dirs[@]}"; do
        if [[ "$abs_target" == "$protected" ]]; then
            echo "🛡️ 危险！这是系统关键目录，人家不敢删啦～" >&2
            return 1
        fi
    done
    
    echo "🧹 开始清理空目录: $target"
    
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
                        echo "🗑️ 已删除: $display"
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
        echo "⚠️ 达到最大迭代次数，可能需要手动检查哦～" >&2
    fi
    
    if [[ $total_count -eq 0 ]]; then
        echo "✨ 太棒啦～没有发现空目录呢！"
    else
        echo "✅ 完成！共删除 $total_count 个空目录（迭代 $iteration 轮）～人家厉害吧～"
    fi
}

# =============================================================================
# 🌐 HTTP 请求封装函数 - 帮主人上网获取信息～
# =============================================================================

get() {

    # get 'https://uapis.cn/api/v1/convert/unixtime' 'time=2023-10-27 10:30:00' "

    local url="$1"
    
    if [[ ! "$url" =~ ^https?:// ]]; then
        echo "😿 URL 必须以 http:// 或 https:// 开头哦～" >&2
        return 1
    fi
    
    if ! command -v curl &>/dev/null; then
        echo "😅 请先安装 curl 才能使用这个功能呢～" >&2
        case "$DISTRO_TYPE" in
            redhat) echo "   sudo dnf install curl" ;;
            debian) echo "   sudo apt install curl" ;;
            arch)   echo "   sudo pacman -S curl" ;;
        esac
        return 127
    fi
    
    echo "🌐 正在请求: $url ..."
    
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
            echo "⚠️ 跳过格式错误的参数: '$param'" >&2
        fi
    done
    
    cmd+=("$url")
    
    local response
    response=$( "${cmd[@]}" 2>&1 ) || {
        echo "❌ 请求失败了呢～可能是网络问题或者服务器出错啦" >&2
        return 1
    }
    
    local lines_array=()
    while IFS= read -r line; do
        lines_array+=("$line")
    done <<< "$response"
    
    local lines_count=${#lines_array[@]}
    if [[ $lines_count -lt 2 ]]; then
        echo "😵 服务器返回了奇怪的响应呢～" >&2
        return 1
    fi
    
    local status_code="${lines_array[$((lines_count-1))]}"
    local body_lines=("${lines_array[@]:0:$((lines_count-1))}")
    
    if [[ ! "$status_code" =~ ^2[0-9][0-9]$ ]]; then
        echo "🔴 HTTP $status_code - 请求出问题啦～" >&2
        if [[ ${#body_lines[@]} -gt 0 ]]; then
            printf '%s\n' "${body_lines[@]}" >&2
        fi
        return 1
    fi
    
    if [[ ${#body_lines[@]} -eq 0 ]]; then
        echo "✨ 请求成功！不过没有返回内容呢～"
        return 0
    fi
    
    local body_str
    body_str=$(printf '%s\n' "${body_lines[@]}")
    
    if command -v jq >/dev/null 2>&1; then
        echo "$body_str" | jq -e . 2>/dev/null || echo "$body_str"
    else
        echo "$body_str"
    fi
    
    echo "✅ 请求成功啦～"
}

post() {
    
    #  post 'https://uapis.cn/api/v1/search/aggregate'  '{"query":"archlinux","fetch_full":false}'  "

    local url="$1"
    local json="$2"
    
    if [[ -z "$url" ]]; then
        echo "😿 URL 不能为空哦～" >&2
        return 1
    fi
    
    if [[ -z "$json" ]]; then
        echo "😿 JSON 数据不能为空呢～" >&2
        return 1
    fi
    
    if ! command -v curl &>/dev/null; then
        echo "😅 请先安装 curl 呢～" >&2
        return 127
    fi
    
    echo "📤 正在发送 POST 请求: $url ..."
    
    local response
    response=$(curl -s -X POST \
        -H "Content-Type: application/json" \
        -d "$json" \
        "$url")
    
    if command -v jq &>/dev/null; then
        echo "$response" | jq . 2>/dev/null || echo "$response"
    else
        echo "$response"
    fi
    
    echo "✅ POST 请求完成～"
}

# =============================================================================
# 🛠️ 开发工具函数 - 主人编程的好帮手～
# =============================================================================

genkey() {
    if ! command -v openssl &>/dev/null; then
        echo "😅 请先安装 openssl 呢～" >&2
        case "$DISTRO_TYPE" in
            redhat) echo "   sudo dnf install openssl" ;;
            debian) echo "   sudo apt install openssl" ;;
            arch)   echo "   sudo pacman -S openssl" ;;
        esac
        return 127
    fi
    
    echo "🔑 正在生成随机密钥..."
    openssl rand -base64 32 | tr -d '\n=' | tr '/+' '_-'
    echo
    echo "✨ 密钥生成完成～记得好好保存哦～"
}

mine() {
    if [[ $# -eq 0 ]]; then
        echo "😿 请指定要修改所有权的文件或目录呢～" >&2
        echo "💡 用法: mine file1 file2 dir1 ..."
        return 1
    fi
    
    local user
    user=$(whoami)
    
    echo "🔧 正在修改所有权为 $user:$user ..."
    
    for item in "$@"; do
        if [[ ! -e "$item" ]]; then
            echo "⚠️ 跳过不存在的: $item"
            continue
        fi
        
        if [[ -d "$item" ]]; then
            sudo chown -R "$user:$user" "$item" 2>/dev/null && \
                echo "✅ $item/* → $user:$user" || \
                echo "❌ 修改失败: $item（可能需要权限）"
        else
            sudo chown "$user:$user" "$item" 2>/dev/null && \
                echo "✅ $item → $user:$user" || \
                echo "❌ 修改失败: $item（可能需要权限）"
        fi
    done
    
    echo "✨ 所有权修改完成～"
}

# =============================================================================
# ✏️ 批量重命名函数 - 帮主人整理文件名～
# =============================================================================

batchrename() {
    if [[ $# -lt 3 ]]; then
        echo "😿 参数不足呢～" >&2
        echo "💡 用法: batchrename '正则表达式' '替换文本' 文件1 文件2 ..."
        return 1
    fi
    
    local regex="$1"
    local replacement="$2"
    shift 2
    local files=("$@")
    
    if [[ -z "$regex" ]]; then
        echo "😿 正则表达式不能为空哦～" >&2
        return 1
    fi
    
    echo "✏️ 开始批量重命名..."
    
    for file in "${files[@]}"; do
        if [[ ! -e "$file" ]]; then
            echo "⚠️ 跳过不存在的: $file"
            continue
        fi
        
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
            echo "⚠️ 跳过不安全的路径转换: $file -> $new_name" >&2
            continue
        fi
        
        mv -i "$file" "$new_name" && \
            echo "📝 已重命名: $file -> $new_name" || \
            echo "❌ 重命名失败: $file"
    done
    
    echo "✨ 批量重命名完成～"
}

multirename() {
    if [[ $# -eq 0 ]]; then
        echo "😿 请指定要重命名的文件呢～" >&2
        echo "💡 用法: multirename file1 file2 ..."
        return 1
    fi
    
    echo "✏️ 进入交互重命名模式～"
    
    for file in "$@"; do
        if [[ ! -e "$file" ]]; then
            echo "⚠️ 跳过不存在的: $file"
            continue
        fi
        
        echo "📄 当前文件: $file"
        read -rp "💭 新文件名 (留空跳过，输入 'q' 退出): " new_name
        
        if [[ -z "$new_name" ]]; then
            echo "⏭️ 跳过: $file"
        elif [[ "$new_name" == "q" ]]; then
            echo "🚪 退出重命名～"
            return
        else
            mv "$file" "$new_name" && \
                echo "✅ 已重命名: $file -> $new_name" || \
                echo "❌ 重命名失败: $file"
        fi
        echo "---"
    done
    
    echo "✨ 交互重命名完成～"
}

# =============================================================================
# 🔄 文本替换函数 - 帮主人快速修改文件内容～
# =============================================================================

replacetext() {
    if [[ $# -ne 3 ]]; then
        echo "😿 参数不对呢～" >&2
        echo "💡 用法: replacetext '文件模式' '旧字符串' '新字符串'"
        return 1
    fi
    
    local file_pattern="$1"
    local old_string="$2"
    local new_string="$3"
    
    if [[ -z "$old_string" ]]; then
        echo "😿 旧字符串不能为空哦～" >&2
        return 1
    fi
    
    if ! command -v perl &>/dev/null; then
        echo "😅 请先安装 perl 呢～" >&2
        case "$DISTRO_TYPE" in
            redhat) echo "   sudo dnf install perl" ;;
            debian) echo "   sudo apt install perl" ;;
            arch)   echo "   sudo pacman -S perl" ;;
        esac
        return 127
    fi
    
    echo "🔄 开始替换: '$old_string' -> '$new_string' （匹配: $file_pattern）"
    
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
    
    echo "✅ 替换完成～人家厉不厉害～"
}

# =============================================================================
# 📦 压缩与目录工具 - 帮主人打包和创建目录～
# =============================================================================

mktar() {
    if [[ $# -eq 0 ]]; then
        echo "😿 请指定要压缩的文件或目录呢～" >&2
        echo "💡 用法: mktar file1 dir1 ..."
        return 1
    fi
    
    for target in "$@"; do
        if [[ ! -e "$target" ]]; then
            echo "⚠️ 跳过不存在的: '$target'"
            continue
        fi
        
        local base_name
        base_name=$(basename "$target")
        local tar_name="$base_name.tar"
        
        if [[ -e "$tar_name" ]]; then
            read -rp "⚠️ '$tar_name' 已存在，要覆盖吗？(y/N): " confirm
            if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
                echo "⏭️ 跳过: $target"
                continue
            fi
        fi
        
        echo "📦 正在创建: $tar_name"
        if tar -cvf "$tar_name" "$target" 2>/dev/null; then
            echo "✅ 创建成功: $tar_name"
        else
            echo "❌ 创建失败: $tar_name"
        fi
    done
    
    echo "✨ 压缩任务完成～"
}

mkcd() {
    if [[ $# -ne 1 ]]; then
        echo "😿 请指定目录名称呢～" >&2
        echo "💡 用法: mkcd 'My Directory'"
        return 1
    fi
    
    echo "📁 正在创建目录: $1"
    if mkdir -p "$1" && cd "$1"; then
        echo "✅ 目录创建成功并已进入～ ($(pwd))"
    else
        echo "❌ 创建目录失败了呢: $1" >&2
        return 1
    fi
}

# =============================================================================
# 🎨 智能路径显示 - 让路径变得漂漂亮亮～
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
# 🌿 Git 版本控制 - 主人的代码管理小助手～
# =============================================================================

if command -v git &>/dev/null; then

    alias g='git'
    alias ginit='git init'
    alias gclone='git clone'
    alias gadd='git add'
    alias gcommit='git commit'
    alias gamend='git commit --amend -m'
    alias gpush='git push'
    alias gpull='git pull'
    alias gfetch='git fetch'
    alias gmerge='git merge'
    alias grebase='git rebase'   
    alias gstatus='git status'
    alias gbranch='git branch'
    alias gcheckout='git checkout'
    alias gswitch='git switch'
    alias glog='git log'
    alias gloggraph='git log --graph --oneline --all'
    alias gdiff='git diff'
    alias gdiffstaged='git diff --staged'
    alias gupdate='git add . && git commit -m "fix bugs and add new features"'
    alias gc1='git clone --recursive --depth=1'
    alias greset='git reset'
    alias gresethard='git reset --hard HEAD~1'
    alias gresetsoft='git reset --soft HEAD~1' 
    alias grestore='git restore'
    alias grestorestaged='git restore --staged'
    alias gclean='git clean -fd'
    alias gtag='git tag'
    alias gstash='git stash'
    alias gstashpop='git stash pop'
    alias gstashlist='git stash list'  
    alias gremote='git remote'
    alias gremoteadd='git remote add'
    alias gremoteseturl='git remote set-url'

    
    gwhatchange() {
        echo "📋 最近 20 条提交记录:"
        git log --oneline | head -20
        read -rp "💭 输入哈希值查看详细变更: " hash
        if [[ -n "$hash" ]]; then
            echo "🔍 显示提交: $hash"
            git show "$hash"
        else
            echo "⚠️ 未输入哈希值～"
        fi
    }
    
    pushremote() {
        local branch
        branch=$(git symbolic-ref --short HEAD 2>/dev/null) || branch="master"
        git add . && git commit -m "fix bugs and add new features" && git pull origin "$branch" && git push origin "$branch"
    }
    
fi

# =============================================================================
# 🪟 Tmux 会话管理器 - 帮主人管理多个工作空间～
# =============================================================================

tmuxmgr() {
    if ! command -v tmux &>/dev/null; then
        echo "😅 请先安装 tmux 呢～" >&2
        case "$DISTRO_TYPE" in
            redhat) echo "   sudo dnf install tmux" ;;
            debian) echo "   sudo apt install tmux" ;;
            arch)   echo "   sudo pacman -S tmux" ;;
        esac
        return 1
    fi
    
    if ! command -v fzf &>/dev/null; then
        echo "😅 请先安装 fzf 呢～" >&2
        case "$DISTRO_TYPE" in
            redhat) echo "   sudo dnf install fzf" ;;
            debian) echo "   sudo apt install fzf" ;;
            arch)   echo "   sudo pacman -S fzf" ;;
        esac
        return 1
    fi
    
    if [[ -n "$TMUX" ]]; then
        echo "⚠️ 人家已经在 tmux 会话中啦～" >&2
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
                    echo "📭 没有活跃的 tmux 会话呢～" >&2
                    read -rp "按任意键继续..." -n 1 -s
                    continue
                fi
                
                local target_session
                target_session=$(echo "$sessions" | fzf --prompt="选择要进入的会话 > " --header="按 ESC 返回")
                
                if [[ -n "$target_session" ]]; then
                    echo "✨ 正在进入会话: $target_session"
                    tmux attach-session -t "$target_session"
                fi
                ;;
                
            "➕ 创建新会话")
                read -rp "💭 输入会话名称: " session_name
                
                if [[ -z "$session_name" ]]; then
                    echo "😿 会话名称不能为空哦～" >&2
                    read -rp "按任意键继续..." -n 1 -s
                    continue
                fi
                
                if tmux has-session -t="$session_name" 2>/dev/null; then
                    echo "⚠️ 会话 '$session_name' 已经存在啦～" >&2
                    read -rp "按任意键继续..." -n 1 -s
                else
                    tmux new-session -d -s "$session_name"
                    echo "✅ 已创建并连接到会话 '$session_name' ～" >&2
                    tmux attach-session -t "$session_name"
                fi
                ;;
                
            "🗑️ 删除会话")
                local sessions
                sessions=$(tmux ls 2>/dev/null | cut -d: -f1)
                
                if [[ -z "$sessions" ]]; then
                    echo "📭 没有活跃的 tmux 会话呢～" >&2
                    read -rp "按任意键继续..." -n 1 -s
                    continue
                fi
                
                local target_session
                target_session=$(echo "$sessions" | fzf --prompt="选择要删除的会话 > " --header="按 ESC 返回")
                
                if [[ -n "$target_session" ]]; then
                    tmux kill-session -t "$target_session"
                    echo "✅ 已删除会话 '$target_session' ～" >&2
                    read -rp "按任意键继续..." -n 1 -s
                fi
                ;;
                
            "❌ 退出")
                echo "👋 拜拜～"
                break
                ;;
                
            *)
                break
                ;;
        esac
    done
}

# =============================================================================
# 💻 提示符配置 - 让命令行界面变得漂漂亮亮～
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



__set_prompt() {
    local exit_code=$?
    
    local full_time
    full_time=$(date +%T 2>/dev/null) || full_time="??:??:??"
    local time1="${full_time%:*}"
    local time2="${full_time##*:}"
    
    local user_color="\[\033[1;31m\]\[\033[4m\]\[\033[5m\]"
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
# 📋 文件操作别名 - 让文件列表变得漂漂亮亮～
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
    alias sl='exa --icons'
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
# 🧭 快速导航别名 - 让主人快速跳转到想去的地方～
# =============================================================================

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias home='cd $HOME 2>/dev/null || cd ~'
alias cache='cd $HOME/.cache 2>/dev/null || cd ~'
alias config='cd $HOME/.config 2>/dev/null || cd ~'
alias localshare='cd $HOME/.local/share 2>/dev/null || cd ~'
alias localstate='cd $HOME/.local/state 2>/dev/null || cd ~'
alias docs='cd ~/Documents 2>/dev/null || cd ~'
alias downs='cd ~/Downloads 2>/dev/null || cd ~'


# =============================================================================
# ⚙️ 系统管理别名 - 帮主人管理系统服务～
# =============================================================================

if command -v systemctl &>/dev/null; then
    
    if [[ -f /etc/arch-release ]] && command -v mkinitcpio &>/dev/null; then
        alias mkinitcpio='sudo mkinitcpio'
    fi
    
    alias sc-start='sudo systemctl start'
    alias sc-stop='sudo systemctl stop'
    alias sc-restart='sudo systemctl restart'
    alias sc-reload='sudo systemctl reload'        
    alias sc-enable='sudo systemctl enable --now'
    alias sc-disable='sudo systemctl disable --now'
    alias sc-mask='sudo systemctl mask'
    alias sc-unmask='sudo systemctl unmask'        
    alias sc-status='sudo systemctl status'
    alias sc-failed='systemctl --failed'
    alias sc-cat='systemctl cat'        
    alias sc-ls='systemctl list-units --type=service'
    alias sc-lsfiles='systemctl list-unit-files --type=service'        
    alias sc-reloadall='sudo systemctl daemon-reload'        
    alias boottime='sudo systemd-analyze'
    
    alias sshd='sudo systemctl start sshd'
    alias dockerd='sudo systemctl start docker'
    alias mysqld='sudo systemctl start mariadb'
    alias tomcatd='sudo systemctl start tomcat10'
fi

# ==========================================
# 🗄️ MySQL 数据库管理 - 数据库连接和备份命令呀～
# ==========================================

if command -v mariadb >/dev/null 2>&1; then
   alias my='mariadb --defaults-extra-file=$HOME/.my.cnf'
   alias my-ls='mariadb --defaults-extra-file=$HOME/.my.cnf -e "SHOW DATABASES;"'
   alias my-tables='mariadb --defaults-extra-file=$HOME/.my.cnf -e "SHOW TABLES;"'
   alias my-conn='mariadb --defaults-extra-file=$HOME/.my.cnf -e "SHOW PROCESSLIST;"'
   alias my-vars='mariadb --defaults-extra-file=$HOME/.my.cnf -e "SHOW VARIABLES LIKE \"%max_connections%\";"'

   my-backup() {
       local db="$1"
       if [ -z "$db" ]; then
           echo "USAGE: my-backup <database_name>" >&2
           return 1
       fi
       local date=$(date +%F_%H%M%S)
       local out="${db}_${date}.sql.gz"
       mariadb-dump --defaults-extra-file=$HOME/.my.cnf --single-transaction --routines --triggers --events --quick --lock-tables=false "$db" | gzip > "$out"
       echo "$out"
   }

   my-backup-all() {
       local date=$(date +%F_%H%M%S)
       local out="all_databases_${date}.sql.gz"
       mariadb --defaults-extra-file=$HOME/.my.cnf -e "SHOW DATABASES;" -N -B | grep -v -E '^(information_schema|performance_schema|mysql|sys|mariadb)$' | xargs mariadb-dump --defaults-extra-file=$HOME/.my.cnf --single-transaction --routines --triggers --events --databases | gzip > "$out"
       echo "$out"
   }

   my-restore() {
       local file="$1"
       local db="$2"
       if [ -z "$file" ] || [ -z "$db" ]; then
           echo "USAGE: my-restore <backup.sql.gz> <database_name>" >&2
           return 1
       fi
       local confirm
       read -p "Type '$db' to confirm restore: " confirm
       if [ "$confirm" != "$db" ]; then
           echo "CANCELLED" >&2
           return 1
       fi
       if [[ "$file" == *.gz ]]; then
           gunzip < "$file" | mariadb --defaults-extra-file=$HOME/.my.cnf "$db"
       else
           mariadb --defaults-extra-file=$HOME/.my.cnf "$db" < "$file"
       fi
   }
fi



# =============================================================================
# 🐳 Docker 容器管理 - 主人的容器化小助手～
# =============================================================================

if command -v docker &>/dev/null; then
    alias dex='docker exec -it'
    alias dlogs='docker logs -f --tail 100'
    alias dstart='docker start'
    alias dstop='docker stop'
    alias drestart='docker restart'
    alias dkill='docker kill'
    alias drm='docker rm -f'
    alias drun='docker run -it --rm'    
    alias drmi='docker rmi -f'
    alias dbuild='docker build --no-cache -t'
    alias dpull='docker pull'
    
    
    dps() {
        docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}\t{{.Image}}"
    }
    
    dpsa() {
        docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}\t{{.Image}}"
    }
    
    dimages() {
        docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.ID}}"
    }
    
    
    if command -v docker-compose &>/dev/null; then
        COMPOSE_CMD="docker-compose"
    else
        COMPOSE_CMD="docker compose"
    fi
    
    dcup() {
        $COMPOSE_CMD up -d "$@"
    }
    
    dcdown() {
        $COMPOSE_CMD down "$@"
    }
    
    dcbuild() {
        $COMPOSE_CMD build --no-cache "$@"
    }
    
    dcrestart() {
        $COMPOSE_CMD restart "$@"
    }

    dtop() {
        if ! docker ps -q 2>/dev/null | grep -q .; then
            echo "🚫 没有运行中的容器呢～"
            return 1
        fi
        echo "📊 容器资源使用情况:"
        docker stats --no-stream --format "table {{.Name}}\t{{.MemPerc}}\t{{.MemUsage}}\t{{.CPUPerc}}" | \
        sort -k2 -hr | head -21
    }
    
    dip() {
        if [[ $# -eq 0 ]]; then
            echo "🌐 所有容器 IP 地址:"
            docker ps --format '{{.Names}}' | while read -r container; do
                local ip
                ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}}' "$container" 2>/dev/null)
                if [[ -n "$ip" ]]; then
                    printf "   %-30s %s\n" "$container" "$ip"
                fi
            done
        else
            for container in "$@"; do
                local ip
                ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$container" 2>/dev/null)
                if [[ -n "$ip" ]]; then
                    echo "🌐 $container: $ip"
                else
                    echo "❌ 容器 '$container' 不存在或没有 IP" >&2
                    return 1
                fi
            done
        fi
    }
    
    denter() {
        if [[ $# -eq 0 ]]; then
            echo "😿 请指定容器名称呢～" >&2
            echo "💡 用法: denter <container>"
            return 1
        fi
        
        local container="$1"
        
        if ! docker ps --format '{{.Names}}' | grep -qx "$container"; then
            if docker ps -a --format '{{.Names}}' | grep -qx "$container"; then
                echo "⚠️ 容器 '$container' 未运行，正在启动..."
                docker start "$container"
            else
                echo "❌ 容器 '$container' 不存在呢～" >&2
                return 1
            fi
        fi
        
        if docker exec "$container" test -f /bin/bash 2>/dev/null; then
            echo "✨ 正在进入容器: $container (bash)"
            docker exec -it "$container" bash
        elif docker exec "$container" test -f /bin/sh 2>/dev/null; then
            echo "✨ 正在进入容器: $container (sh)"
            docker exec -it "$container" sh
        else
            echo "❌ 容器中未找到 shell 呢～" >&2
            return 1
        fi
    }
    
    dcp() {
        if [[ $# -ne 2 ]]; then
            echo "😿 参数不对呢～" >&2
            echo "💡 用法: dcp <源路径> <目标路径>"
            return 1
        fi
        echo "📋 正在复制文件..."
        docker cp "$1" "$2" && echo "✅ 复制完成～" || echo "❌ 复制失败～"
    }
    
    drestore() {
        echo "⚠️ 警告：这将删除所有 Docker 资源！"
        read -rp "💭 确定要继续吗？(yes/no): " confirm
        if [[ "$confirm" != "yes" ]]; then
            echo "🚫 已取消操作～"
            return 0
        fi
        
        echo "🔄 正在停止所有容器..."
        local running
        running=$(docker ps -q 2>/dev/null)
        [[ -n "$running" ]] && docker stop $running 2>/dev/null
        
        echo "🗑️ 正在删除所有容器..."
        local all
        all=$(docker ps -aq 2>/dev/null)
        [[ -n "$all" ]] && docker rm -f $all 2>/dev/null
        
        echo "🗑️ 正在删除所有数据卷..."
        local volumes
        volumes=$(docker volume ls -q 2>/dev/null)
        [[ -n "$volumes" ]] && docker volume rm -f $volumes 2>/dev/null
        
        echo "🗑️ 正在删除所有镜像..."
        local images
        images=$(docker images -q 2>/dev/null)
        [[ -n "$images" ]] && docker rmi -f $images 2>/dev/null
        
        echo "🗑️ 正在删除自定义网络..."
        local networks
        networks=$(docker network ls -q -f type=custom 2>/dev/null)
        [[ -n "$networks" ]] && docker network rm $networks 2>/dev/null
        
        echo "🧹 清理构建缓存..."
        docker builder prune -af 2>/dev/null
        docker system prune -af --volumes 2>/dev/null
        
        echo "✅ Docker 环境已重置～像新的一样干净～"
    }

    
    dvol() {
        if [[ $# -lt 3 ]]; then
            echo "😿 参数不足呢～" >&2
            echo "💡 用法: dvol <volume-name> <container-path> <image> [args...]"
            echo "💡 示例: dvol my-data /app/data nginx"
            return 1
        fi
        
        local vol="$1"
        local mount="$2"
        local image="$3"
        shift 3
        local rest=("$@")
        
        if ! docker volume inspect "$vol" >/dev/null 2>&1; then
            echo "📦 正在创建数据卷: $vol"
            docker volume create "$vol"
        fi
        
        echo "🚀 运行 $image，挂载 $vol → $mount"
        docker run -v "$vol:$mount" "$image" "${rest[@]}"
    }
    

    dvollist() {
        if ! command -v docker &>/dev/null; then
            echo "❌ Docker 未安装呢～" >&2
            return 1
        fi
        
        if ! docker info >/dev/null 2>&1; then
            echo "❌ Docker 守护进程未运行呢～" >&2
            return 1
        fi

        local is_first=1
        
        echo "📦 Docker 数据卷列表:"
        echo ""
        
        while IFS= read -r vol; do
            local mountpoint
            mountpoint=$(docker volume inspect --format '{{.Mountpoint}}' "$vol" 2>/dev/null)
            
            if [[ $is_first -eq 0 ]]; then
                echo ""
            fi
            is_first=0
            
            echo "📦 $vol"
            echo "   🖥️  主机路径: $mountpoint"
            
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
                echo "   └── ⚪ 未被任何容器使用"
            fi
        done < <(docker volume ls -q 2>/dev/null)
        
        if [[ $is_first -eq 1 ]]; then
            echo "📭 没有找到数据卷呢～"
        fi
    }
    
fi


# =============================================================================
# 🛠️ 常用工具别名 - 主人的日常小工具～
# =============================================================================

alias _='sudo'
alias sus='sudo -s'
alias uncd='cd -'
alias sduo='sudo'


export ED=vim

if command -v fresh &>/dev/null; then
    ED=$(command -v fresh)
    alias e='fresh'
    alias vim='fresh'
    alias nvim='fresh'
    alias nano='fresh'
    alias micro='fresh'
elif command -v vim &>/dev/null; then
    ED=$(command -v vim)
    alias e='vim'
elif command -v vi &>/dev/null; then
    ED=$(command -v vi)
    alias e='vi'
elif command -v nano &>/dev/null; then
    ED=$(command -v nano)
    alias e='nano'
elif command -v micro &>/dev/null; then
    ED=$(command -v micro)
    alias e='micro'
fi

_edsys() {
    local file="$1"
    if [[ -z "$ED" ]] || ! command -v "$ED" &>/dev/null; then
        echo "Error: No editor available" >&2
        return 1
    fi
    
    if [[ -w "$file" ]]; then
        "$ED" "$file"
    else
        sudo -E "$ED" "$file"
    fi
}

bashrc()      { _edsys /etc/bash.bashrc; }
localeconf()  { _edsys /etc/locale.gen; }
systemconf()  { _edsys /etc/systemd/system.conf; }
journalconf() { _edsys /etc/systemd/journald.conf; }
grubconf()    { _edsys /etc/default/grub; }
makepkgconf() { _edsys /etc/makepkg.conf; }


topcpu() {
    ps -A -o %cpu,pid,user,comm | sort -nr | head -10
}

topmem() {
    ps -A -o %mem,pid,user,comm | sort -nr | head -10
}

portproc() {
  local input="$1"

  if [ -z "$input" ]; then
    echo "用法: portproc <端口号|进程名>"
    echo "示例:"
    echo "  portproc 8080      # 查找占用8080端口的进程"
    echo "  portproc nginx     # 查找nginx进程占用的端口"
    return 1
  fi

  if [[ "$input" =~ ^[0-9]+$ ]]; then
    echo "🔍 正在查询占用端口 $input 的进程..."
    sudo ss -tulnp | grep ":$input "
    if [ $? -ne 0 ]; then
      echo "未找到占用端口 $input 的进程。"
    fi
  else
    echo "🔍 正在查询进程 '$input' 占用的端口..."
    sudo lsof -i -P -n | grep "$input"
    if [ $? -ne 0 ]; then
      echo "未找到名为 '$input' 的进程的网络连接。"
    fi
  fi
}



alias python='python3'
alias py='python3'
alias h='history'
alias grubmk='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias libhelp='/lib/ld-linux-x86-64.so.2 --help'
alias btrfszip='sudo btrfs filesystem defragment -r -v -czstd /'
alias diskinfo='sudo fdisk -l && df -h && lsblk'
alias ducks='du -cksh * | sort -hr | head'  # 找出最大的文件/目录
alias dusort='du -sh * | sort -hr'
alias dush='du -sh'
alias ting='httping'
alias gateway='ip route show default | awk '\''{print $3}'\'''
alias stopvnc='pkill -9 wayvnc && killall -9 wayvnc'
alias startvnc='WLR_RDP_TX_CAPTURE_ALL_KEYS=1 wayvnc -v 0.0.0.0 5900'
alias x='extract'
alias chmodx='sudo chmod +x'
alias dmesg='sudo dmesg'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias apt='sudo apt'


# =============================================================================
# 🎯 日志查询与过滤 - 主流发行版全适配～
# =============================================================================


errlog() {
    local hours=${1:-1}
    local type=${2:-sys}
    
    echo -e "\033[1;34m🔍 正在查询过去 $hours 小时的系统错误日志...\033[0m"

    if command -v journalctl >/dev/null 2>&1; then
        local journal_opts=(-p err --since "$hours hour ago" --no-pager)
        if [ "$type" = "kernel" ]; then
            journal_opts+=(-k)
        fi
        
        sudo journalctl "${journal_opts[@]}" 2>/dev/null
        return 0
    fi

    echo -e "\033[1;33m⚠️  未检测到 journalctl，使用传统日志文件模式。\033[0m"
    local logfile
    if [ -f "/var/log/syslog" ]; then
        logfile="/var/log/syslog"
    elif [ -f "/var/log/messages" ]; then
        logfile="/var/log/messages" 
    else
        echo "⚠️  未找到系统日志文件"
        return 1
    fi
    
    sudo grep -iE "error|fail|crit" "$logfile" 2>/dev/null | sudo tail -n 100
}

loggrep() {
    local pattern="$1"
    local log_file="$2"
    local context=${3:-3}

    if [ -z "$pattern" ]; then
        echo "用法: loggrep <关键词> [文件路径] [上下文行数]"
        return 1
    fi

    if [ "$log_file" = "journal" ]; then
        echo -e "\033[1;34m🔍 正在 Journal 日志中搜索 '$pattern'...\033[0m"
        sudo journalctl -b | grep -C "$context" -i --color=auto "$pattern"
        return 0
    fi

    _search() {
        local file="$1"
        [ ! -f "$file" ] && return
        if [[ "$file" == *.gz ]]; then
            sudo zgrep -C "$context" -i --color=auto "$pattern" "$file" 2>/dev/null
        else
            sudo grep -C "$context" -i --color=auto "$pattern" "$file" 2>/dev/null
        fi
    }

    if [ -n "$log_file" ]; then
        _search "$log_file"
        return 0
    fi


    echo -e "\033[1;34m🔍 正在全系统日志中搜索 '$pattern'...\033[0m"

    if command -v journalctl >/dev/null 2>&1; then
        echo -e "\n\033[1;33m--- 正在搜索 Journal 系统日志 ---\033[0m"
        sudo journalctl -b | grep -C "$context" -i --color=auto "$pattern" 2>/dev/null
    fi


    local syslog_file="/var/log/syslog"
    [ ! -f "$syslog_file" ] && syslog_file="/var/log/messages"
    
    local auth_file="/var/log/auth.log"
    [ ! -f "$auth_file" ] && auth_file="/var/log/secure"

    echo -e "\n\033[1;33m--- 正在搜索核心文本日志文件 ---\033[0m"
    _search "$syslog_file"
    _search "$auth_file"
    _search "/var/log/dmesg"
    _search "/var/log/Xorg.0.log"

    echo -e "\n\033[1;33m--- 正在搜索其他应用日志 (这可能需要一点时间) ---\033[0m"
    sudo bash -c 'find /var/log -type f \( -name "*.log" -o -name "*.log.*" \) 2>/dev/null | sort' | while read -r f; do
        case "$f" in
            *syslog*|*messages*|*secure*|*auth.log*|*dmesg*|*Xorg*) continue ;;
        esac
        _search "$f"
    done
}




# =============================================================================
# 🎯 补全与按键绑定 - 让输入变得更智能～
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

bind 'set show-all-if-ambiguous on'
bind 'set menu-complete-display-prefix on'
bind '"\t": menu-complete'
bind '"\e[Z": menu-complete-backward'
bind 'set colored-stats on'
bind 'set colored-completion-prefix on'
bind -x '"\C-x\C-t": tmuxmgr' 2>/dev/null || true
bind '"\C-r": reverse-search-history'


# ==========================================
# 开发者 别名
# ==========================================
# web
alias npmi='npm install'
alias rundev='npm run dev'
alias runbuild='npm run build'
alias newvue='npm create vite'
#springboot
alias mvninstall='mvn clean install'
alias mvncompile='mvn clean compile'
alias mvnrun='mvn clean spring-boot:run -DskipTests'
#Android
alias buildapp='./gradlew build'
alias cleanapp='./gradlew clean'
alias runapp='./gradlew installDebug'




# =============================================================================
# 👤 用户自定义配置与扩展 - 主人的个性化空间～
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

function yazi() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
