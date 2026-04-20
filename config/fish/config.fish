if status is-interactive

    # 1. sudo pacman -S fish fisher
    # 2. fisher install jorgebucaran/fisher jethrokuan/z patrickf1/fzf.fish ilancosman/tide jorgebucaran/autopair.fish gazorby/fish-abbreviation-tips oh-my-fish/plugin-extract meaningful-ooo/sponge nickeb96/puffer-fish
    

    # 基本属性
    set -U fish_greeting ""
    set -g fish_autosuggestion_enabled 1
    set -g fish_color_normal c8d6e5  # 淡蓝色灰 - 主文本
    set -g fish_color_command 00d9ff  # 亮青色 - 命令
    set -g fish_color_param 9d8eff  # 柔紫色 - 参数
    set -g fish_color_quote fff269  # 柔和黄 - 引号
    set -g fish_color_redirection 00ffaa  # 青色绿 - 重定向
    set -g fish_color_error ff6b6b  # 柔和红 - 错误
    set -g fish_color_comment 6c7a8c  # 深灰色 - 注释
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
	# 目录跳转快捷方式区域
	# ==========================================	
	alias cdroot='cd /'
	alias home='cd $HOME'
	alias cache='cd $HOME/.cache'
	alias cacheyay='cd $HOME/.cache/yay'
	alias yaycache='cd $HOME/.cache/yay/'
	alias config='cd $HOME/.config'
	alias localshare='cd $HOME/.local/share'
	alias localstate='cd $HOME/.local/state'
	alias pacmanvar='cd /var/cache/pacman/pkg/'
	alias hypr='cd $HOME/.config/hypr'
	alias waybardir='cd $HOME/.config/waybar'
	alias archconfig='cd $HOME/Mycode/ArchConfig'
    alias download='cd $HOME/Downloads'
    alias picture='cd $HOME/Pictures'
	alias document='cd $HOME/Documents'
	
	# ==========================================
	# 配置文件编辑快捷方式区域
	# ==========================================
	if command -q micro
        alias e='micro'
        alias nvim='micro'
        alias vim='micro'
        alias nano='micro'
        alias zshrc='micro $HOME/.zshrc'
        alias fishrc='micro $HOME/.config/fish/config.fish'
        alias bashrc='micro $HOME/.bashrc'
        alias kittyconf='micro $HOME/.config/kitty/kitty.conf'
        alias hyprconf='micro $HOME/.config/hypr/hyprland.conf'
        alias microconf='micro $HOME/.config/micro/settings.json'
        alias pacmanconf='sudo micro /etc/pacman.conf'
        alias localeconf='sudo micro /etc/locale.gen'
        alias systemconf='sudo micro /etc/systemd/system.conf'
        alias journalconf='sudo micro /etc/systemd/journald.conf'
        alias grubconf='sudo micro /etc/default/grub'
        alias makepkgconf='sudo micro /etc/makepkg.conf'
    end
	
	# ==========================================
	# 系统服务控制区域
	# ==========================================
	
	alias sysinfo='fastfetch && uname -a  && hostnamectl && localectl && timedatectl'
	alias systemctl='sudo systemctl'
	alias sysenable='sudo systemctl enable --now'
	alias sysdisable='sudo systemctl disable --now'
	alias sysstart='sudo systemctl start'
	alias sysrestart='sudo systemctl restart'
	alias sysstop='sudo systemctl stop'
	alias sysstatus='sudo systemctl status'
	alias syskill='sudo systemctl kill'
	alias sysreloadall='sudo systemctl daemon-reload'
	alias boottime='systemd-analyze'
	alias syslistunits='sudo systemctl list-unit-files'
	alias sshd='sudo systemctl start sshd'
	alias dockerd='sudo systemctl start docker'
	alias mysqld='sudo systemctl start mysqld'
	alias tomcatd='sudo systemctl start tomcat10'
    alias dockerd='sudo systemctl start docker'
	alias mkinitcpio='sudo mkinitcpio'
	alias dmesg='sudo dmesg'
	
    
    # ==========================================
    # 垃圾清理配置区域
    # ==========================================
    
    alias journalclean='sudo journalctl --vacuum-size=0M && sudo journalctl --vacuum-time=0s && sudo rm -rf /var/log/*'
    alias cacheclean='sudo sync && sudo sysctl -w vm.drop_caches=3 && sudo rm -rf $HOME/.cache/* && history -c && rm -rf ~/.local/share/Trash/files/*'
    alias npmclean='sudo yarn cache clean && sudo npm cache clean --force && sudo pnpm store prune'
    alias pkgclean='sudo pacman -Scc --noconfirm && yay -Scc --noconfirm && sudo paccache -rk0'

    
    # ==========================================
    # 日常工作命令增强区域
    # ==========================================
    
    alias python='python3'
    alias py='python3'
    alias pip='pip3'
    alias h='history'
    alias als='alias'
    alias root='su root'
    alias tzgml='su tzgml'
    alias grubmk='sudo grub-mkconfig -o /boot/grub/grub.cfg'
    alias checkfcitx='fcitx5-diagnose'
    alias libhelp='/lib/ld-linux-x86-64.so.2 --help'
    alias btrfszip='sudo btrfs filesystem defragment -r -v -czstd /'
    alias diskinfo='sudo fdisk -l && df -h && lsblk'
    alias ducks='du -cksh * | sort -hr | head'  # 找出最大的文件/目录
    alias dusort='du -sh * | sort -hr'
    alias dush='du -sh'
    alias ting='httping'
    alias xlock='hyprlock -p'
    alias battery='upower -i $(upower -e | grep BAT) | grep percentage'
    alias gateway='ip route show default | awk '\''{print $3}'\'''
    alias pickcolor='hyprpicker -a'
    alias pickrgb='hyprpicker -a -f rgb'
    alias stopvnc='pkill -9 wayvnc && killall -9 wayvnc'
    alias startvnc='WLR_RDP_TX_CAPTURE_ALL_KEYS=1 wayvnc -v 0.0.0.0 5900'
    alias x='extract'
    alias man='tldr'
    alias chmodx='sudo chmod +x'
    
    function mine
        set -l user (whoami)
        for item in $argv
            if test -d $item
                sudo chown -R $user:$user $item
                echo "✓ $item/* → $user:$user"
            else
                sudo chown $user:$user $item
                echo "✓ $item → $user:$user"
            end
        end
    end
    

    
    function setproxy
        set -gx http_proxy "http://127.0.0.1:7897"
        set -gx https_proxy "http://127.0.0.1:7897"
        set -gx all_proxy "http://127.0.0.1:7897"  
        echo "🌐 HTTP 代理已设置: 127.0.0.1:7897"
    end
    
    function noproxy
        set -e http_proxy
        set -e https_proxy
        set -e all_proxy      
        echo "🚫 代理已禁用"
    end
        
        
        
    
     
    # ==========================================
    # 生产环境工具
    # ==========================================
    
    alias topcpu="ps -A -o %cpu,pid,user,comm | sort -nr | head -10"
    alias topmem="ps -A -o %mem,pid,user,comm | sort -nr | head -10"                        
    alias mktargz='tar -czvf'                      
    alias mktarbz2='tar -cjvf'                     
    alias untar='tar -xvf'
    alias untargz='tar -xzvf'
    alias untarbz2='tar -xjvf'
    alias flushdns='sudo resolvectl flush-caches'
    
    # 生成JWT密钥
    function genkey
        set -l key (openssl rand -base64 32)
        echo "🔑 $key" | tr -d '\n=' | tr '/+' '_-'
        echo 
    end

    
    # 压缩为tar
    # 不支持多级目录中的非常规（比如带空格）的目录名
    function mktar
        for target in $argv
            if not test -e "$target"
                echo "❌ 错误: '$target' 不存在，跳过"
                continue
            end
    
            set base_name (basename "$target")
            
            set tar_name "$base_name.tar"
            
            if test -e "$tar_name"
                read -l -P "'$tar_name' 已存在，覆盖？(y/N): " confirm
                if not test "$confirm" = "y" -o "$confirm" = "Y"
                    echo "⏭️ 跳过: $target (已存在 $tar_name)"
                    continue
                end
            end
    
            echo "📦 正在创建: $tar_name"
            if tar -cvf "$tar_name" "$target" 2>/dev/null
                echo "✅ 已创建: $tar_name"
            else
                echo "❌ 创建失败: $tar_name"
            end
        end
    end
    
    

    # 内部参数解析器
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
   
   # 查找文件 
   function findfile
       set parsed (_parse_find_args findfile $argv)
       or return $status
   
       set -l search_path $parsed[1]
       set -l pattern $parsed[2]
   
       command find "$search_path" -type f -iname "*$pattern*" 2>/dev/null | head -1000
   end
   
   # 查找目录
   function finddir
       set parsed (_parse_find_args finddir $argv)
       or return $status
   
       set -l search_path $parsed[1]
       set -l pattern $parsed[2]
   
       command find "$search_path" -type d -iname "*$pattern*" 2>/dev/null | head -500
   end
   
   # 查找文本
   function findtext
       set parsed (_parse_find_args findtext $argv)
       or return $status
   
       set -l search_path $parsed[1]
       set -l pattern $parsed[2]
   
       if command -q rg
           command rg --smart-case --hidden --no-ignore \
                     --max-depth 8 --max-filesize 10M \
                     --max-columns=150 \
                     --glob='!{.git,.svn,.hg,node_modules,build,target,dist,.cache,__pycache__,.DS_Store}' \
                     -- "$pattern" "$search_path" 2>/dev/null | head -500
       else
           echo "❌ 错误: 请安装 ripgrep (rg)" >&2
           return 127
       end
   end
   
   
   
   # 删除指定目录下所有空目录
   # 支持50层深度递归、; rm -rf ccd/;、`cmd`、$(cmd) 等逆天文件名，并发修改、特殊字符、软链接

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
   
   
   
   
    # 批量替换
     function replacetext
        # 存在 "foo|bar"， 参数"foo" "x|y"， 输出"x|y|bar" 
        # 存在 "hello.world"， 参数 "." "X" , 输出"XXXXXXXXXXX", 这不正常，要用Perl精确匹配
        # 存在 "a.*b"， 参数"a.*b" "X" , 输出"X"
        
        set -l file_pattern $argv[1]
        set -l old_string $argv[2]
        set -l new_string $argv[3]
        
        if test -z "$old_string"
            echo "❌ 错误：旧字符串不能为空" >&2
            return 1
        end
        
        set -l escaped_old (string replace -a '/' '\/' "$old_string")
        set -l escaped_old (string replace -a '|' '\|' "$escaped_old")
        set -l escaped_new (string replace -a '/' '\/' "$new_string")
        set -l escaped_new (string replace -a '|' '\|' "$escaped_new")
        
        find . -type f -name "$file_pattern" -exec sed -i "s|$escaped_old|$escaped_new|g" {} +
        
        echo "✅ 替换完成"
    end
    
    
    # 正则批量重命名
    # 参数：'-v([0-9]+)(\.[0-9]+)*' '_v$1' *.js   结果: lib-v3.1.4.js -> lib_v3.js, app-v0.9.js -> app_v0.js
    # 参数： '\s+' '_' *   结果: test file.txt -> test_file.txt
    # 参数： '\.JPG$' '.jpg' *    结果: IMG_001.JPG -> IMG_001.jpg
     
    function batchrename
        set -l regex $argv[1]
        set -l replacement $argv[2]
        set -l files $argv[3..-1]
        
        for file in $files
            if test -e "$file"
                set -l new_name (string replace -ra -- "$regex" "$replacement" "$file")
                if test -n "$new_name" -a "$file" != "$new_name"
                    mv -i "$file" "$new_name"  
                    echo "📝 Renamed: $file -> $new_name"
                end
            end
        end
    end
    
    # 手动一个个重命名
    function multirename
    # 直接用*匹配当前目录所有文件
        set files $argv
        for file in $files
            echo "📄 当前文件: $file"
            read -l -P "新文件名 (留空跳过，'q'退出): " new_name
            if test -z "$new_name"
                echo "⏭️ 跳过: $file"
            else if test "$new_name" = "q"
                echo "🚪 退出重命名"
                return
            else
                mv "$file" "$new_name"
                echo "✅ 已重命名: $file -> $new_name"
            end
            echo "---"
        end
    end
    
    
    # HTTP请求封装
    
    function post
        # post "https://uapis.cn/api/v1/search/aggregate"  '{"query":"archlinux","fetch_full":false}'
        set url $argv[1]
        set json $argv[2]
        
        set response (curl -s -X POST \
            -H "Content-Type: application/json" \
            -d "$json" \
            "$url")
        
        if command -q jq
            echo $response | jq .
        end
    end
    
    function postfile
        # postfile "https://uapis.cn/api/v1/image/nsfw" "file=@/home/tzgml/Pictures/wallpapers/Dynamic-Wallpapers/astronaut.jpg"
        # 为了让他能正常返回图片， 不应该用jq或yq再处理， 除非做判断
        set url $argv[1]        
        set -l cmd curl -s -X POST        
        for part in $argv[2..-1]
            set cmd $cmd -F "$part"
        end
        set cmd $cmd "$url"
    
        command $cmd
    end
    
    
    function get
        # get "https://uapis.cn/api/v1/answerbook/ask" "question='人生的意义是什么'"
        # get "https://uapis.cn/api/v1/convert/unixtime" "time=2023-10-27 10:30:00"
        # get "https://uapis.cn/api/v1/network/ping" 'host=baidu.com'
        set -l url "$argv[1]"

        if not string match -qr '^https?://' "$url"
            echo "❌ 必须要http:// 或 https:// 开头" >&2
            return 1
        end
        
        set -l cmd curl -s -f -m 10 -X GET \
            -H "User-Agent: http_get/1.0" \
            -H "Accept: application/json, */*" \
            -H "Accept-Encoding: gzip, deflate" \
            -w "\n%{http_code}" \
            -G
        
        for param in $argv[2..-1]
            if string match -qr '^[^=]+=' "$param"
                set cmd $cmd --data-urlencode "$param"
            else
                echo "⚠️ Warning: Skipping malformed parameter '$param'" >&2
            end
        end
        
        set cmd $cmd "$url"
        
        set -l response
        if not set response (command $cmd 2>&1)
            echo "❌ Error: Failed to execute curl" >&2
            return 1
        end
        
        set -l lines (count $response)
        if test $lines -lt 2
            echo "❌ Error: Invalid response from server" >&2
            return 1
        end
        
        set -l status_code $response[$lines]
        set -l body $response[1..(math $lines - 1)]
        
        if not string match -qr '^2[0-9][0-9]$' "$status_code"
            echo "🔴 HTTP $status_code" >&2            
            if test (count $body) -gt 0
                echo "Response:" (string join '\n' $body) >&2
            end
            
            return 1
        end
        
        if test (count $body) -eq 0
            return 0
        end
        
        if command -q jq
            echo "$body" | jq -e . 2>/dev/null
            or echo "$body"
        else
            echo "$body"
        end
    end
    
    
    
    
    # ==========================================
    # Pacman包管理器简化命令区域
    # ==========================================
    
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
        alias downgrade='sudo downgrade'
    

        alias yays='yay -S'
        alias yayss='yay -Ss'
        alias yaysyu='yay -Syu --noconfirm --disable-download-timeout'
        alias yaysyyu='yay -Syyu --noconfirm --disable-download-timeout'
        alias yayscc='yay -Scc'
        alias yayr='yay -R'
        alias yayrsn='yay -Rsn'
        alias installed='yay -Qeq' #列出显式安装的包名称（包括AUR）
        
        alias syu='yay -Syu --noconfirm --disable-download-timeout && fisher update && fish_update_completions'
        alias syyu='yay -Syyu --noconfirm --disable-download-timeout && fisher update  && fish_update_completions'
        alias yyu='yay -Syyu --noconfirm'
        alias yuu='yay -Syuu --noconfirm'
        alias syuu='yay -Syuu --noconfirm'

    
    function lastinstalled
        set -ql argv[1]; and set lines $argv[1]; or set lines 50
        grep -E '\[ALPM\] (installed|upgraded)' /var/log/pacman.log | tail -n $lines
    end
    
    function fileinpkg
        if test (count $argv) -eq 0
            echo "📦 用法: fileinpkg <包名>"
            return 1
        end
        
        yay -Qlq "$argv[1]" 2>/dev/null | grep -v '/$' | xargs -r du -h | sort -h
        if test $status -ne 0
            echo "❌ 包 '$argv[1]' 不存在或未安装"
            return 1
        end
    end
    
    function installfrom
        if test -z "$argv[1]"
            return 1
        end
    
        if not test -f "$argv[1]"
            echo "❌ File $argv[1] 不存在啊宝宝"
            return 1
        end
    
        grep -v '^#' "$argv[1]" | grep -v '^[[:space:]]*$' | xargs yay -S --needed --noconfirm
    end
    


# =============================================================================
#  Docker 别名
# =============================================================================

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
        set -g COMPOSE_CMD "docker-compose"
    else
        set -g COMPOSE_CMD "docker compose"
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
                    echo "❌ 容器 '$container' 不存在" >&2
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
            docker volume inspect --format '{{.Name}}|{{.Mountpoint}}' "$vol" 2>/dev/null
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
            set parts (string split '|' $info)
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
                set m_parts (string split '|' $mount)
                set cname (string trim --left --chars '/' "$m_parts[2]")
                
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
    # Git 命令增强区域
    # ==========================================

    if command -q git
        alias g='git'
        alias ginit='git init'
        alias gclone='git clone'
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
        alias gc1='git clone --recursive --depth=1'     # 浅克隆（只克隆最近一次提交）并递归克隆子模块
        alias gnewbranch='git checkout -b'
        alias gswitch='git switch'
        alias gsync='git pull origin'
        alias gsyncrebase='git pull --rebase origin'
        alias greset='git reset --hard'         # 后面跟哈希值
        alias grestore='git restore'            # 恢复成最新一次commit后的状态
        alias grestorestaged='git restore --staged'     # 不add了,从暂存区撤出，不会改变文件
        alias gclean='git clean -fd'        # 强制删除所有未跟踪的文件和目录
        alias gtag='git tag'
        alias gstash='git stash'            # 暂存当前的修改，方便切换到别的分支或git clean
        alias gstashpop='git stash pop'     #  恢复之前暂存的修改
        alias gstashlist='git stash list'  
        alias gremote='git remote'
        alias gremoteadd='git remote add'
        alias gremoteurl='git remote set-url'
        alias gprune='git remote prune origin'      # 清理本地仓库中已失效的远程跟踪分支（origin上已删除的分支）

        # 显示最近提交，输入哈希值查看文件修改细节
        function gwhatchange
            git log --oneline | head -20
            echo -n "📝 输入哈希值查看文件: "
            read -l hash
            if test -n "$hash"
                git show $hash
            end
        end

    end
    
    # ==========================================
    # MySQL 命令区域
    # ==========================================
    if command -q mysql
        alias mysql='mysql -u root -p'
        alias listdb='mysql -u root -p -e "SHOW DATABASES;"'
        alias backupdb='mysqldump -u root -p --single-transaction --routines --triggers --events'   # backupdb myDbName > xx.sql
    end
    
    # ==========================================
    # 文件管理增强区域
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
    # 错误修正配置区域
    # ==========================================
    
    alias sl='ls -a'
    alias lz='ls'
    alias s='ls -a'
    alias sls='ls -a'
    alias ayy='yay'
    alias yya='yay'
    alias yyy='yay'
    alias sduo='sudo'
    alias systecmtl='sudo systemctl'
    

    
    # ==========================================
    # kitten 别名区域
    # ==========================================
    if command -q kitty
        alias catimg='kitten icat'
        alias diff='kitten diff'
        alias getclip='kitten clipboard --get-clipboard'
        
        function setclip
            if set -q argv[1]
                if test -f "$argv[1]"
                    cat "$argv[1]" | kitten clipboard
                else
                    echo "$argv" | kitten clipboard
                end
            else
                kitten clipboard
            end
        end
    end
        
    
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
    # uniapp
    function buildwx
        if yarn run build:mp-weixin
            wechat-devtools-cli open --project (pwd)/dist/build/mp-weixin
        else
            echo "编译失败！" >&2
            return 1
        end
    end
    
    
    # ==========================================
    # 一些函数
    # ==========================================
    
    alias back='prevd'
    alias prev='prevd'
    alias next='nextd'
    
    
    function mkcd
        if not test (count $argv) -eq 1
            echo "📝 用法: mkcd 'My Directory'" >&2
            return 1
        end
        
        mkdir -p $argv[1]
        and cd $argv[1]
        or begin
            echo "❌ 创建目录失败: $argv[1]" >&2
            return 1
        end
    end
    
    
   function fish_command_not_found
       if command -v pkgfile >/dev/null
           set -l result (pkgfile -b "$argv[1]" 2>/dev/null | head -1)
           if test -n "$result"
               echo "📦 需要 `sudo pacman -S $result`" >&2
           else
               echo "💭 宝宝不要再说胡话了~~" >&2
           end
       else
           echo '📦 需要 sudo pacman -S pkgfile && sudo pkgfile -u'
       end
       return 127
   end

   
   # ==========================================
   # 个人配置
   # ==========================================
   
   
   set -gx EDITOR /usr/bin/micro
   set -gx VISUAL /usr/bin/micro
   
  
   if command -v fastfetch > /dev/null
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






























