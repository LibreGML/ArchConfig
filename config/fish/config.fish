if status is-interactive
    
    ### ============================================================
    ### 当su root并cd到root主目录，再切换回普通用户进行cd时，会出现如下报错：
    ### mv: replace '/home/tzgml/.local/share/z/data', overriding mode 0600 (rw-------)?
    ### 先su root，再  vim $HOME/.config/fish/conf.d/z.fish,在开头添加
    ###  if test (id -u) -eq 0
    ###      exit   # 禁止root用户用z插件
    ###  end
    ### ============================================================
    
    # ==========================================
    # 🏠 环境检测与初始化 - 自动识别系统发行版喵～
    # ==========================================
    
    function _detect_distro
        if test -f /etc/redhat-release
            echo "redhat"
        else if test -f /etc/debian_version
            echo "debian"
        else if test -f /etc/arch-release
            echo "arch"
        else
            echo "unknown"
        end
    end
    
    set -gx DISTRO_TYPE (_detect_distro)
    
    # ==========================================
    # 🎨 Fish Shell 基础配置 - 颜色主题和快捷键设置呀～
    # ==========================================
    
    set -U fish_greeting ""
    set -g fish_autosuggestion_enabled 1
    set -g fish_color_normal c8d6e5
    set -g fish_color_command 00d9ff
    set -g fish_color_param 9d8eff
    set -g fish_color_quote fff269
    set -g fish_color_redirection 00ffaa
    set -g fish_color_error ff6b6b
    set -g fish_color_comment 6c7a8c
    set -g fish_color_selection ffffff --bold --background=2d3436
    set -g fish_color_valid_path 00ffff --underline
    set -g fish_color_operator 00ffaa
    set -g fish_color_autosuggestion 4b5563
    set -g fish_color_cwd 00d9ff
    set -g fish_color_user 00ffaa
    set -g fish_color_host 9d8eff
    bind ctrl-z undo
    bind ctrl-y redo
    
    # ==========================================
    # 📂 目录跳转快捷方式 - 快速到达常用目录呢～
    # ==========================================
    
    alias home='cd $HOME 2>/dev/null || cd ~'
    alias cache='cd $HOME/.cache 2>/dev/null || cd ~'
    alias config='cd $HOME/.config 2>/dev/null || cd ~'
    alias localshare='cd $HOME/.local/share 2>/dev/null || cd ~'
    alias localstate='cd $HOME/.local/state 2>/dev/null || cd ~'
    alias yaycache='cd $HOME/.cache/yay/'
    alias pacmanvar='cd /var/cache/pacman/pkg/'
    alias hypr='cd $HOME/.config/hypr'
    alias waybardir='cd $HOME/.config/waybar'
    alias archconfig='cd $HOME/Mycode/ArchConfig'
    alias pics='cd $HOME/Pictures'
    alias docs='cd ~/Documents 2>/dev/null || cd ~'
    alias downs='cd ~/Downloads 2>/dev/null || cd ~'


    # ==========================================
    # ✏️ 智能编辑器配置 - 多级回退机制确保可用性呀～
    # ==========================================
        
    set -x ED vim

    if command -q fresh
        set -x ED fresh
        alias e='fresh'
        alias vim='fresh'
        alias nvim='fresh'
        alias nano='fresh'
        alias micro='fresh'
    else if command -q vim
        alias e='vim'
    else if command -q vi
        set -x ED vi
        alias e='vi'
    else if command -q nano
        set -x ED nano
        alias e='nano'
    else if command -q micro
        set -x ED micro
        alias e='micro'
    end

    alias zshrc="$ED $HOME/.zshrc"
    alias fishrc="$ED $HOME/.config/fish/config.fish"
    alias kittyconf="$ED $HOME/.config/kitty/kitty.conf"
    alias hyprconf="$ED $HOME/.config/hypr/hyprland.lua"

    alias bashrc="sudo $ED /etc/bash.bashrc"
    alias pacmanconf="sudo $ED /etc/pacman.conf"
    alias localeconf="sudo $ED /etc/locale.gen"
    alias systemconf="sudo $ED /etc/systemd/system.conf"
    alias journalconf="sudo $ED /etc/systemd/journald.conf"
    alias grubconf="sudo $ED /etc/default/grub"
    alias makepkgconf="sudo $ED /etc/makepkg.conf"
    
    # ==========================================
    # ⚙️ 系统服务控制 - systemd 服务管理命令呀～
    # ==========================================
    
    if command -q systemctl
        
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
        alias mysqld='sudo systemctl start mysqld'
        alias tomcatd='sudo systemctl start tomcat10'
     
        if test "$DISTRO_TYPE" = "arch"
            if command -q mkinitcpio
                alias mkinitcpio='sudo mkinitcpio'
            end
        end
    end
    
    # ==========================================
    # 🧹 垃圾清理工具 - 清理缓存和日志文件呢～
    # ==========================================
    
    if command -q journalctl
        alias journalclean='sudo journalctl --vacuum-size=0M && sudo journalctl --vacuum-time=0s && sudo rm -rf /var/log/*'
    end
    
    alias cacheclean='sudo sync && sudo sysctl -w vm.drop_caches=3 && rm -rf $HOME/.cache/* && rm -rf ~/.local/share/Trash/files/*'
    
    if command -q yarn && command -q npm && command -q pnpm
        alias npmclean='sudo yarn cache clean && sudo npm cache clean --force && sudo pnpm store prune'
    else if command -q npm
        alias npmclean='sudo npm cache clean --force'
    end
    
    if test "$DISTRO_TYPE" = "arch"
        if command -q pacman
            if command -q yay
                alias pkgclean='sudo pacman -Scc --noconfirm && yay -Scc --noconfirm && sudo paccache -rk0'
            else
                alias pkgclean='sudo pacman -Scc --noconfirm && sudo paccache -rk0'
            end
        end
    else if test "$DISTRO_TYPE" = "debian"
        if command -q apt
            alias pkgclean='sudo apt clean && sudo apt autoclean && sudo apt autoremove --purge -y'
        end
    else if test "$DISTRO_TYPE" = "redhat"
        if command -q dnf
            alias pkgclean='sudo dnf clean all && sudo dnf autoremove -y'
        end
    end
    
    # ==========================================
    # 💻 日常工作命令增强 - Python、历史记录等常用命令哦～
    # ==========================================
    
    alias python='python3'
    alias py='python3'
    alias h='history'
    alias als='alias'
    alias x='extract'

    
    if test "$DISTRO_TYPE" = "arch"
        if command -q grub-mkconfig
            alias grubmk='sudo grub-mkconfig -o /boot/grub/grub.cfg'
        end
        
        if command -q btrfs
            alias btrfszip='sudo btrfs filesystem defragment -r -v -czstd /'
        end
    end
    
    if command -q fcitx5-diagnose
        alias checkfcitx='fcitx5-diagnose'
    end
    
    if test -f /lib/ld-linux-x86-64.so.2
        alias libhelp='/lib/ld-linux-x86-64.so.2 --help'
    end
    
    if command -q fdisk && command -q df && command -q lsblk
        alias diskinfo='sudo fdisk -l && df -h && lsblk'
    end
    
    alias ducks='du -cksh * | sort -hr | head'
    alias dusort='du -sh * | sort -hr'
    alias dush='du -sh'
    
    if command -q httping
        alias ting='httping'
    end
    
    if command -q hyprlock
        alias xlock='hyprlock -p'
    end
    
    if command -q upower
        function battery
            set -l bat_device (upower -e 2>/dev/null | grep BAT | head -1)
            if test -n "$bat_device"
                upower -i $bat_device | grep percentage
            else
                echo "🔋 未检测到电池设备"
            end
        end
    end
    
    if command -q ip
        function gateway
            ip route show default 2>/dev/null | awk '{print $3}' | head -1
        end
    end
    
    if command -q hyprpicker
        alias pickcolor='hyprpicker -a'
        alias pickrgb='hyprpicker -a -f rgb'
    end
    
    if command -q wayvnc
        alias stopvnc='pkill -9 wayvnc && killall -9 wayvnc'
        alias startvnc='WLR_RDP_TX_CAPTURE_ALL_KEYS=1 wayvnc -v 0.0.0.0 5900'
    end
    
    
    if command -q tldr
        alias man='tldr'
    end
    
    alias chmodx='sudo chmod +x'
    
    function mine
        if test (count $argv) -eq 0
            echo "😿 请指定要修改所有权的文件或目录呢～" >&2
            echo "💡 用法: mine file1 file2 dir1 ..."
            return 1
        end
        
        set -l user (whoami)
        
        echo "🔧 正在修改所有权为 $user:$user ..."
        
        for item in $argv
            if not test -e "$item"
                echo "⚠️ 跳过不存在的: $item"
                continue
            end
            
            if test -d "$item"
                sudo chown -R $user:$user $item 2>/dev/null
                if test $status -eq 0
                    echo "✅ $item/* → $user:$user"
                else
                    echo "❌ 修改失败: $item（可能需要权限）"
                end
            else
                sudo chown $user:$user $item 2>/dev/null
                if test $status -eq 0
                    echo "✅ $item → $user:$user"
                else
                    echo "❌ 修改失败: $item（可能需要权限）"
                end
            end
        end
        
        echo "✨ 所有权修改完成～"
    end
    
    function setproxy
        set -gx http_proxy "http://127.0.0.1:7897"
        set -gx https_proxy "http://127.0.0.1:7897"
        set -gx all_proxy "http://127.0.0.1:7897"  
        echo "🌐 HTTP 代理已设置: 127.0.0.1:7897"
    end
    
    function noproxy
        set -e -g http_proxy
        set -e -g https_proxy
        set -e -g all_proxy      
        echo "🚫 代理已禁用"
    end
    
    # ==========================================
    # 🛠️ 生产环境工具 - 系统监控和压缩解压命令呀～
    # ==========================================
    
    alias topcpu="ps -A -o %cpu,pid,user,comm | sort -nr | head -10"
    alias topmem="ps -A -o %mem,pid,user,comm | sort -nr | head -10"                        
    alias mktargz='tar -czvf'                      
    alias mktarbz2='tar -cjvf'                     
    alias untar='tar -xvf'
    alias untargz='tar -xzvf'
    alias untarbz2='tar -xjvf'
    alias flushdns='sudo resolvectl flush-caches'
    
    function genkey
        if not command -q openssl
            echo "😅 请先安装 openssl 呢～" >&2
            switch $DISTRO_TYPE
                case redhat
                    echo "   sudo dnf install openssl"
                case debian
                    echo "   sudo apt install openssl"
                case arch
                    echo "   sudo pacman -S openssl"
                case '*'
                    echo "   请根据您的发行版安装 openssl"
            end
            return 127
        end
        
        echo "🔑 正在生成随机密钥..."
        set -l key (openssl rand -base64 32)
        set -l formatted_key (echo "$key" | tr -d '\n=' | tr '/+' '_-')
        echo "$formatted_key"
        echo "✨ 密钥生成完成～记得好好保存哦～"
    end
    
    function mktar
        if test (count $argv) -eq 0
            echo "😿 请指定要压缩的文件或目录呢～" >&2
            echo "💡 用法: mktar file1 dir1 ..."
            return 1
        end
        
        for target in $argv
            if not test -e "$target"
                echo "⚠️ 跳过不存在的: '$target'"
                continue
            end
    
            set base_name (basename "$target")
            
            set tar_name "$base_name.tar"
            
            if test -e "$tar_name"
                read -l -P "⚠️ '$tar_name' 已存在，要覆盖吗？(y/N): " confirm
                if not test "$confirm" = "y" -o "$confirm" = "Y"
                    echo "⏭️ 跳过: $target"
                    continue
                end
            end
    
            echo "📦 正在创建: $tar_name"
            if tar -cvf "$tar_name" "$target" 2>/dev/null
                echo "✅ 创建成功: $tar_name"
            else
                echo "❌ 创建失败: $tar_name"
            end
        end
        
        echo "✨ 压缩任务完成～"
    end
    
    # ==========================================
    # 🔍 文件搜索工具 - 查找文件、目录和文本内容哦～
    # ==========================================
    
    function _parse_find_args
        set -l cmd_name $argv[1]
        set -l user_args $argv[2..-1]
    
        set -l search_path "."
        set -l pattern ""
    
        if test (count $user_args) -eq 1
            set pattern $user_args[1]
        else if test (count $user_args) -eq 2
            set search_path $user_args[1]
            set pattern $user_args[2]
        else
            echo "❌ 错误: 参数过多。用法: $cmd_name [路径] 模式" >&2
            return 1
        end
    
        if string match -q '~*' -- $search_path
            set search_path (realpath -- $search_path 2>/dev/null; or echo $search_path)
        end
    
        if not test -e "$search_path"
            printf "❌ 错误: 路径不存在: %s\n" $search_path >&2
            return 2
        end
    
        if not test -d "$search_path"
            printf "❌ 错误: 路径不是目录: %s\n" $search_path >&2
            return 2
        end
    
        if test -z "$pattern"
            printf "❌ 错误: 搜索模式不能为空\n" >&2
            return 3
        end
    
        echo $search_path
        echo $pattern
        return 0
    end
    
    function findfile
        set parsed (_parse_find_args findfile $argv)
        or return $status
    
        set -l search_path $parsed[1]
        set -l pattern $parsed[2]
    
        command find "$search_path" -type f -iname "*$pattern*" 2>/dev/null | head -1000
    end
    
    function finddir
        set parsed (_parse_find_args finddir $argv)
        or return $status
    
        set -l search_path $parsed[1]
        set -l pattern $parsed[2]
    
        command find "$search_path" -type d -iname "*$pattern*" 2>/dev/null | head -500
    end
    
    function findtext
        set parsed (_parse_find_args findtext $argv)
        or return $status
    
        set -l search_path $parsed[1]
        set -l pattern $parsed[2]
    
        if command -q rg
            echo "⚡ 使用 ripgrep 快速搜索: $pattern ..."
            command rg --smart-case --hidden --no-ignore \
                      --max-depth 8 --max-filesize 10M \
                      --max-columns=150 \
                      --glob='!{.git,.cargo,.lingma,.local,.java,.svn,.hg,node_modules,build,target,dist,.cache,__pycache__,.DS_Store}' \
                      -- "$pattern" "$search_path" 2>/dev/null | head -500
        else
            echo "⚠️ ripgrep (rg) 未安装，使用 grep 进行搜索（速度较慢）..." >&2
            echo "💡 建议安装 ripgrep 以获得更好的搜索体验:"
            switch $DISTRO_TYPE
                case redhat
                    echo "   sudo dnf install ripgrep"
                case debian
                    echo "   sudo apt install ripgrep"
                case arch
                    echo "   sudo pacman -S ripgrep"
                case '*'
                    echo "   请访问: https://github.com/BurntSushi/ripgrep"
            end
            echo ""
            
            command find "$search_path" -type f \
                ! -path '*/.git/*' \
                ! -path '*/node_modules/*' \
                ! -path '*/__pycache__/*' \
                ! -path '*/.cache/*' \
                -exec grep -nIH --color=auto "$pattern" {} + 2>/dev/null | head -500
        end
    end
    
    # ==========================================
    # 🗑️ 空目录清理工具 - 安全删除空目录呢～
    # ==========================================
    
    function rmemptydir
        set -l target "."
        test (count $argv) -gt 0; and set target $argv[1]
        
        if not test -e "$target"
            echo "❌ rmemptydir: 错误: 路径不存在" >&2
            return 1
        end
        if not test -d "$target"
            echo "❌ rmemptydir: 错误: 不是目录" >&2
            return 1
        end
        if test -L "$target"
            echo "❌ rmemptydir: 错误: 拒绝操作符号链接" >&2
            return 1
        end
        
        set -l abs_target (realpath "$target")
        set -l protected "/" "/home" "/root" "/etc" "/var" "/usr" "/bin" "/sbin" "/lib" "/lib64" "/tmp" "/dev" "/proc" "/sys"
        if contains -- "$abs_target" $protected
            echo "🛡️ rmemptydir: 安全错误: 禁止操作系统关键目录" >&2
            return 1
        end
        
        set -l total_count 0
        set -l iteration 0
        set -l max_iterations 100
        
        while test $iteration -lt $max_iterations
            set iteration (math $iteration + 1)
            set -l tmpfile (mktemp)
            set -l round_count 0
            
            find "$target" -mindepth 1 -depth -type d -empty \
                 ! -type l ! -fstype proc ! -fstype sysfs ! -fstype devfs \
                 -print0 2>/dev/null > "$tmpfile"
            
            if not test -s "$tmpfile"
                rm -f "$tmpfile"
                break
            end
            
            for dir in (string split0 < "$tmpfile")
                if test -n "$dir" -a -d "$dir"
                    if test -w "$dir" 2>/dev/null
                        if rmdir "$dir" 2>/dev/null
                            set -l display (string replace --all \n '␊' "$dir")
                            printf "🗑️ 已删除: %s\n" "$display"
                            set round_count (math $round_count + 1)
                            set total_count (math $total_count + 1)
                        end
                    end
                end
            end
            
            rm -f "$tmpfile"
            test $round_count -eq 0; and break
        end
        
        if test $iteration -ge $max_iterations
            echo "⚠️ rmemptydir: 警告: 达到最大迭代次数" >&2
        end
        
        if test $total_count -eq 0
            echo "📂 未发现空目录"
        else
            echo "✅ 完成: 共删除 $total_count 个空目录（迭代 $iteration 轮）"
        end
    end
    
    # ==========================================
    # 🔄 文本批量替换工具 - 使用 Perl 安全替换哦～
    # ==========================================
    
    function replacetext
        if test (count $argv) -ne 3
            echo "😿 参数不对呢～" >&2
            echo "💡 用法: replacetext '文件模式' '旧字符串' '新字符串'"
            return 1
        end
        
        set -l file_pattern $argv[1]
        set -l old_string $argv[2]
        set -l new_string $argv[3]
        
        if test -z "$old_string"
            echo "😿 旧字符串不能为空哦～" >&2
            return 1
        end
        
        if not command -q perl
            echo "😅 请先安装 perl 呢～" >&2
            switch $DISTRO_TYPE
                case redhat
                    echo "   sudo dnf install perl"
                case debian
                    echo "   sudo apt install perl"
                case arch
                    echo "   sudo pacman -S perl"
                case '*'
                    echo "   请根据您的发行版安装 perl"
            end
            return 127
        end
        
        echo "🔄 开始替换: '$old_string' -> '$new_string' （匹配: $file_pattern）"
        
        set -gx REPLACE_OLD "$old_string"
        set -gx REPLACE_NEW "$new_string"
        
        find . -type f -name "$file_pattern" -exec perl -pi -e '
            use strict;
            use warnings;
            my $old = $ENV{REPLACE_OLD};
            my $new = $ENV{REPLACE_NEW};
            s/\Q$old\E/$new/g;
        ' {} +
        
        set -e REPLACE_OLD
        set -e REPLACE_NEW
        
        echo "✅ 替换完成～人家厉不厉害～"
    end
    
    # ==========================================
    # ✏️ 批量重命名工具 - 正则表达式批量改名呀～
    # ==========================================
    
    function batchrename
        if test (count $argv) -lt 3
            echo "😿 参数不足呢～" >&2
            echo "💡 用法: batchrename '正则表达式' '替换文本' 文件1 文件2 ..."
            return 1
        end
        
        set -l regex $argv[1]
        set -l replacement $argv[2]
        set -l files $argv[3..-1]
        
        if test -z "$regex"
            echo "😿 正则表达式不能为空哦～" >&2
            return 1
        end
        
        echo "✏️ 开始批量重命名..."
        
        for file in $files
            if not test -e "$file"
                echo "⚠️ 跳过不存在的: $file"
                continue
            end
            
            set -l new_name (string replace -ra -- "$regex" "$replacement" "$file")
            
            if test -z "$new_name" -o "$file" = "$new_name"
                continue
            end
            
            if string match -q '*..*' -- "$new_name"
                echo "⚠️ 跳过不安全的重命名（包含 ..）: $file -> $new_name" >&2
                continue
            end
            
            if not string match -q '/*' -- "$file"
                and string match -q '/*' -- "$new_name"
                echo "⚠️ 跳过不安全的路径转换: $file -> $new_name" >&2
                continue
            end
            
            set -l base_name (basename "$new_name")
            if test -z "$base_name" -o "$base_name" = "." -o "$base_name" = ".."
                echo "⚠️ 跳过无效的文件名: $file -> $new_name" >&2
                continue
            end
            
            mv -i "$file" "$new_name"
            if test $status -eq 0
                echo "📝 已重命名: $file -> $new_name"
            else
                echo "❌ 重命名失败: $file"
            end
        end
        
        echo "✨ 批量重命名完成～"
    end
    
    function multirename
        if test (count $argv) -eq 0
            echo "😿 请指定要重命名的文件呢～" >&2
            echo "💡 用法: multirename file1 file2 ..."
            return 1
        end
        
        echo "✏️ 进入交互重命名模式～"
        
        set files $argv
        for file in $files
            if not test -e "$file"
                echo "⚠️ 跳过不存在的: $file"
                continue
            end
            
            echo "📄 当前文件: $file"
            read -l -P "💭 新文件名 (留空跳过，输入 'q' 退出): " new_name
            
            if test -z "$new_name"
                echo "⏭️ 跳过: $file"
            else if test "$new_name" = "q"
                echo "🚪 退出重命名～"
                return
            else
                mv "$file" "$new_name"
                if test $status -eq 0
                    echo "✅ 已重命名: $file -> $new_name"
                else
                    echo "❌ 重命名失败: $file"
                end
            end
            echo "---"
        end
        
        echo "✨ 交互重命名完成～"
    end
    
    # ==========================================
    # 🌐 HTTP 请求工具 - POST、GET 和文件上传哦～
    # ==========================================
    
    function post
        if test (count $argv) -lt 2
            echo "😿 URL 和 JSON 数据不能为空哦～" >&2
            echo "💡 用法: post 'https://uapis.cn/api/v1/search/aggregate'  '{"query":"archlinux","fetch_full":false}'  "
            return 1
        end
        
        set -l url $argv[1]
        set -l json $argv[2]
        
        if not command -q curl
            echo "😅 请先安装 curl 呢～" >&2
            switch $DISTRO_TYPE
                case redhat
                    echo "   sudo dnf install curl"
                case debian
                    echo "   sudo apt install curl"
                case arch
                    echo "   sudo pacman -S curl"
                case '*'
                    echo "   请根据您的发行版安装 curl"
            end
            return 127
        end
        
        echo "📤 正在发送 POST 请求: $url ..."
        
        set response (curl -s -X POST \
            -H "Content-Type: application/json" \
            -d "$json" \
            "$url")
        
        if command -q jq
            echo $response | jq .
        else
            echo $response
        end
        
        echo "✅ POST 请求完成～"
    end
    
    
    function get
        if test (count $argv) -eq 0
            echo "😿 URL 不能为空哦～" >&2
            echo "💡 用法: get 'https://uapis.cn/api/v1/convert/unixtime' 'time=2023-10-27 10:30:00'   "
            return 1
        end
        
        set -l url "$argv[1]"

        if not string match -q 'http://*' "$url" && not string match -q 'https://*' "$url"
            echo "❌ URL 格式不正确，必须以 http:// 或 https:// 开头" >&2
            return 1
        end
        
        if not command -q curl
            echo "😅 请先安装 curl 才能使用这个功能呢～" >&2
            switch $DISTRO_TYPE
                case redhat
                    echo "   sudo dnf install curl"
                case debian
                    echo "   sudo apt install curl"
                case arch
                    echo "   sudo pacman -S curl"
                case '*'
                    echo "   请根据您的发行版安装 curl"
            end
            return 127
        end
        
        echo "🌐 正在请求: $url ..."
        
        set -l tmpfile (mktemp)
        set -l headerfile (mktemp)
        
        set -l curl_args -s -f -m 10 -X GET \
            -H "User-Agent: http_get/1.0" \
            -H "Accept: application/json, */*" \
            -H "Accept-Encoding: gzip, deflate" \
            -D "$headerfile" \
            -o "$tmpfile" \
            -w "%{http_code}" \
            -G
        
        for param in $argv[2..-1]
            if string match -qr '^[^=]+=' "$param"
                set curl_args $curl_args --data-urlencode "$param"
            else
                echo "⚠️ 跳过格式错误的参数: '$param'" >&2
            end
        end
        
        set curl_args $curl_args "$url"
        
        set -l status_code (command curl $curl_args 2>&1)
        
        if test $status -ne 0
            rm -f "$tmpfile" "$headerfile"
            echo "❌ 请求失败了呢～可能是网络问题或者服务器出错啦" >&2
            return 1
        end
        
        set status_code (string trim "$status_code")
        set status_code (string match -r '^[0-9]+$' "$status_code")
        
        if not string match -qr '^2[0-9][0-9]$' "$status_code"
            rm -f "$tmpfile" "$headerfile"
            echo "🔴 HTTP $status_code - 请求出问题啦～" >&2
            if test -s "$headerfile"
                echo "Response Headers:" (cat "$headerfile") >&2
            end
            return 1
        end
        
        if not test -s "$tmpfile"
            rm -f "$tmpfile" "$headerfile"
            echo "✨ 请求成功！不过没有返回内容呢～"
            return 0
        end
        
        set -l body (cat "$tmpfile")
        rm -f "$tmpfile" "$headerfile"
        
        if command -q jq
            echo "$body" | jq -e . 2>/dev/null
            or echo "$body"
        else
            echo "$body"
        end
        
        echo "✅ 请求成功啦～"
    end
    
    # ==========================================
    # 📦 Tmux 会话管理器 - 可视化管理 tmux 会话呢～
    # ==========================================
    
    function tmuxmgr
        if not command -q tmux
            echo "😅 请先安装 tmux 呢～" >&2
            switch $DISTRO_TYPE
                case redhat
                    echo "   sudo dnf install tmux"
                case debian
                    echo "   sudo apt install tmux"
                case arch
                    echo "   sudo pacman -S tmux"
                case '*'
                    echo "   请根据您的发行版安装 tmux"
            end
            return 1
        end
        
        if not command -q fzf
            echo "😅 请先安装 fzf 呢～" >&2
            switch $DISTRO_TYPE
                case redhat
                    echo "   sudo dnf install fzf"
                case debian
                    echo "   sudo apt install fzf"
                case arch
                    echo "   sudo pacman -S fzf"
                case '*'
                    echo "   请根据您的发行版安装 fzf"
            end
            return 1
        end
        
        if set -q TMUX
            echo "⚠️ 人家已经在 tmux 会话中啦～" >&2
            return 1
        end

        while true
            set -l action (printf "🔗 进入会话\n➕ 创建新会话\n🗑️ 删除会话\n❌ 退出" | fzf --height=40% --border --prompt="Tmux Manager > " --header="按 ESC 取消")
            
            if test -z "$action"
                break
            end
            
            switch "$action"
                case "🔗 进入会话"
                    set -l sessions (tmux ls -F '#{session_name}' 2>/dev/null)
                    
                    if test (count $sessions) -eq 0
                        echo "📭 没有活跃的 tmux 会话" >&2
                        read -l -P "按任意键继续..." -s -n 1
                        continue
                    end
                    
                    set -l target_session (printf '%s\n' $sessions | fzf --prompt="选择要进入的会话 > " --header="按 ESC 返回")
                    
                    if test -n "$target_session"
                        tmux attach-session -t "$target_session"
                    end
                    
                case "➕ 创建新会话"
                    read -l -P "输入会话名称: " session_name
                    
                    if test -z "$session_name"
                        echo "❌ 会话名称不能为空" >&2
                        read -l -P "按任意键继续..." -s -n 1
                        continue
                    end
                    
                    if tmux has-session -t="$session_name" 2>/dev/null
                        echo "⚠️ 会话 '$session_name' 已存在" >&2
                        read -l -P "按任意键继续..." -s -n 1
                    else
                        tmux new-session -d -s "$session_name"
                        echo "✅ 已创建并连接到会话 '$session_name'" >&2
                        tmux attach-session -t "$session_name"
                    end
                case "🗑️ 删除会话"
                    set -l sessions (tmux ls -F '#{session_name}' 2>/dev/null)
                    
                    if test (count $sessions) -eq 0
                        echo "📭 没有活跃的 tmux 会话" >&2
                        read -l -P "按任意键继续..." -s -n 1
                        continue
                    end
                    
                    set -l target_session (printf '%s\n' $sessions | fzf --prompt="选择要删除的会话 > " --header="按 ESC 返回")
                    
                    if test -n "$target_session"
                        tmux kill-session -t "$target_session"
                        echo "✅ 已删除会话 '$target_session'" >&2
                        read -l -P "按任意键继续..." -s -n 1
                    end
                    
                case "❌ 退出"
                    break
                    
                case "*"
                    continue
            end
        end
    end
    
    # ==========================================
    # 📦 Arch Linux 包管理器 - Pacman 和 Yay 命令呀～
    # ==========================================

    if test "$DISTRO_TYPE" = "arch"
        if command -q pacman
            alias pac='sudo pacman'
            alias pacs='sudo pacman -S'
            alias pacss='sudo pacman -Ss'
            alias pacsyu='sudo pacman -Syu --noconfirm --disable-download-timeout'
            alias pacsyyu='sudo pacman -Syyu --noconfirm --disable-download-timeout'
            alias pacscc='sudo pacman -Scc'
            alias pacr='sudo pacman -R'
            alias pacrsn='sudo pacman -Rsn'
            alias pacu='sudo pacman -U'
            alias pacqo='sudo pacman -Qo'
            alias pacsw='sudo pacman -Sw'
            alias pacqs='sudo pacman -Qs'
            alias pacqi='sudo pacman -Qi'
            alias pacf='sudo pacman -F'
            
            if command -q downgrade
                alias downgrade='sudo downgrade'
            end
        else
            echo "⚠️ pacman 未安装，跳过 Pacman 别名"
        end
        
        if command -q yay
            alias yays='yay -S'
            alias yayss='yay -Ss'
            alias yaysyu='yay -Syu --noconfirm --disable-download-timeout'
            alias yaysyyu='yay -Syyu --noconfirm --disable-download-timeout'
            alias yayscc='yay -Scc'
            alias yayr='yay -R'
            alias yayrsn='yay -Rsn'
            alias installed='yay -Qeq'
            
            alias syu='yay -Syu --noconfirm --disable-download-timeout && fisher update && fish_update_completions'
            alias syyu='yay -Syyu --noconfirm --disable-download-timeout && fisher update && fish_update_completions'
            alias yyu='yay -Syyu --noconfirm'
            alias yuu='yay -Syuu --noconfirm'
            alias syuu='yay -Syuu --noconfirm'
        else
            echo "ℹ️ yay 未安装，跳过 Yay 别名（建议安装: pacman -S yay 或 paru）"
        end
        
        function lastinstalled
            set -ql argv[1]; and set lines $argv[1]; or set lines 50
            if test -f /var/log/pacman.log
                grep -E '\[ALPM\] (installed|upgraded)' /var/log/pacman.log | tail -n $lines
            else
                echo "❌ /var/log/pacman.log 不存在"
                return 1
            end
        end
        
        function fileinpkg
            if test (count $argv) -eq 0
                echo "📦 用法: fileinpkg <包名>"
                return 1
            end
            
            if command -q yay
                yay -Qlq "$argv[1]" 2>/dev/null | grep -v '/$' | xargs -r du -h | sort -h
                if test $status -ne 0
                    echo "❌ 包 '$argv[1]' 不存在或未安装"
                    return 1
                end
            else if command -q pacman
                pacman -Qlq "$argv[1]" 2>/dev/null | grep -v '/$' | xargs -r du -h | sort -h
                if test $status -ne 0
                    echo "❌ 包 '$argv[1]' 不存在或未安装"
                    return 1
                end
            else
                echo "❌ 需要安装 pacman 或 yay"
                return 127
            end
        end
        
        function installfrom
            if test -z "$argv[1]"
                echo "😿 请指定包列表文件路径呢～" >&2
                return 1
            end
        
            if not test -f "$argv[1]"
                echo "❌ File $argv[1] 不存在啊宝宝" >&2
                return 1
            end
            
            set -l packages (grep -v '^#' "$argv[1]" | grep -v '^[[:space:]]*$' | string trim)
            
            if test (count $packages) -eq 0
                echo "⚠️ 文件中没有有效的包名" >&2
                return 1
            end
            
            echo "📦 准备安装以下包:"
            for pkg in $packages
                echo "   - $pkg"
            end
            
            if command -q yay
                echo "🔄 使用 yay 安装..."
                yay -S --needed --noconfirm $packages
            else if command -q pacman
                echo "🔄 使用 pacman 安装..."
                sudo pacman -S --needed --noconfirm $packages
            else
                echo "❌ 需要安装 pacman 或 yay" >&2
                return 127
            end
            
            if test $status -eq 0
                echo "✅ 安装完成～"
            else
                echo "❌ 部分包安装失败，请检查错误信息" >&2
                return 1
            end
        end        
    end
    
    # ==========================================
    # 🐳 Docker 容器管理 - 完整的 Docker 命令集哦～
    # ==========================================

    if command -q docker
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
        
        if command -q docker-compose
            set -gx COMPOSE_CMD "docker-compose"
        else
            set -gx COMPOSE_CMD "docker compose"
        end
        
        alias dcup="$COMPOSE_CMD up -d"
        alias dcdown="$COMPOSE_CMD down"
        alias dcbuild="$COMPOSE_CMD build --no-cache"
        alias dcrestart="$COMPOSE_CMD restart"
        
        function dtop
            if not docker ps -q 2>/dev/null | grep -q .
                echo "🚫 没有运行中的容器"
                return 1
            end
            docker stats --no-stream --format "table {{.Name}}\t{{.MemPerc}}\t{{.MemUsage}}\t{{.CPUPerc}}" | \
            sort -k2 -hr | head -21
        end
        
        function dip
            if test (count $argv) -eq 0
                docker ps --format '{{.Names}}' | while read -l container
                    set -l ip (docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}}' $container 2>/dev/null)
                    test -n "$ip" && printf "%-30s %s\n" $container $ip
                end
            else
                for container in $argv
                    set -l ip (docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $container 2>/dev/null)
                    if test -n "$ip"
                        echo "🌐 $ip"
                    else
                        echo "❌ 容器 '$container' 不存在或没有 IP 地址" >&2
                        return 1
                    end
                end
            end
        end
        
        function denter
            if test (count $argv) -eq 0
                echo "📝 Usage: denter <container>"
                return 1
            end
            
            set -l container $argv[1]
            
            if not docker ps --format '{{.Names}}' | grep -qx "$container"
                if docker ps -a --format '{{.Names}}' | grep -qx "$container"
                    docker start $container
                else
                    echo "❌ 容器不存在" >&2
                    return 1
                end
            end
            
            if docker exec $container test -f /bin/bash 2>/dev/null
                docker exec -it $container bash
            else if docker exec $container test -f /bin/sh 2>/dev/null
                docker exec -it $container sh
            else
                echo "❌ 未找到 shell" >&2
                return 1
            end
        end
        
        function dcp
            if test (count $argv) -ne 2
                echo "📝 Usage: dcp <src> <dst>"
                return 1
            end
            docker cp $argv[1] $argv[2]
        end
        
        function drestore
            set -l running (docker ps -q 2>/dev/null)
            test -n "$running" && docker stop $running 2>/dev/null
            
            set -l all (docker ps -aq 2>/dev/null)
            test -n "$all" && docker rm -f $all 2>/dev/null
            
            set -l volumes (docker volume ls -q 2>/dev/null)
            test -n "$volumes" && docker volume rm -f $volumes 2>/dev/null
            
            set -l images (docker images -q 2>/dev/null)
            test -n "$images" && docker rmi -f $images 2>/dev/null
            
            set -l networks (docker network ls -q -f type=custom 2>/dev/null)
            test -n "$networks" && docker network rm $networks 2>/dev/null
            
            docker builder prune -af 2>/dev/null
            
            docker system prune -af --volumes 2>/dev/null
            
            echo "🔄 Docker 已重置"
        end
        
        function dvol
            if test (count $argv) -lt 3
                echo "📝 Usage: dvol <volume-name> <container-path> <image> [args...]"
                echo "💡 Example: dvol my-data /app/data nginx"
                return 1
            end
            
            set -l vol $argv[1]
            set -l mount $argv[2]
            set -l image $argv[3]
            set -l rest $argv[4..-1]
            
            if not docker volume inspect $vol >/dev/null 2>&1
                echo "📦 Creating volume '$vol'..."
                docker volume create $vol
            end
            
            echo "🚀 Running $image with $vol → $mount"
            docker run -v $vol:$mount $rest $image
        end
        
        function dvollist
            if not command -q docker
                echo "❌ Docker not installed" >&2
                return 1
            end
            
            if not docker info >/dev/null 2>&1
                echo "❌ Docker daemon not running" >&2
                return 1
            end

            set volume_info (docker volume ls -q 2>/dev/null | while read -l vol
                docker volume inspect --format '{{.Name}}|||{{.Mountpoint}}' "$vol" 2>/dev/null
            end)
            
            if test (count $volume_info) -eq 0
                echo "📭 No volumes found"
                return 0
            end

            set container_mounts (docker ps -aq 2>/dev/null | while read -l cid
                docker inspect --format '{{range .Mounts}}{{if eq .Type "volume"}}{{.Name}}|{{$.Name}}|{{.Destination}}{{println}}{{end}}{{end}}' "$cid" 2>/dev/null
            end)

            set is_first 1
            
            for info in $volume_info
                set parts (string split '|||' $info)
                if test (count $parts) -lt 2
                    continue
                end
                set vol $parts[1]
                set mountpoint $parts[2]
                
                if test $is_first -eq 0
                    echo ""
                end
                set is_first 0
                
                echo "📦 $vol"
                echo "   🖥️  Host: $mountpoint"
                
                set used 0
                for mount in $container_mounts
                    if test -z "$mount"
                        continue
                    end
                    
                    set m_parts (string split '|||' $mount)
                    if test (count $m_parts) -lt 3
                        continue
                    end
                    
                    set cname (string trim "$m_parts[2]")
                    
                    if test "$m_parts[1]" = "$vol"
                        set used 1
                        echo "   └── 🐳 $cname → $m_parts[3]"
                    end
                end
                
                if test $used -eq 0
                    echo "   └── ⚪ (not mounted by any container)"
                end
            end
        end
    end
    
    # ==========================================
    # 🌿 Git 版本控制 - 完整的 Git 命令别名呢～
    # ==========================================

    if command -q git
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

        function gwhatchange
            git log --oneline | head -20
            echo -n "📝 输入哈希值查看文件: "
            read -l hash
            if test -n "$hash"
                git show $hash
            end
        end
        
        function pushremote
            set -l current_branch (git branch --show-current)
            if test -z "$current_branch"
                echo "Error: Not on a branch or failed to detect current branch"
                return 1
            end
            
            git add .
            git commit -m "fix bugs and add new features"
            git pull origin $current_branch
            git push origin $current_branch
        end
        
        
        
    end
    
    # ==========================================
    # 🗄️ MySQL 数据库管理 - 数据库连接和备份命令呀～
    # ==========================================
    
    if command -q mysql
        alias my='mysql --defaults-extra-file=$HOME/.my.cnf'
        alias my-ls='mysql --defaults-extra-file=$HOME/.my.cnf -e "SHOW DATABASES;"'
        alias my-tables='mysql --defaults-extra-file=$HOME/.my.cnf -e "SHOW TABLES;"'
        alias my-conn='mysql --defaults-extra-file=$HOME/.my.cnf -e "SHOW PROCESSLIST;"'
        alias my-vars='mysql --defaults-extra-file=$HOME/.my.cnf -e "SHOW VARIABLES LIKE '\''%max_connections%'\'';"'
    
        function my-backup
            set -l db $argv[1]
            if test -z "$db"
                echo "USAGE: my-backup <database_name>" >&2
                return 1
            end
            set -l date (date +%F_%H%M%S)
            set -l out (string join "" $db "_" $date ".sql.gz")
            mysqldump --defaults-extra-file=$HOME/.my.cnf --single-transaction --routines --triggers --events --quick --lock-tables=false $db | gzip > $out
            echo $out
        end
    
        function my-backup-all
            set -l date (date +%F_%H%M%S)
            set -l out (string join "" "all_databases_" $date ".sql.gz")
            mysql --defaults-extra-file=$HOME/.my.cnf -e "SHOW DATABASES;" -N -B | grep -v -E '^(information_schema|performance_schema|mysql|sys)$' | xargs mysqldump --defaults-extra-file=$HOME/.my.cnf --single-transaction --routines --triggers --events --databases | gzip > $out
            echo $out
        end
    
        function my-restore
            set -l file $argv[1]
            set -l db $argv[2]
            if test -z "$file"; or test -z "$db"
                echo "USAGE: my-restore <backup.sql.gz> <database_name>" >&2
                return 1
            end
            read -P "Type '$db' to confirm restore: " confirm
            if test "$confirm" != "$db"
                echo "CANCELLED" >&2
                return 1
            end
            if string match -q "*.gz" $file
                gunzip < $file | mysql --defaults-extra-file=$HOME/.my.cnf $db
            else
                mysql --defaults-extra-file=$HOME/.my.cnf $db < $file
            end
        end
    end
    
    # ==========================================
    # 📁 文件列表显示 - eza 增强的 ls 命令哦～
    # ==========================================
    
    if command -q eza
        alias ls="eza --color=auto --icons"
        alias l="eza -lbah --icons"
        alias la="eza -labgh --icons"
        alias ll="eza -lbg --icons"
        alias lsa="eza -lbagR --icons"
        alias lst="eza -lTabgh --icons"
    end
    
    # ==========================================
    # 🔧 错误修正别名 - 纠正常见打字错误呢～
    # ==========================================
    
    alias sl='ls -a'
    alias lz='ls'
    alias s='ls -a'
    alias sls='ls -a'
    alias ayy='yay'
    alias yya='yay'
    alias yyy='yay'
    alias sduo='sudo'
    alias dmesg='sudo dmesg'
    alias apt='sudo apt'

    
    # ==========================================
    # 🖼️ Kitty 终端工具 - 图片查看和剪贴板操作呀～
    # ==========================================
    
    if command -q kitty
        alias catimg='kitten icat'
        alias diff='kitten diff'
        alias getclip='kitten clipboard --get-clipboard'
        
        function setclip
            if test (count $argv) -gt 0
                if test -f "$argv[1]"
                    cat "$argv[1]" | kitten clipboard
                else
                    printf '%s\n' $argv | kitten clipboard
                end
            else
                kitten clipboard
            end
        end
    end
    
    # ==========================================
    # 💻 开发者工具 - Web、Java、Android 开发命令哦～
    # ==========================================
    
    alias npmi='npm install'
    alias rundev='npm run dev'
    alias runbuild='npm run build'
    alias newvue='npm create vite'
    
    alias mvninstall='mvn clean install'
    alias mvncompile='mvn clean compile'
    alias mvnrun='mvn clean spring-boot:run -DskipTests'
    
    alias buildapp='./gradlew build'
    alias cleanapp='./gradlew clean'
    alias runapp='./gradlew installDebug'
    
    function buildwx
        if yarn run build:mp-weixin
            wechat-devtools-cli open --project (pwd)/dist/build/mp-weixin
        else
            echo "编译失败！" >&2
            return 1
        end
    end
    
    # ==========================================
    # 🛠️ 实用辅助函数 - 目录导航和命令未找到处理呢～
    # ==========================================
    
    alias back='prevd'
    alias prev='prevd'
    alias next='nextd'
    
    function mkcd
        if test (count $argv) -ne 1
            echo "😿 请指定目录名称呢～" >&2
            echo "💡 用法: mkcd 'My Directory'"
            return 1
        end
        
        echo "📁 正在创建目录: $argv[1]"
        if mkdir -p "$argv[1]" && cd "$argv[1]"
            echo "✅ 目录创建成功并已进入～ "(pwd)
        else
            echo "❌ 创建目录失败了呢: $argv[1]" >&2
            return 1
        end
    end
    
    function fish_command_not_found
        if command -q pkgfile
            set -l result (pkgfile -b "$argv[1]" 2>/dev/null | head -1)
            if test -n "$result"
                echo "📦 需要 sudo pacman -S $result" >&2
            else
                echo "💭 宝宝不要再说胡话了~~" >&2
            end
        else
            echo '📦 需要 sudo pacman -S pkgfile && sudo pkgfile -u'
        end
        return 127
    end
    
    # ==========================================
    # ⚙️ 个人环境变量配置 - 启动信息显示呀～
    # ==========================================
    
    if command -q fastfetch > /dev/null
        fastfetch --logo arco_small
    end
    
    function yazi
    	set tmp (mktemp -t "yazi-cwd.XXXXXX")
    	command yazi $argv --cwd-file="$tmp"
    	if read -z cwd < "$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
    		builtin cd -- "$cwd"
    	end
    	rm -f -- "$tmp"
    end


end
