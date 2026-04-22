#!/bin/bash

# =============================================================================
# ArchConfig 一键安装脚本
# =============================================================================
# 描述：自动安装所有依赖并部署配置文件
# 维护者：libregml <1778607946@qq.com>
# 注意：此脚本应以普通用户身份运行，仅在需要时使用 sudo
# 我已经在docker测试过一遍了，请放心使用
# =============================================================================

# =============================================================================
# 日志函数
# =============================================================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

log() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }
info() { echo -e "${CYAN}[INFO]${NC} $1"; }

# =============================================================================
# 获取当前用户信息（脚本以普通用户运行）
# =============================================================================
CURRENT_USER=$(whoami)
CURRENT_USER_HOME="$HOME"

# 验证用户不是 root
if [ "$CURRENT_USER" = "root" ]; then
    error "请不要以 root 身份运行此脚本！"
    error "请以普通用户身份运行，脚本会在需要时请求 sudo 权限"
    exit 1
fi

success "当前用户：$CURRENT_USER ($CURRENT_USER_HOME)"

# =============================================================================
# 获取脚本所在目录（全局变量）
# =============================================================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# =============================================================================
# 创建软链接函数（全局函数）
# =============================================================================
create_symlink() {
    local src="$1"
    local dst="$2"
    
    case "$dst" in
        "$CURRENT_USER_HOME"|"$CURRENT_USER_HOME"/*)
            ;;
        *)
            error "拒绝创建符号链接：目标路径 $dst 不在用户家目录下"
            return 1
            ;;
    esac
    
    local parent_dir=$(dirname "$dst")
    mkdir -p "$parent_dir"
    
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        rm -rf "$dst"
        log "已移除旧配置：$dst"
    fi
    
    ln -s "$src" "$dst"
    success "已链接：$dst -> $src"
}

# =============================================================================
# 检测 yay 是否安装
# =============================================================================
check_yay() {
    if ! command -v yay &>/dev/null; then
        log "未检测到 yay, 正在安装..."
        if sudo pacman -S --noconfirm yay; then
            success "yay 安装成功"
            sudo pacman -Sy --noconfirm 2>/dev/null || true
        else
            error "yay 安装失败"
            exit 1
        fi
    else
        success "yay 已安装"
    fi
}

# =============================================================================
# 安装核心依赖
# =============================================================================
install_core_deps() {
    log "=========================================="
    log "安装核心依赖..."
    log "=========================================="
    
    local deps=(
        'hyprland'             
        'hyprlock'              
        'hypridle'             
        'hyprland-guiutils'
        'hyprtoolkit'
        'hyprutils'
        'hyprland-qt-support'
        'hyprgraphics'
        'hyprcursor'
        'hyprlang'
        'hyprwire'
        'hyprwayland-scanner'
        'hyprpolkitagent'         
        'kitty'                
        'fish'                 
        'fisher'                
        'waybar'               
        'swaync'               
        'rofi'                   
        'thunar'                 
        'thunar-archive-plugin'
        'thunar-volman'
        'micro'                 
        'fcitx5'               
        'fcitx5-chinese-addons'  
        'fcitx5-configtool'
        'fcitx5-gtk'
        'fcitx5-qt'
        'awww'                 
        'cliphist'             
        'wl-clip-persist'        
        'fastfetch'            
        'pyprland'             
        'wlogout'               
        'firefox-developer-edition'
        'fzf'
        'swappy'
        'grim'
        'slurp'
        'ttf-fira-code'
        'ttf-jetbrains-mono'
        'ttf-victor-mono-nerd'
        'noto-fonts'
        'noto-fonts-cjk'
        'noto-fonts-emoji'
        'hyprpicker'
        'eza'
        'ripgrep'
        'nodejs'
        'npm'
        'jdk21-openjdk'
        'ntfs-3g'
        'btop'
        'android-tools'
        'clash-verge-rev'
        'mihomo'
        'efibootmgr'
        'httping'
        'network-manager-applet'
        'pkgfile'
        'sddm'
        'xarchiver'
        'xdg-desktop-portal-hyprland'
        'xdg-desktop-portal-gtk'
        'zram-generator'
        'alsa-firmware'
        'alsa-ucm-conf'
        'pipewire'
        'pipewire-alsa'
        'wireplumber'
        'libwireplumber'
        'mesa'
        'vulkan-radeon'
        'lib32-mesa'
        'lib32-vulkan-radeon'
        'xf86-video-amdgpu'
        'gtk-engine-murrine'
        'qt5-quickcontrols2'
        'qt5ct'
        'qt6-wayland'
        'qt6ct'
        'amd-ucode'
        'btrfs-progs'
        'pacman-contrib'
        'bluez'
        'bluez-utils'
        'blueman'
        'sof-firmware'
        'less'
        'cups'
        'cups-filters'
        'ghostscript'
        'tree'
        'imagemagick'
        'pbzip2'
        'pigz'
        'lzop'
        'lzip'
        'ncompress'
        'pv'
        'tumbler'
        'mpv'
        'mpv-mpris'
        'loupe'
        'ffmpeg'
        'ffmpegthumbnailer'
        'net-tools'
        'libspng'
        'obs-studio'
        'tldr'
        'syncthing'
        'tlp' 
        'tlp-rdw'
        'tlpui' 
        'powertop' 
        'docker'
        'docker-compose'
        'lazydocker'
        'localsend'
        'nginx'
        'hyprshot'
        'cava'
        'yazi'
        '7zip'
        'jq'
        'poppler'
        'fd'
        'resvg'
        'kvantum'
        'kvantum-qt5'
        'yad'
        'nwg-look'
        'network-manager-applet'
        'gvfs-mtp'
        'gvfs'
        'brightnessctl'
        'unzip'
        'git-lfs'
    )
    
    log "正在安装 ${#deps[@]} 个核心包..."
    
    local failed_packages=()
    local max_retries=2
    local retry_interval=3
    
    for pkg in "${deps[@]}"; do
        if pacman -Qi "$pkg" &>/dev/null; then
            log "✓ 包已安装：$pkg"
            continue
        fi
        
        local attempt=1
        local installed=false
        
        while [ $attempt -le $max_retries ]; do
            if [ $attempt -gt 1 ]; then
                log "↻ 第 $attempt 次尝试安装：$pkg"
            fi
            
            if yay -S --noconfirm --answeredit=None --answerclean=All "$pkg" >/dev/null 2>&1; then
                sleep 1  
                if pacman -Qi "$pkg" &>/dev/null; then
                    success "✓ 安装成功：$pkg"
                    installed=true
                    break
                else
                    error "✗ 安装失败：$pkg (第 $attempt 次尝试)"
                    
                    if [ $attempt -lt $max_retries ]; then
                        log "等待 ${retry_interval} 秒后重试..."
                        sleep $retry_interval
                    fi
                fi
            else
                error "✗ 安装失败：$pkg (第 $attempt 次尝试)"
                
                if [ $attempt -lt $max_retries ]; then
                    log "等待 ${retry_interval} 秒后重试..."
                    sleep $retry_interval
                fi
            fi
            
            ((attempt++))
        done
        
        if [ "$installed" = false ]; then
            log "尝试使用 pacman 官方仓库安装：$pkg"
            if sudo pacman -S --noconfirm --needed "$pkg" 2>/dev/null; then
                if pacman -Qi "$pkg" &>/dev/null; then
                    success "✓ 降级安装成功：$pkg"
                    installed=true
                fi
            fi
        fi
        
        if [ "$installed" = false ]; then
            error "✗ 最终安装失败：$pkg"
            failed_packages+=("$pkg")
        fi
    done
    
    if [ ${#failed_packages[@]} -gt 0 ]; then
        warning "以下包安装失败："
        printf '  - %s\n' "${failed_packages[@]}"
        
        log "=========================================="
        log "尝试重新安装失败的包（最终补救）..."
        log "=========================================="
        
        local still_failed=()
        
        for pkg in "${failed_packages[@]}"; do
            log "重新安装：$pkg"
            
            if yay -S --noconfirm --answeredit=None --answerclean=All "$pkg" 2>/dev/null; then
                if pacman -Qi "$pkg" &>/dev/null; then
                    success "✓ 重新安装成功：$pkg"
                    continue
                fi
            fi
            
            if sudo pacman -S --noconfirm --needed "$pkg" 2>/dev/null; then
                if pacman -Qi "$pkg" &>/dev/null; then
                    success "✓ 降级安装成功：$pkg"
                    continue
                fi
            fi
            
            error "✗ 仍然失败：$pkg"
            still_failed+=("$pkg")
        done
        
        if [ ${#still_failed[@]} -gt 0 ]; then
            error "以下包最终安装失败（可能需要手动处理）："
            printf '  - %s\n' "${still_failed[@]}"
            return 1
        fi
    fi
    
    success "✓ 核心依赖安装完成"
    return 0
}

# =============================================================================
# 安装可选依赖（AUR 包）
# =============================================================================
install_optional_deps() {
    log "=========================================="
    log "安装可选依赖（AUR 包）..."
    log "=========================================="
    
    local opt_deps=(
        'linuxqq'
        'visual-studio-code-bin'
        'android-studio'
        'wechat-bin'
        'onlyoffice-bin'
        'mysql'
        'sunshine'
        'reqable-bin'
        'wechat-devtools-git'
    )
    
    
    local failed_packages=()
    local retry_count=2
    local retry_interval=3
    
    for dep_entry in "${opt_deps[@]}"; do
        if pacman -Qi "$dep_entry" &>/dev/null; then
            log "包已安装：$dep_entry"
            continue
        fi
        
        log "安装：$dep_entry"
        
        local attempt=1
        local installed=false
        
        while [ $attempt -le $retry_count ]; do
            log "第 $attempt 次尝试安装：$dep_entry"
            
            if yay -S --noconfirm --answeredit=None --answerclean=All "$dep_entry" 2>/dev/null; then
                if pacman -Qi "$dep_entry" &>/dev/null; then
                    success "安装成功：$dep_entry"
                    installed=true
                    break
                else
                    error "安装验证失败：$dep_entry (第 $attempt 次尝试)"
                fi
            else
                error "安装失败：$dep_entry (第 $attempt 次尝试)"
            fi
            
            if [ $attempt -lt $retry_count ]; then
                log "等待 ${retry_interval} 秒后重试..."
                sleep $retry_interval
            fi
            
            ((attempt++))
        done
        
        if [ "$installed" = false ]; then
            log "尝试使用 pacman 官方仓库安装：$dep_entry"
            if sudo pacman -S --noconfirm --needed "$dep_entry" 2>/dev/null; then
                if pacman -Qi "$dep_entry" &>/dev/null; then
                    success "降级安装成功：$dep_entry"
                    installed=true
                fi
            fi
        fi
        
        if [ "$installed" = false ]; then
            failed_packages+=("$dep_entry")
        fi
    done
    
    if [ ${#failed_packages[@]} -gt 0 ]; then
        warning "以下包安装失败："
        printf '  - %s\n' "${failed_packages[@]}"
        
        log "=========================================="
        log "重新尝试安装失败的包（包括降级安装）..."
        log "=========================================="
        
        local final_failed=()
        
        for pkg in "${failed_packages[@]}"; do
            log "重新安装：$pkg"
            
            if yay -S --noconfirm --answeredit=None --answerclean=All "$pkg" 2>/dev/null; then
                if pacman -Qi "$pkg" &>/dev/null; then
                    success "重新安装成功：$pkg"
                    continue
                fi
            fi
            
            if sudo pacman -S --noconfirm --needed "$pkg" 2>/dev/null; then
                if pacman -Qi "$pkg" &>/dev/null; then
                    success "降级安装成功：$pkg"
                    continue
                fi
            fi
            
            error "最终仍然失败：$pkg"
            final_failed+=("$pkg")
        done
        
        if [ ${#final_failed[@]} -gt 0 ]; then
            warning "最终以下包安装失败 (可能需要手动处理)："
            printf '  - %s\n' "${final_failed[@]}"
            return 1
        fi
    fi
    
    success "可选依赖安装完成"
    return 0
}


# =============================================================================
# 部署配置文件
# =============================================================================

# =============================================================================
# 部署 Fish 配置
# =============================================================================
deploy_fish() {
    log "部署 Fish shell 配置..."
    
    if [ -d "$SCRIPT_DIR/config/fish" ]; then
        mkdir -p "$CURRENT_USER_HOME/.config/fish"
        create_symlink "$SCRIPT_DIR/config/fish/config.fish" "$CURRENT_USER_HOME/.config/fish/config.fish"
        create_symlink "$SCRIPT_DIR/config/fish/fish_plugins" "$CURRENT_USER_HOME/.config/fish/fish_plugins"
        
        log "安装 Fish 插件..."
        if command -v fish &>/dev/null; then
            log "检查并安装 fisher..."
            if ! fish -c "type fisher" &>/dev/null; then
                log "安装 fisher 包管理器..."
                if fish -c "sudo pacman -S fisher  && fisher install jorgebucaran/fisher" 2>/dev/null; then
                    success "fisher 安装成功"
                else
                    warning "fisher 安装失败，尝试从配置文件安装"
                fi
            else
                success "fisher 已安装"
            fi
            
            local plugins=(
                "jethrokuan/z"
                "patrickf1/fzf.fish"
                "ilancosman/tide"
                "jorgebucaran/autopair.fish"
                "gazorby/fish-abbreviation-tips"
                "oh-my-fish/plugin-extract"
                "meaningful-ooo/sponge"
                "nickeb96/puffer-fish"
            )
            
            local failed_plugins=()
            
            for plugin in "${plugins[@]}"; do
                log "安装 Fish 插件：$plugin"
                if fish -c "fisher install $plugin" 2>/dev/null; then
                    success "插件安装成功：$plugin"
                else
                    warning "插件安装失败：$plugin"
                    failed_plugins+=("$plugin")
                fi
            done
            
            if [ ${#failed_plugins[@]} -eq 0 ]; then
                success "Fish 插件全部安装完成"
            else
                warning "以下 Fish 插件安装失败："
                printf '  - %s\n' "${failed_plugins[@]}"
                warning "可以稍后手动安装这些插件"
            fi
            
            change_user_shell_to_fish
        else
            warning "Fish 未安装，跳过插件安装和 shell 切换"
        fi
    fi
}

# =============================================================================
# 切换用户默认 shell 为 Fish
# =============================================================================
change_user_shell_to_fish() {
    log "检查并切换用户默认 shell 为 Fish..."    
    local fish_path=$(command -v fish)
    
    if [ -z "$fish_path" ]; then
        warning "未找到 fish 可执行文件，跳过 shell 切换"
        return 1
    fi
    
    if ! grep -q "^${fish_path}$" /etc/shells 2>/dev/null; then
        log "将 fish 添加到 /etc/shells..."
        echo "$fish_path" | sudo tee -a /etc/shells > /dev/null
        success "已将 $fish_path 添加到 /etc/shells"
    fi
    
    local current_shell=$(grep "^${CURRENT_USER}:" /etc/passwd | cut -d: -f7)
    if [ "$current_shell" = "$fish_path" ]; then
        success "✓ 用户 $CURRENT_USER 的默认 shell 已经是 Fish"
        return 0
    fi
    
    if chsh -s "$fish_path" "$CURRENT_USER" 2>/dev/null; then
        success "✓ 已配置用户 $CURRENT_USER 的默认 shell 为 Fish"
        log "注意：更改将在下次登录时生效"
        return 0
    else
        warning "chsh 命令执行失败"
        warning "请手动运行以下命令切换 shell："
        warning "  chsh -s $fish_path"
        warning "或者编辑 /etc/passwd 文件，将用户的 shell 改为 $fish_path"
        return 1
    fi
}

# =============================================================================
# 部署 Micro 配置
# =============================================================================
deploy_micro() {
    log "部署 Micro 编辑器配置..."
    
    if [ -d "$SCRIPT_DIR/config/micro" ]; then
        mkdir -p "$CURRENT_USER_HOME/.config/micro"
        
        if [ -f "$SCRIPT_DIR/config/micro/bindings.json" ]; then
            create_symlink "$SCRIPT_DIR/config/micro/bindings.json" "$CURRENT_USER_HOME/.config/micro/bindings.json"
        fi
        
        if [ -f "$SCRIPT_DIR/config/micro/settings.json" ]; then
            create_symlink "$SCRIPT_DIR/config/micro/settings.json" "$CURRENT_USER_HOME/.config/micro/settings.json"
        fi
        
        if [ -d "$SCRIPT_DIR/config/micro/colorschemes" ]; then
            create_symlink "$SCRIPT_DIR/config/micro/colorschemes" "$CURRENT_USER_HOME/.config/micro/colorschemes"
        fi
        
        if [ -d "$SCRIPT_DIR/config/micro/plug" ]; then
            create_symlink "$SCRIPT_DIR/config/micro/plug" "$CURRENT_USER_HOME/.config/micro/plug"
        fi
        
    fi
}

# =============================================================================
# 部署系统配置文件（/etc 目录）
# =============================================================================
deploy_system_configs() {
    log "=========================================="
    log "部署系统配置文件..."
    log "=========================================="
    
    local etc_source="$SCRIPT_DIR/etc"
    
    if [ ! -d "$etc_source" ]; then
        log "etc 目录不存在，跳过系统配置部署"
        return 0
    fi
    

    if [ -f "$etc_source/pacman.conf" ]; then
        sudo tee /etc/pacman.conf < "$etc_source/pacman.conf" > /dev/null
        success "已部署 pacman.conf"
    fi
    
    if [ -f "$etc_source/makepkg.conf" ]; then
        sudo tee /etc/makepkg.conf < "$etc_source/makepkg.conf" > /dev/null
        success "已部署 makepkg.conf"
    fi
    
    if [ -f "$etc_source/bash.bashrc" ]; then
        sudo tee /etc/bash.bashrc < "$etc_source/bash.bashrc" > /dev/null
        success "已部署 bash.bashrc"
    fi

    if [ -f "$etc_source/tlp.conf" ]; then
        sudo tee /etc/tlp.conf < "$etc_source/tlp.conf" > /dev/null
        success "已部署 tlp.conf"
    fi

    if [ -f "$etc_source/environment" ]; then
        sudo tee /etc/environment < "$etc_source/environment" > /dev/null
        success "已部署 environment"
    fi
    
    if [ -f "$etc_source/profile" ]; then
        sudo tee /etc/profile < "$etc_source/profile" > /dev/null
        success "已部署 profile"
    fi
    
    if [ -f "$etc_source/safe-rm.conf" ]; then
        sudo tee /etc/safe-rm.conf < "$etc_source/safe-rm.conf" > /dev/null
        success "已部署 safe-rm.conf"
    fi
    
    if [ -f "$etc_source/zram-generator.conf" ]; then
        sudo tee /etc/zram-generator.conf < "$etc_source/zram-generator.conf" > /dev/null
        success "已部署 zram-generator.conf"
    fi
    

    if [ -d "$etc_source/systemd" ]; then
        log "部署 systemd 配置文件..."
        
        if [ -f "$etc_source/systemd/journald.conf" ]; then
            sudo tee /etc/systemd/journald.conf < "$etc_source/systemd/journald.conf" > /dev/null
            success "已部署 journald.conf"
        fi
        
        if [ -f "$etc_source/systemd/system.conf" ]; then
            sudo tee /etc/systemd/system.conf < "$etc_source/systemd/system.conf" > /dev/null
            success "已部署 system.conf"
        fi
        
        if check_systemd; then
            sudo systemctl daemon-reload || warning "systemctl daemon-reload 失败"
        else
            log "systemd 未运行,跳过 daemon-reload (将在重启后生效)"
        fi
    fi
    
    if [ -d "$etc_source/default" ] && [ -f "$etc_source/default/grub" ]; then
        log "部署 GRUB 配置文件..."
        sudo tee /etc/default/grub < "$etc_source/default/grub" > /dev/null
        success "已部署 grub 配置"
        
        if command -v grub-mkconfig &> /dev/null && [ -d "/boot/grub" ]; then
            log "检测到 GRUB，正在更新配置..."
            if sudo grub-mkconfig -o /boot/grub/grub.cfg; then
                success "GRUB 配置已自动更新"
            else
                warning "GRUB 配置更新失败，请手动运行：sudo grub-mkconfig -o /boot/grub/grub.cfg"
            fi
        else
            log "未检测到 GRUB 环境，跳过自动更新（可能是 Docker 容器或 UEFI 系统）"
        fi
    fi
    
    success "系统配置文件部署完成"
}

deploy_configs() {
    log "=========================================="
    log "部署配置文件..."
    log "=========================================="
    
    local config_source="$SCRIPT_DIR/config"
    
    if [ ! -d "$config_source" ]; then
        error "配置目录不存在：$config_source"
        exit 1
    fi
    
    declare -A configs=(
        ["hypr"]="$CURRENT_USER_HOME/.config/hypr"
        ["kitty"]="$CURRENT_USER_HOME/.config/kitty"
        ["waybar"]="$CURRENT_USER_HOME/.config/waybar"
        ["swaync"]="$CURRENT_USER_HOME/.config/swaync"
        ["wlogout"]="$CURRENT_USER_HOME/.config/wlogout"
        ["rofi"]="$CURRENT_USER_HOME/.config/rofi"
        ["Thunar"]="$CURRENT_USER_HOME/.config/Thunar"
        ["pypr"]="$CURRENT_USER_HOME/.config/pypr"
        ["fastfetch"]="$CURRENT_USER_HOME/.config/fastfetch"
        ["fcitx5"]="$CURRENT_USER_HOME/.config/fcitx5"
        ["swappy"]="$CURRENT_USER_HOME/.config/swappy"
        ["qt5ct"]="$CURRENT_USER_HOME/.config/qt5ct"
        ["qt6ct"]="$CURRENT_USER_HOME/.config/qt6ct"
        ["Kvantum"]="$CURRENT_USER_HOME/.config/Kvantum"
        ["gtk-3.0"]="$CURRENT_USER_HOME/.config/gtk-3.0"
        ["gtk-4.0"]="$CURRENT_USER_HOME/.config/gtk-4.0"
        ["cava"]="$CURRENT_USER_HOME/.config/cava"
        ["xsettingsd"]="$CURRENT_USER_HOME/.config/xsettingsd"        

    )
    
    for name in "${!configs[@]}"; do
        target="${configs[$name]}"
        if [ -d "$config_source/$name" ]; then
            create_symlink "$config_source/$name" "$target"
        else
            log "跳过不存在的配置目录：$name"
        fi
    done
    
    deploy_fish    
    deploy_micro
    
    log "设置 HyprLand 脚本执行权限..."
    if [ -d "$CURRENT_USER_HOME/.config/hypr/scripts" ]; then
        find "$CURRENT_USER_HOME/.config/hypr/scripts" -type f -exec chmod +x {} \; 2>/dev/null || true
    fi
    if [ -d "$CURRENT_USER_HOME/.config/hypr/UserScripts" ]; then
        find "$CURRENT_USER_HOME/.config/hypr/UserScripts" -type f -exec chmod +x {} \; 2>/dev/null || true
    fi
    
    if [ -f "$config_source/qq-flags.conf" ]; then
        create_symlink "$config_source/qq-flags.conf" "$CURRENT_USER_HOME/.config/qq-flags.conf"
    else
        log "跳过不存在的文件：qq-flags.conf"
    fi
    
    if [ -f "$config_source/electron-flags.conf" ]; then
        create_symlink "$config_source/electron-flags.conf" "$CURRENT_USER_HOME/.config/electron-flags.conf"
    else
        log "跳过不存在的文件：electron-flags.conf"
    fi

    if [ -f "$config_source/chrome-flags.conf" ]; then
        create_symlink "$config_source/chrome-flags.conf" "$CURRENT_USER_HOME/.config/chrome-flags.conf"
    else
        log "跳过不存在的文件：chrome-flags.conf"
    fi

    if [ -d "$SCRIPT_DIR/local/share/fcitx5" ]; then
        create_symlink "$SCRIPT_DIR/local/share/fcitx5" "$CURRENT_USER_HOME/.local/share/fcitx5"
    else
        log "跳过不存在的目录：local/share/fcitx5"
    fi

    if [ -d "$SCRIPT_DIR/Pictures/wallpapers" ]; then
        log "部署壁纸文件..."
        mkdir -p "$CURRENT_USER_HOME/Pictures/wallpapers"
        
        shopt -s nullglob
        local wallpaper_files=("$SCRIPT_DIR/Pictures/wallpapers"/*)
        shopt -u nullglob
        
        if [ ${#wallpaper_files[@]} -gt 0 ]; then
            for wallpaper in "${wallpaper_files[@]}"; do
                if [ -f "$wallpaper" ]; then
                    local filename=$(basename "$wallpaper")
                    create_symlink "$wallpaper" "$CURRENT_USER_HOME/Pictures/wallpapers/$filename"
                fi
            done
            success "已部署 ${#wallpaper_files[@]} 个壁纸文件"
        else
            log "壁纸目录为空，跳过"
        fi
    else
        log "跳过不存在的目录：Pictures/wallpapers"
    fi

    
    if [ -d "$SCRIPT_DIR/local/share/fonts" ]; then
        log "部署字体文件..."
        mkdir -p "$CURRENT_USER_HOME/.local/share/fonts"
        
        shopt -s nullglob
        local has_fonts=false
        for font_file in "$SCRIPT_DIR/local/share/fonts"/*; do
            if [ -f "$font_file" ]; then
                local filename=$(basename "$font_file")
                create_symlink "$font_file" "$CURRENT_USER_HOME/.local/share/fonts/$filename"
                has_fonts=true
            fi
        done
        shopt -u nullglob
        
        if [ "$has_fonts" = true ]; then
            log "更新字体缓存..."
            fc-cache -fv 2>/dev/null || true
            success "字体缓存更新完成"
        else
            log "字体目录为空，跳过"
        fi
    else
        log "跳过不存在的目录：local/share/fonts"
    fi
    
    if [ -f "$SCRIPT_DIR/usr/local/bin/rm" ]; then
        log "部署 safe-rm 工具..."
        sudo mkdir -p /usr/local/bin
        sudo cp "$SCRIPT_DIR/usr/local/bin/rm" /usr/local/bin/rm
        sudo chmod +x /usr/local/bin/rm
        success "已部署 safe-rm 到 /usr/local/bin/rm"
    else
        log "跳过不存在的文件：usr/local/bin/rm"
    fi
    
    success "配置文件部署完成"
    
    if command -v hyprctl &>/dev/null; then
        if hyprctl ping &>/dev/null; then
            log "检测到 Hyprland 正在运行，尝试重新加载配置..."
            if hyprctl reload 2>/dev/null; then
                success "Hyprland 配置已重新加载"
            else
                warning "Hyprland 配置重新加载失败，重启后生效"
            fi
        else
            log "Hyprland 未运行，配置将在下次启动时生效"
        fi
    else
        log "hyprctl 未安装，跳过配置重载"
    fi
}

# =============================================================================
# 检测 systemd 是否可用
# =============================================================================
check_systemd() {
    if [ -d /run/systemd/system ]; then
        return 0
    else
        return 1
    fi
}

# =============================================================================
# 配置系统服务
# =============================================================================
runService() {
    log "=========================================="
    log "配置系统服务..."
    log "=========================================="
    
    if ! check_systemd; then
        warning "=========================================="
        warning "警告：systemd 未运行（PID 1）"
        warning "=========================================="
        warning "当前环境可能是在 chroot、容器或 Live 环境中"
        warning "系统服务配置将在重启后生效"
        warning ""
        warning "重启后，以下服务将自动启用："
        warning "  - NetworkManager"
        warning "  - CUPS (打印服务)"
        warning "  - TLP (电源管理)"
        warning "  - Powertop"
        warning ""
        warning "如需立即配置，请在重启后的真实系统中运行此脚本"
        warning "=========================================="
        
        log "配置服务开机自启（将在重启后生效）..."
        
        sudo systemctl enable NetworkManager 2>/dev/null || warning "NetworkManager 启用失败"
        sudo systemctl disable systemd-networkd 2>/dev/null || true
        sudo systemctl disable systemd-networkd-wait-online 2>/dev/null || true
        
        sudo systemctl enable cups 2>/dev/null || warning "CUPS 服务启用失败"
        
        sudo systemctl disable power-profiles-daemon.service 2>/dev/null || true
        sudo systemctl mask systemd-rfkill.service 2>/dev/null || true
        sudo systemctl mask systemd-rfkill.socket 2>/dev/null || true
        sudo systemctl enable tlp 2>/dev/null || warning "TLP 服务启用失败"
        
        if [ ! -f /etc/systemd/system/powertop.service ]; then
            log "创建 Powertop 服务配置..."
            sudo tee /etc/systemd/system/powertop.service > /dev/null << 'EOF'
[Unit]
Description=Powertop tunings
After=multi-user.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/powertop --auto-tune

[Install]
WantedBy=multi-user.target
EOF
            sudo systemctl daemon-reload 2>/dev/null || true
        fi
        sudo systemctl enable powertop.service 2>/dev/null || warning "powertop 服务启用失败"
        
        sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target 2>/dev/null || true
        
        return 0
    fi
    
    log "配置网络管理服务..."
    sudo systemctl enable --now NetworkManager || warning "NetworkManager 启用失败"
    sudo systemctl disable systemd-networkd || true
    sudo systemctl disable systemd-networkd-wait-online || true
    sudo systemctl disable NetworkManager-wait-online.service || true
    sudo systemctl mask NetworkManager-wait-online.service || true
    
    log "配置 CUPS 打印服务..."
    sudo systemctl enable --now cups || warning "CUPS 服务启用失败"
    
    log "配置电源管理服务..."
    sudo systemctl disable --now power-profiles-daemon.service 2>/dev/null || true
    sudo systemctl mask systemd-rfkill.service || true
    sudo systemctl mask systemd-rfkill.socket || true
    sudo systemctl stop systemd-rfkill.service 2>/dev/null || true
    sudo systemctl stop systemd-rfkill.socket 2>/dev/null || true
    sudo systemctl enable --now tlp || warning "TLP 服务启用失败"
    
    log "配置 Powertop 服务..."
    
    if [ ! -f /etc/systemd/system/powertop.service ]; then
        sudo tee /etc/systemd/system/powertop.service > /dev/null << 'EOF'
[Unit]
Description=Powertop tunings
After=multi-user.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/powertop --auto-tune

[Install]
WantedBy=multi-user.target
EOF
    fi
    
    sudo systemctl daemon-reload || warning "systemctl daemon-reload 失败"
    sudo systemctl enable --now powertop.service || warning "powertop 服务启用失败"
    
    if command -v powertop &>/dev/null; then
        log "运行 Powertop 自动调优..."
        sudo powertop --auto-tune 2>&1 | grep -v "modprobe.*failed" | grep -v "Failed to mount debugfs" || true
    fi
    
    log "禁用休眠和睡眠目标..."
    sudo systemctl mask sleep.target || true
    sudo systemctl mask suspend.target || true
    sudo systemctl mask hibernate.target || true
    sudo systemctl mask hybrid-sleep.target || true
    
    success "系统服务配置完成"
}


deployhome() {
    local home_source="$SCRIPT_DIR/home"
    
    if [ ! -d "$home_source" ]; then
        error "用户配置目录不存在：$home_source"
        exit 1
    fi
    
    log "部署用户家目录配置..."
    
    for file in "$home_source"/*; do
        if [ -e "$file" ]; then
            local filename=$(basename "$file")
            log "复制 $filename 到 $CURRENT_USER_HOME"
            cp -r "$file" "$CURRENT_USER_HOME/"
        fi
    done
    
    if [ -f "$CURRENT_USER_HOME/dot_gtkrc-2.0" ]; then
        mv "$CURRENT_USER_HOME/dot_gtkrc-2.0" "$CURRENT_USER_HOME/.gtkrc-2.0"
        success "已部署 .gtkrc-2.0"
    fi
    
    if [ -d "$CURRENT_USER_HOME/dot_icons" ]; then
        [ -e "$CURRENT_USER_HOME/.icons" ] && rm -rf "$CURRENT_USER_HOME/.icons"
        mv "$CURRENT_USER_HOME/dot_icons" "$CURRENT_USER_HOME/.icons"
        
        log "解压图标包..."
        local icon_dir="$CURRENT_USER_HOME/.icons"
        shopt -s nullglob
        local zip_files=("$icon_dir"/*.zip)
        shopt -u nullglob
        
        if [ ${#zip_files[@]} -gt 0 ]; then
            for zip_file in "${zip_files[@]}"; do
                local zip_name=$(basename "$zip_file")
                log "解压 $zip_name ..."
                if unzip -o "$zip_file" -d "$icon_dir/" 2>/dev/null; then
                    rm -f "$zip_file"
                    success "已解压并清理: $zip_name"
                else
                    warning "解压失败: $zip_name"
                fi
            done
        else
            log ".icons 目录下没有 zip 文件"
        fi
        
        success "已部署 .icons"
    fi
    
    if [ -d "$CURRENT_USER_HOME/dot_themes" ]; then
        [ -e "$CURRENT_USER_HOME/.themes" ] && rm -rf "$CURRENT_USER_HOME/.themes"
        mv "$CURRENT_USER_HOME/dot_themes" "$CURRENT_USER_HOME/.themes"
        success "已部署 .themes"
    fi
    
    success "用户家目录配置部署完成"
}

# =============================================================================
# 主函数
# =============================================================================
main() {
    log "=========================================="
    log "开始 ArchConfig 安装流程..."
    log "=========================================="
    
    log "验证配置目录结构..."
    if [ ! -d "$SCRIPT_DIR/config" ]; then
        error "配置目录不存在：$SCRIPT_DIR/config"
        exit 1
    fi
    
    if [ ! -d "$SCRIPT_DIR/etc" ]; then
        error "系统配置目录不存在：$SCRIPT_DIR/etc"
        exit 1
    fi
    
    success "配置目录结构验证通过"
    
    if ! check_yay; then
        error "yay 检查或安装失败，终止安装"
        exit 1
    fi
    
    if ! install_core_deps; then
        error "核心依赖安装失败，终止安装"
        exit 1
    fi
    
    log "=========================================="
    log "开始安装可选依赖..."
    log "=========================================="
    install_optional_deps || warning "部分可选依赖安装失败，但不影响系统运行"
    
    if ! deploy_system_configs; then
        error "系统配置部署失败，终止安装"
        exit 1
    fi
    
    if ! deploy_configs; then
        error "用户配置部署失败，终止安装"
        exit 1
    fi
    
    if [ -d "$SCRIPT_DIR/home" ]; then
        if ! deployhome; then
            error "用户家目录配置部署失败，终止安装"
            exit 1
        fi
    else
        log "跳过用户家目录配置（home 目录不存在）"
    fi
    
    if ! runService; then
        error "系统服务配置失败，终止安装"
        exit 1
    fi

    echo ""
    echo "=========================================="
    success "安装完成！建议重启系统以使所有更改生效"
    echo "=========================================="
    echo ""
    warning "注意："
    warning "1. VSCode 与 Android Studio 需要手动配置"
    
    if command -v grub-mkconfig &> /dev/null && [ -d "/boot/grub" ]; then
        log "2. GRUB 已检测到，配置已自动更新"
    else
        log "2. 未检测到 GRUB 环境（可能是 Docker/UEFI），如需配置引导请手动处理"
    fi
    echo ""
}

main "$@"
