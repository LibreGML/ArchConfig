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

# 异步执行启动画面
{
  pokemon-colorscripts --no-title -s -r | fastfetch -c $HOME/.config/fastfetch/config-pokemon.jsonc --logo-type file-raw --logo-height 10 --logo-width 5 --logo -
} &|

# 初始化 FZF
source <(fzf --zsh)

# 历史记录配置
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

# 目录导航和补全增强
setopt AUTOCD              # 只输入目录名即可跳转
setopt PROMPT_SUBST        # 允许提示符使用命令替换
setopt MENU_COMPLETE       # 自动高亮补全菜单的第一个选项
setopt LIST_PACKED         # 紧凑的补全菜单
setopt AUTO_LIST           # 自动列出补全选项
setopt COMPLETE_IN_WORD    # 在单词内部补全
setopt cdable_vars         # 支持变量作为目录参数

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

# 实用函数
function cdls() {
    builtin cd "$1" && ls
}

function mkcd() {
    mkdir -p "$1" && cd "$1"
}

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

# 系统服务控制
alias sysinfo='fastfetch | lolcat && uname -a | lolcat && hostnamectl | lolcat && localectl && timedatectl'
alias systemctl='sudo systemctl'
alias sysenable='sudo systemctl enable --now'
alias sysdisable='sudo systemctl disable'
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

# 垃圾清理
alias journalclean='sudo journalctl --vacuum-size=0M && sudo journalctl --vacuum-time=0s && sudo rm -rf /var/log/*'
alias cacheclean='sudo sync && sudo sysctl -w vm.drop_caches=3 && sudo rm -rf $HOME/.cache/* && history -c'
alias npmclean='sudo yarn cache clean && sudo npm cache clean --force && sudo pnpm store prune'
alias pkgclean='sudo pacman -Scc --noconfirm && yay -Scc --noconfirm && sudo paccache -rk0'
alias fileclean='sudo rm -rf ~/.local/share/recently-used.xbel'

# 日常工作命令增强
alias python='python3'
alias pip='pip3'
alias exp='export'
alias h='history'
alias als='alias'
alias vport='export http_proxy="http://127.0.0.1:7897" && export https_proxy="http://127.0.0.1:7897" && export all_proxy="socks://127.0.0.1:7897"'
alias noproxy='unset http_proxy && unset https_proxy && unset all_proxy'
alias _='sudo '
alias grep='egrep --color=auto -i'
alias gc1='git clone --recursive --depth=1'
alias vim='nvim'
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

# 包管理器简化命令
alias syu='yay -Syu --noconfirm'
alias syyu='yay -Syyu --noconfirm'
alias yyu='yay -Syyu --noconfirm'
alias yuu='yay -Syuu --noconfirm'
alias syuu='yay -Syuu --noconfirm'
alias getmirrors='echo "北外源:
Server = https://mirrors.bfsu.edu.cn/archlinuxcn/$arch
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
alias ducks='du -cksh * | sort -hr | head'  # 找出最大的文件/目录
alias dusort='du -sh * | sort -hr'
alias dush='du -sh'
alias chmodall='chmod -R 777 *'
alias ting='httping'
alias xlock='hyprlock -p'

# 终端工具增强
alias catimg='kitten icat'
alias icat='kitten icat'
alias diff='kitten diff'
alias cat='bat'


# 包管理器简化（分组优化）
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

# Git 命令增强
alias g='git'
alias pushremote='git add . && git commit -m "update" && git pull origin master && git push origin master'

# MySQL 命令
alias mysql='mysql -u root -p'
alias sqlinit='sudo mysqld --initialize --user=mysql --basedir=/usr --datadir=/var/lib/mysql'
alias sqlsecure='mysql_secure_installation'

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

# 防止常见错误
alias sl='ls -a'
alias s='ls -a'
alias sls='ls -a'
alias sduo='sudo'

# 屏幕取色
alias pickcolor='hyprpicker -a'
alias pickrgb='hyprpicker -a -f rgb'

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

# 添加路径
export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/.cargo/bin:$HOME/go/bin"

# 补全优化
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:*:*:*:descriptions' format '%F{blue}%B--- %d ---%b%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}%B--- %d (errors: %e) ---%b%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
autoload -Uz compinit && compinit



# 显示每日一言
figlet -f big "        TZGML" | lolcat

# 伪一言
echo "    每日一言 | Hitokoto 驱动: \n     不自由，毋宁死！ ———— 帕特里克·亨利 于(1775)  " | lolcat