# ==========================================
# OH-MY-ZSH 配置区域
# ==========================================

# 设置 ZSH 和主题
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="ys"

# 启用插件
plugins=(
    git
    archlinux
    zsh-autosuggestions
    zsh-syntax-highlighting
    fzf-tab
    command-not-found
    extract
    z
    sudo
    spring
    vscode
    web-search
)

source $ZSH/oh-my-zsh.sh

# ==========================================
# 启动画面配置区域
# ==========================================

# 异步执行启动画面
{
  pokemon-colorscripts --no-title -s -r | fastfetch -c $HOME/.config/fastfetch/config-pokemon.jsonc --logo-type file-raw --logo-height 10 --logo-width 5 --logo -
} &|

# 初始化 FZF
source <(fzf --zsh)

# ==========================================
# 历史记录配置区域
# ==========================================

export HISTFILE=$ZDOTDIR/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"

# ==========================================
# 目录导航与补全配置区域
# ==========================================

# 目录导航和补全增强
setopt AUTOCD              # 只输入目录名即可跳转
setopt PROMPT_SUBST        # 允许提示符使用命令替换
setopt MENU_COMPLETE       # 自动高亮补全菜单的第一个选项
setopt LIST_PACKED         # 紧凑的补全菜单
setopt AUTO_LIST           # 自动列出补全选项
setopt COMPLETE_IN_WORD    # 在单词内部补全
setopt cdable_vars         # 支持变量作为目录参数

# ==========================================
# 命令未找到处理器区域
# ==========================================

# 命令未找到处理器
command_not_found_handler() {
    pkgfile "$1" 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "耶！！！命令 '$1' 可以在软件包中找到。"
    else
        echo "宝宝不要再说胡话了" | lolcat
    fi
    return 127
}

# ==========================================
# 实用函数定义区域
# ==========================================

# 实用函数
function cdls() {
    builtin cd "$1" && ls
}

function mkcd() {
    mkdir -p "$1" && cd "$1"
}

# ==========================================
# 目录跳转快捷方式区域
# ==========================================

# 高效的目录跳转
alias ...=../..
alias ....=../../..
alias .....=../../../..
alias ......=../../../../..
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'
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
alias wabardir='cd $HOME/.config/waybar'

# ==========================================
# 配置文件编辑快捷方式区域
# ==========================================

# 快速编辑配置文件
alias zshrc='nvim $HOME/.zshrc'
alias bashrc='nvim $HOME/.bashrc'
alias kittyconf='nvim $HOME/.config/kitty/kitty.conf'
alias hyprconf='nvim $HOME/.config/hypr/hyprland.conf'
alias nvimconf='nvim $HOME/.config/nvim/init.lua'
alias pacmanconf='sudo nvim /etc/pacman.conf'
alias localeconf='sudo nvim /etc/locale.gen'
alias systemconf='sudo nvim /etc/systemd/system.conf'
alias journalconf='sudo nvim /etc/systemd/journald.conf'
alias journaldconf='sudo nvim /etc/systemd/journald.conf'

# ==========================================
# 系统服务控制区域
# ==========================================

# 系统服务控制
alias sysinfo='fastfetch | lolcat && uname -a | lolcat && hostnamectl | lolcat && localectl && timedatectl'
alias systemctl='sudo systemctl'
alias sysctl='sudo sysctl'
alias sysenable='sudo systemctl enable --now'
alias sysdisable='sudo systemctl disable --now'
alias sysstart='sudo systemctl start'
alias sysrestart='sudo systemctl restart'
alias sysstop='sudo systemctl stop'
alias sysstatus='sudo systemctl status'
alias syskill='sudo systemctl kill'
alias sysreload='sudo systemctl reload'
alias sysreloadall='sudo systemctl daemon-reload'
alias sysanalyze='systemd-analyze'
alias boottime='systemd-analyze'
alias syslistunits='sudo systemctl list-unit-files'
alias sshd='sudo systemctl enable --now sshd'
alias mysqld='sudo systemctl enable --now mysqld'
alias tomcatd='sudo systemctl start tomcat10'
alias mkinitcpio='sudo mkinitcpio'
alias dmesg='sudo dmesg'

# ==========================================
# 垃圾清理配置区域
# ==========================================

# 垃圾清理
alias journalclean='sudo journalctl --vacuum-size=0M && sudo journalctl --vacuum-time=0s && sudo rm -rf /var/log/*'
alias cacheclean='sudo sync && sudo sysctl -w vm.drop_caches=3 && sudo rm -rf $HOME/.cache/* && history -c'
alias npmclean='sudo yarn cache clean && sudo npm cache clean --force && sudo pnpm store prune'
alias pkgclean='sudo pacman -Scc --noconfirm && yay -Scc --noconfirm && sudo paccache -rk0'
alias fileclean='sudo rm -rf ~/.local/share/recently-used.xbel'

# ==========================================
# 日常工作命令增强区域
# ==========================================

# 日常工作命令增强
alias python='python3'
alias py='python3'
alias pip='pip3'
alias exp='export'
alias h='history'
alias als='alias'
alias vport='export http_proxy="http://127.0.0.1:7897" && export https_proxy="http://127.0.0.1:7897" && export all_proxy="socks://127.0.0.1:7897"'
alias noproxy='unset http_proxy && unset https_proxy && unset all_proxy'
alias _='sudo '
alias grep='egrep --color=auto -i'
alias vim='sudo nvim'
alias root='su root'
alias tzgml='su tzgml'
alias grubmk='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias grubmkconfig='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias grubupdate='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias grubconf='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias updategrub='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias checkfcitx='fcitx5-diagnose'
alias fcitxcheck='fcitx5-diagnose'
alias libhelp='/lib/ld-linux-x86-64.so.2 --help'
alias btrfszip='sudo btrfs filesystem defragment -r -v -czstd /'
alias disk='sudo fdisk -l && df -h && lsblk'
alias 777='sudo chmod 777'
alias 755='sudo chmod 755'
alias 644='sudo chmod 644'
alias chmodx='sudo chmod +x'
alias chmodall='sudo chmod -R 777 *'
alias changeuser='sudo chown -R $USER:$USER'
alias ducks='du -cksh * | sort -hr | head'  # 找出最大的文件/目录
alias dusort='du -sh * | sort -hr'
alias dush='du -sh'
alias ting='httping'
alias xlock='hyprlock -p'


# ==========================================
# 系统信息查询区域
# ==========================================

alias topcpu='ps aux | sort -rnk3 | head -10'  # 查看占用CPU最高的进程
alias topmem='ps aux | sort -rnk4 | head -10'  # 查看占用内存最高的进程
alias publicip='curl ipinfo.io/ip'                 # 查看公网IP
alias localip="ip route get 1.1.1.1 | awk '{print \$7}'"  # 查看本地IP
alias findfile='find . -type f -name'          # 在当前目录查找文件
alias finddir='find . -type d -name'           # 在当前目录查找目录
alias findtext='grep -r -i -n --color=always'  # 在文件中递归搜索文本
alias week='date +%V'                          # 查看今年第几周
alias mktar='tar -cvf'                         # 创建 tar 归档
alias mktargz='tar -czvf'                      # 创建 tar.gz 归档
alias mktarbz2='tar -cjvf'                     # 创建 tar.bz2 归档
alias uptime='uptime -p'                               # 显示运行时间
alias useradd='sudo useradd -m -G wheel,video,audio -s /bin/zsh'  # 添加用户并创建主目录、加入常用组、设置默认shell

# ==========================================
# 包管理器简化命令区域 - Pacman
# ==========================================

# Pacman 命令
alias pac='sudo pacman'
alias pacs='sudo pacman -S'
alias pacss='sudo pacman -Ss'
alias pacsyu='sudo pacman -Syu --noconfirm'
alias pacsyyu='sudo pacman -Syyu --noconfirm'
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

# ==========================================
# 包管理器简化命令区域 - Yay
# ==========================================

# Yay 命令
alias yays='yay -S'
alias yayss='yay -Ss'
alias yaysyu='yay -Syu --noconfirm'
alias yaysyyu='yay -Syyu --noconfirm'
alias yayscc='yay -Scc'
alias yayr='yay -R'
alias yayrsn='yay -Rsn'
alias installed='yay -Qeq' #列出显式安装的包名称（包括AUR）

function fileinpkg(){
    yay -Qlq "$1" | grep -v '/$' | xargs -r du -h | sort -h
}

function installfrom(){
    if [ -z "$1" ]; then
        return 1
    fi

    if [ ! -f "$1" ]; then
        echo "File $1 不存在啊宝宝"
        return 1
    fi

    grep -v '^#' "$1" | grep -v '^[[:space:]]*$' | xargs yay -S --needed --noconfirm
}

# ==========================================
# Git 命令增强区域
# ==========================================

# Git 命令增强
alias g='git'
alias pushremote='git add . && git commit -m "update" && git pull origin master && git push origin master'
alias gc1='git clone --recursive --depth=1'

# ==========================================
# MySQL 命令区域
# ==========================================

# MySQL 命令
alias mysql='mysql -u root -p'
alias sqlinit='sudo mysqld --initialize --user=mysql --basedir=/usr --datadir=/var/lib/mysql'
alias sqlsecure='mysql_secure_installation'

# ==========================================
# 文件管理增强区域
# ==========================================

# 文件管理增强
if command -v eza >/dev/null 2>&1; then
    DISABLE_LS_COLORS=true
    alias ls="eza --color=auto --icons" 
    alias l='eza -lbah --icons'
    alias la='eza -labgh --icons'
    alias ll='eza -lbg --icons'
    alias lsa='eza -lbagR --icons'
    alias lst='eza -lTabgh --icons'
elif command -v exa >/dev/null 2>&1; then
    DISABLE_LS_COLORS=true
    alias ls="exa --color=auto --icons" 
    alias l='exa -lbah --icons'
    alias la='exa -labgh --icons'
    alias ll='exa -lbg --icons'
    alias lsa='exa -lbagR --icons'
    alias lst='exa -lTabgh --icons'
else
    alias ls='ls --color=auto'
    alias lst='tree -pCsh'
    alias l='ls -lah'
    alias la='ls -lAh'
    alias ll='ls -lh'
    alias lsa='ls -lah'
fi

# ==========================================
# Bat 配置区域
# ==========================================

# Bat 配置
if command -v bat >/dev/null 2>&1; then
    alias cat='bat -pp'
    export BAT_PAGER="less -m -RFQ"
    export BAT_THEME="GitHub"
elif command -v batcat >/dev/null 2>&1; then
    alias cat='batcat -pp'
    export BAT_PAGER="less -m -RFQ"
    export BAT_THEME="GitHub"
fi

# ==========================================
# 错误修正配置区域
# ==========================================

# 防止常见错误
alias sl='ls -a'
alias s='ls -a'
alias sls='ls -a'
alias sduo='sudo'
alias systecmtl='sudo systemctl'

# ==========================================
# 屏幕取色配置区域
# ==========================================

# 屏幕取色
alias pickcolor='hyprpicker -a'
alias pickrgb='hyprpicker -a -f rgb'

# ==========================================
# 安全配置区域
# ==========================================

# 安全配置
if [ -x "/usr/local/bin/safe-rm" ]; then
    alias rm="/usr/local/bin/safe-rm"
    
    sudo() {
        local all_args="$*"
        if [[ "$all_args" =~ rm\ -[rf]+\ [/\*] ]]; then
            printf '禁止删除根目录！\n'
            return 1
        fi
        command sudo "$@"
    }
fi

# ==========================================
# 补全优化配置区域
# ==========================================

# 补全优化
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:*:*:*:descriptions' format '%F{blue}%B--- %d ---%b%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}%B--- %d (errors: %e) ---%b%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
autoload -Uz compinit && compinit

# ==========================================
# 终端工具增强区域
# ==========================================

# 终端工具增强
alias catimg='kitten icat'
alias icat='kitten icat'
alias diff='kitten diff'
alias cat='bat'

# ==========================================
# 其他工具命令区域
# ==========================================

# 包管理器简化命令
alias syu='yay -Syu --noconfirm'
alias syyu='yay -Syyu --noconfirm'
alias yyu='yay -Syyu --noconfirm'
alias yuu='yay -Syuu --noconfirm'
alias syuu='yay -Syuu --noconfirm'
alias getmirrors='echo "
清华源:
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch
中科大源:
Server = https://mirrors.ustc.edu.cn/archlinuxcn/$arch
北大源:
Server = https://mirrors.pku.edu.cn/archlinuxcn/$arch
腾讯云: 
Server = https://mirrors.cloud.tencent.com/archlinuxcn/$arch
阿里云: 
Server = https://mirrors.aliyun.com/archlinuxcn/$arch"'


# ==========================================
# 个人配置
# ==========================================




# 莹轩历转换函数
yingyear() {
    local current_year=$(date +%Y)
    local current_month=$((10#$(date +%m)))  
    local current_day=$((10#$(date +%d)))    

    local L=0
    for ((y=2020; y < current_year; y++)); do
        if (( (y % 4 == 0 && y % 100 != 0) || (y % 400 == 0) )); then
            ((L++))
        fi
    done

    local months=(31 28 31 30 31 30 31 31 30 31 30 31)  #
    if (( (current_year % 4 == 0 && current_year % 100 != 0) || (current_year % 400 == 0) )); then
        months[1]=29  
    fi
    local S=0
    for ((m=1; m < current_month; m++)); do
        ((S += months[m-1])) 
    done

    local delta_T=$(( 
        (current_year - 2020) * 365 + 
        L + 
        S + 
        (current_day - 1) 
    ))

    local V=$(echo "scale=10; 1895 + ($delta_T * 18) / 365" | bc)

    local Y莹=$(echo "$V" | awk -F '.' '{print $1}')  
    local f=$(echo "scale=10; $V - $Y莹" | bc)     

    local f_times_12=$(echo "scale=10; $f * 12" | bc)
    local month_int=$(echo "$f_times_12" | awk -F '.' '{print $1}')  
    local M莹=$((month_int + 1))  

    local remainder=$(echo "scale=10; $f_times_12 - $month_int" | bc)  
    local remainder_times_30=$(echo "scale=10; $remainder * 30" | bc)
    local day_int=$(echo "$remainder_times_30" | awk -F '.' '{print $1}')  
    local D莹=$((day_int + 1))  

 
    echo "   今天是莹轩${Y莹}年${M莹}月${D莹}日！"
}







# 显示每日一言
figlet -f big "        TZGML" | lolcat

yingyear | lolcat
# 伪一言
echo " \n   每日一言 | Hitokoto 驱动: \n     不自由，毋宁死！ ———— 帕特里克·亨利 于(1775)  " | lolcat






