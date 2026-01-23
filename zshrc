# 设置 ZSH 和主题
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="ys"

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
{
  pokemon-colorscripts --no-title -s -r | fastfetch -c $HOME/.config/fastfetch/config-pokemon.jsonc --logo-type file-raw --logo-height 10 --logo-width 5 --logo -
} &|


source <(fzf --zsh)

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"

setopt AUTOCD              # 只输入目录名就可以跳转
setopt PROMPT_SUBST        # 允许提示词命令替换
setopt MENU_COMPLETE       # 自动高亮第一个元素的补全按钮
setopt LIST_PACKED         # 补全菜单更少的占用空间
setopt AUTO_LIST           # 自动列出模棱两可的补全
setopt COMPLETE_IN_WORD    # 从单词两端补全
setopt cdable_vars


command_not_found_handler() {
    printf "宝宝不要再说胡话了\n" | lolcat
    return 127
}


function cdls() {
    builtin cd "$1" && ls
}

function mkcd() {
    mkdir -p "$1" && cd "$1"
}





# 目录快速跳转
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
alias sysinfo='fastfetch | lolcat && uname -a | lolcat &&  hostnamectl | lolcat && localectl && timedatectl' #显示系统信息
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

# 垃圾清理
alias journalclean='sudo journalctl --vacuum-size=0M && sudo journalctl --vacuum-time=0s && sudo rm -rf /var/log/*'
alias cacheclean='sudo sync && sudo sysctl -w vm.drop_caches=3 && sudo rm -rf $HOME/.cache/* && history -c'
alias npmclean='sudo yarn cache clean && sudo npm cache clean --force && sudo pnpm store prune'
alias pkgclean='sudo pacman -Scc  --noconfirm && yay -Scc --noconfirm && sudo paccache -rk0'
alias fileclean='sudo rm -rf ~/.local/share/recently-used.xbel'

# 其他简化命令
alias python='py'
alias exp='export'
alias h='history'
alias als='alias'
alias vport='export http_proxy="http://127.0.0.1:7897" && export https_proxy="http://127.0.0.1:7897" && export all_proxy="socks://127.0.0.1:7897"'
alias noproxy='unset http_proxy && unset https_proxy && unset all_proxy'
alias _='sudo '
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias gc1='git clone --recursive --depth=1'
alias globurl='noglob urlglobber '
alias grep='grep --color=auto'
alias vim='nvim'
alias tp='sudo trash-put'
alias tpall='sudo trash-put *'
alias te='sudo trash-empty'
alias tr='trash-restore'
alias root='su root'
alias tzgml='su tzgml'
alias grubmk='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias grubmkconfig='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias grubupdate='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias grubconf='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias updategrub='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias checkfcitx='fcitx5-diagnose'
alias fcitxcheck='fcitx5-diagnose'
alias kernelversion='/lib/ld-linux-x86-64.so.2 --help'
alias btrfszip='sudo btrfs filesystem defragment -r -v -czstd /'
alias disk='sudo fdisk -l && df -h && lsblk'
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

# 终端专用工具
alias catimg='kitten icat'
alias icat='kitten icat'
alias diff='kitten diff'
alias cat='bat'

# 包管理器简化
alias pac='sudo pacman'
alias pacman='sudo pacman'
alias pacs='sudo pacman -S'
alias pacss='sudo pacman -Ss'
alias pacsyu='sudo pacman -Syu --noconfirm'
alias pacsyyu='sudo pacman -Syyu --noconfirm'
alias pacscc='sudo pacman -Scc'
alias pacu='sudo pacman -U'
alias pacqdt='sudo pacman -Qdt'
alias pacqi='sudo pacman -Qi'
alias pacqs='sudo pacman -Qs'
alias pacq='sudo pacman -Q'
alias pacsi='sudo pacman -Si'
alias pacr='sudo pacman -R'
alias pacrsn='sudo pacman -Rsn'
alias pacrscn='sudo pacman -Rscn'
alias pacall="sudo pacman -S \$(pacman -Qnq) --overwrite /'*/'"
alias yays='yay -S'
alias yayss='yay -Ss'
alias yaysyu='yay -Syu --noconfirm'
alias yaysyyu='yay -Syyu --noconfirm'
alias yayscc='yay -Scc'
alias yayu='yay -U'
alias yayqdt='yay -Qdt'
alias yayqi='yay -Qi'
alias yayqs='yay -Qs'
alias yayq='yay -Q'
alias yaysi='yay -Si'
alias yayr='yay -R'
alias yayrsn='yay -Rsn'
alias yayrscn='yay -Rscn'

# Git 命令简化
alias g='git'
alias ginit='git init'
alias gi='git init'
alias gs='git status' 
alias gstatus='git status'
alias ga='git add'
alias gadd='git add'
alias gc='git commit -m'
alias gcommit='git commit -m'
alias glog='git log' 
alias gb='git branch'
alias gbranch='git branch'
alias gbm='git branch -m'
alias gbranchm='git branch -m'
alias gbranchd='git branch -d'
alias gbranchD='git branch -D'
alias gck='git checkout'
alias gcheckout='git checkout'
alias gcheckoutb='git checkout -b'
alias gam='git commit -am'
alias gcam='git commit -am'
alias gcommitam='git commit -am'
alias gm='git merge'
alias gmerge='git merge'
alias clone='git clone'
alias gclone='git clone'
alias gr='git remote'
alias grv='git remote -v'
alias gra='git remote add'
alias gurl='git remote set-url'
alias gp='git push'
alias gpf='git push -f'
alias gpush='git push'
alias gf='git fetch'
alias gd='git diff'
alias gpl='git pull'
alias gl='git pull'
alias gpull='git pull'

# MySQL 命令简化
alias mysql='mysql -u root -p'
alias sqlinit='sudo mysqld --initialize --user=mysql --basedir=/usr --datadir=/var/lib/mysql'
alias sqlsecure='mysql_secure_installation'


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


if command -v bat >/dev/null 2>&1; then
    alias cat='bat -pp'
    export BAT_PAGER="less -m -RFQ"
elif command -v batcat >/dev/null 2>&1; then
    alias cat='batcat -pp'
    export BAT_PAGER="less -m -RFQ"
fi

# 兼容 DOS 命令
alias md='mkdir -p'
alias rd='rmdir'
alias cls='clear'
alias dir='ls'
alias copy='cp'
alias move='mv' #移动
alias ren='mv'  #改名
alias del='rm -i'
alias taskkill='kill'
alias ipconfig='ifconfig'
alias netsh='ifconfig' #设置网络，如ip,dns
alias tasklist='top' #查看进程列表
alias sh='start' #启动可执行文件
alias net='sudo systemctl' #服务控制
alias wintype='cat' #win下的type命令
alias shutdown='poweroff' # 关机
alias chkdsk='sudo fdisk -l && df -h && lsblk'  #查看磁盘状态
alias format='mkfs' #格式化设备
alias xcopy='cp -r' #连带着子目录复制
alias attrib='chattr'  #+i 让文件怎么都不会被修改或删除，取消则-i
alias defrag='e4defrag' #磁盘碎片整理
alias subst='ln -s' #win下是将一个磁盘映射到另一个磁盘的某个目录访问
alias doskey='alias'  #win下doskey还可以重写命令，编辑历史命令列表
alias winfc='diff'  #win下的fc,比较文件不同
alias comp='diff'  #win下交互式比较文件
alias systeminfo='fastfetch | lolcat && uname -a | lolcat &&  hostnamectl | lolcat' #显示系统信息
alias notepad='nvim' #win下记事本
alias icacls='chmod' #win下可以更改权限和所有者
alias perfmon='glances' #系统性能监视工具，可以替换成其他工具
alias clip='wl-copy' #把命令输出重定向到剪贴板，x11下是xclip
alias dos='bash' #bash比喻为dos,zsh比喻为powershell
alias powershell='zsh'

# 兼容 macOS 命令
alias brew='apt'
alias open='sh' #mac用来打开软件
alias xlock='hyprlock -q' # x11下是xlock,但我是hyprland

# 防止输错
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
            printf '禁止删除！'
            return 1
        fi
        command sudo "$@"
    }
fi

# 添加到 PATH
export PATH="$PATH:$HOME/bin:$HOME/.local/bin"

# 自动补全优化
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
autoload -Uz compinit && compinit

# 显示每日一言
figlet -f big "        TZGML" | lolcat

# 伪一言
echo "    每日一言 | Hitokoto 驱动: \n     不自由，毋宁死！ ———— 帕特里克·亨利 于(1775)  " | lolcat