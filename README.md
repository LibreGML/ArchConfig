# ArchConfig

> 🚀 TZGML Arch Linux Hyprland Dotfiles - 现代化、高效的 Wayland 桌面环境配置


---

## 📖 目录

- [项目结构](#-项目结构)
- [快速安装](#-快速安装)
- [核心配置说明](#-核心配置说明)
- [快捷键大全](#-快捷键大全)
- [触摸板手势](#-触摸板手势)
- [自定义指南](#-自定义指南)
- [屏幕截图](#-屏幕截图)

---


## 🖼️ 屏幕截图


### Android Studio
<img width="1896" height="1016" alt="android" src="https://github.com/user-attachments/assets/c9576a59-6fef-4066-a88a-cd968d405c99" />

### kitty
![freecompress-kitty](https://github.com/user-attachments/assets/833f53f1-bf95-4fd0-b753-169e3deb004f)

### linuxqq
![freecompress-linuxqq](https://github.com/user-attachments/assets/8b0ddb4d-2292-4ac9-9c00-c5790a92b8be)

### swaync
![freecompress-swaync](https://github.com/user-attachments/assets/4ecd40bd-9914-4783-98ba-5bf370a39904)

### vscode
![freecompress-vscode](https://github.com/user-attachments/assets/ec4e8a75-728a-47a5-8e17-1cc8439130b9)

### neovim
![neovim](https://github.com/user-attachments/assets/d63aa98c-baad-4360-962f-23e935ebbc11)


---

## 📁 项目结构

### 完整目录树

```
ArchConfig/
├── config/                          # 用户配置文件目录
│   ├── hypr/                        # Hyprland 窗口管理器配置
│   │   ├── hyprland.conf            # 主配置文件（快捷键、窗口规则、自启动）
│   │   ├── hyprlock.conf            # 锁屏配置
│   │   ├── hypridle.conf            # 空闲检测/电源管理配置
│   │   ├── UserConfigs/             # 用户自定义配置模块
│   │   │   ├── Laptops.conf         # 笔记本电脑特定配置
│   │   │   ├── UserDecorAnimations.conf  # 窗口装饰和动画效果
│   │   │   └── UserSettings.conf    # 个性化设置
│   │   ├── scripts/                 # 系统功能脚本（24 个）
│   │   │   ├── Volume.sh            # 音量控制
│   │   │   ├── Brightness.sh        # 亮度调节
│   │   │   ├── ClipManager.sh       # 剪贴板管理
│   │   │   ├── ScreenShot.sh        # 截图功能
│   │   │   ├── MediaCtrl.sh         # 媒体播放控制
│   │   │   ├── Refresh.sh           # 刷新配置
│   │   │   ├── WaybarStyles.sh      # 状态栏样式切换
│   │   │   ├── WaybarLayout.sh      # 状态栏布局切换
│   │   │   ├── Wlogout.sh           # 注销菜单
│   │   │   ├── RofiSearch.sh        # 网络搜索
│   │   │   ├── LockScreen.sh        # 锁屏
│   │   │   ├── AirplaneMode.sh      # 飞行模式
│   │   │   ├── Battery.sh           # 电池管理
│   │   │   ├── DarkLight.sh         # 深色/浅色主题切换
│   │   │   └── ...                  # 其他功能脚本
│   │   └── UserScripts/             # 用户自定义脚本（6 个）
│   │       ├── WallpaperSelect.sh   # 壁纸选择
│   │       ├── WallpaperRandom.sh   # 随机壁纸
│   │       ├── WallpaperAutoChange.sh  # 自动更换壁纸
│   │       ├── WallpaperEffects.sh  # 壁纸特效
│   │       ├── RainbowBorders.sh    # 彩虹边框效果
│   │       └── QuickEdit.sh         # 快速编辑
│   ├── kitty/                       # Kitty 终端配置
│   │   ├── kitty.conf               # 主配置文件
│   │   └── kitty-themes/            # 终端主题目录
│   ├── waybar/                      # Waybar 状态栏配置
│   │   ├── style.css                # 当前样式文件（符号链接）
│   │   └── style/                   # 预设样式库
│   │       └── [Static] Chroma Tally.css
│   ├── swaync/                      # 通知中心配置
│   │   ├── config.json              # 配置文件
│   │   └── style.css                # 样式文件
│   ├── wlogout/                     # 注销菜单配置
│   │   └── style.css                # 样式文件
│   ├── Thunar/                      # 文件管理器配置
│   │   ├── accels.scm               # 快捷键配置
│   │   └── uca.xml                  # 自定义操作配置
│   ├── fcitx5/                      # 输入法配置
│   │   └── conf/                    # 配置文件目录
│   │       ├── chttrans.conf        # 简繁转换
│   │       ├── classicui.conf       # 经典界面
│   │       ├── notifications.conf   # 通知设置
│   │       ├── pinyin.conf          # 拼音输入
│   │       └── punctuation.conf     # 标点符号
│   ├── fish/                        # Fish Shell 配置
│   │   ├── config.fish              # Fish 主配置文件
│   │   └── fish_plugins             # Fish 插件列表
│   ├── micro/                       # Micro 编辑器配置
│   │   ├── bindings.json            # 键位绑定
│   │   └── plug/                    # 插件目录（6 个插件）
│   ├── pypr/                        # Pyprland 增强工具配置
│   │   └── config.toml              # 配置文件
│   ├── electron-flags.conf          # Electron 应用标志
│   └── qq-flags.conf                # QQ 标志
├── etc/                             # 系统级配置文件
│   ├── pacman.conf                  # Pacman 包管理器配置
│   ├── makepkg.conf                 # Makepkg 构建配置
│   └── systemd/                     # Systemd 服务配置
│       ├── journald.conf            # 日志服务配置
│       └── system.conf              # 系统服务配置
├── local/                           # 用户本地数据
│   └── share/
│       └── fcitx5/                  # 输入法主题
│       └── fonts/                   # 自定义字体
├── vscode/                          # VSCode 配置
│   ├── vscode_settings.json         # VSCode 设置
│   └── neovide-cursor.js            # Neovide 光标配置
├── install.sh                       # 自动化安装脚本
├── arch_note.md                     # Arch 安装笔记
└── README.md                        # 项目说明文档
```

### 核心组件说明

| 组件 | 说明 | 配置文件路径 |
|------|------|-------------|
| **Hyprland** | Wayland 合成器（窗口管理器） | [`config/hypr/hyprland.conf`](./config/hypr/hyprland.conf) |
| **Waybar** | 可定制状态栏 | [`config/waybar/style.css`](./config/waybar/style.css) |
| **SwayNC** | 通知中心 | [`config/swaync/config.json`](./config/swaync/config.json) |
| **Kitty** | GPU 加速终端 | [`config/kitty/kitty.conf`](./config/kitty/kitty.conf) |
| **Fish Shell** | 现代化命令行 Shell | [`config/fish/config.fish`](./config/fish/config.fish) |
| **Hyprlock** | 锁屏工具 | [`config/hypr/hyprlock.conf`](./config/hypr/hyprlock.conf) |
| **Rofi** | 应用启动器/搜索 | - |
| **Thunar** | 文件管理器 | [`config/Thunar/`](./config/Thunar/) |
| **Fcitx5** | 中文输入法 | [`config/fcitx5/conf/`](./config/fcitx5/conf/) |
| **Pyprland** | 增强工具（下拉终端等） | [`config/pypr/config.toml`](./config/pypr/config.toml) |
| **Cliphist** | 剪贴板管理器 | - |
| **Awww** | 壁纸管理工具 | - |
| **Wlogout** | 注销/关机菜单 | [`config/wlogout/style.css`](./config/wlogout/style.css) |

---

## 🚀 快速安装

### 方式一：自动化安装（推荐）

```bash
# 1. 克隆仓库
git clone https://github.com/tzgml/ArchConfig.git
cd ArchConfig

# 2. 执行自动安装脚本
chmod +x install.sh
./install.sh
```

**安装脚本自动完成：**
- ✅ 检测并安装 yay（AUR 助手）
- ✅ 安装所有核心依赖包（含重试机制）
- ✅ 安装可选 AUR 软件包
- ✅ 复制配置文件到对应目录（使用符号链接）
- ✅ 设置脚本执行权限
- ✅ 配置 Fish Shell 及插件
- ✅ 配置 Micro 编辑器及插件
- ✅ 部署系统级配置文件
- ✅ 自动切换默认 Shell 为 Fish
- ✅ 创建必要目录

### 方式二：手动安装

#### 1. 安装核心依赖

```
# 基础系统工具
sudo pacman -S hyprland kitty fish waybar swaync rofi thunar micro fcitx5 fcitx5-chinese-addons awww cliphist wl-clip-persist fastfetch pyprland wlogout firefox-developer-edition fzf swappy grim slurp hyprpicker eza ripgrep ttf-fira-code ttf-jetbrains-mono ttf-victor-mono-nerd noto-fonts noto-fonts-cjk noto-fonts-emoji hyprshot

# 音频支持
sudo pacman -S pipewire pipewire-alsa wireplumber alsa-firmware alsa-ucm-conf sof-firmware

# 图形驱动（AMD）
sudo pacman -S mesa lib32-mesa xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon amd-ucode

# 网络与蓝牙
sudo pacman -S network-manager-applet bluez bluez-utils blueman pkgfile

# 开发工具
sudo pacman -S nodejs npm jdk21-openjdk android-tools docker docker-compose lazydocker

# 其他实用工具
sudo pacman -S btop clash-verge-rev mihomo localsend nginx syncthing tlp powertop cups cups-filters ghostscript imagemagick mpv loupe obs-studio
```

#### 2. 备份现有配置


#### 3. 复制配置文件

```bash
# 复制用户配置（使用符号链接）
ln -s $(pwd)/config/hypr ~/.config/hypr
ln -s $(pwd)/config/kitty ~/.config/kitty
ln -s $(pwd)/config/waybar ~/.config/waybar
ln -s $(pwd)/config/swaync ~/.config/swaync
ln -s $(pwd)/config/wlogout ~/.config/wlogout
ln -s $(pwd)/config/fish ~/.config/fish
ln -s $(pwd)/config/Thunar ~/.config/Thunar
ln -s $(pwd)/config/fcitx5 ~/.config/fcitx5
ln -s $(pwd)/config/micro ~/.config/micro
ln -s $(pwd)/config/pypr ~/.config/pypr

# 复制系统级配置（可选）
sudo cp config/pacman.conf /etc/pacman.conf
sudo cp config/makepkg.conf /etc/makepkg.conf
sudo cp config/etc/systemd/journald.conf /etc/systemd/journald.conf
sudo cp config/etc/systemd/system.conf /etc/systemd/system.conf
```

#### 4. 配置 Fish Shell

```bash
# 切换默认 Shell
chsh -s /usr/bin/fish

# 安装 fisher 插件管理器
sudo pacman -S fisher

# 安装 Fish 插件
fish -c "fisher install jethrokuan/z patrickf1/fzf.fish ilancosman/tide jorgebucaran/autopair.fish gazorby/fish-abbreviation-tips oh-my-fish/plugin-extract meaningful-ooo/sponge nickeb96/puffer-fish"

# 配置 Tide 主题
tide configure
```

#### 5. 重启 Hyprland

重新登录或重启系统使配置生效。

---

## 📝 核心配置说明

### 主要配置文件详解

#### `config/hypr/hyprland.conf` - 主配置文件

**包含内容：**
- **变量定义**：路径、修饰键、默认应用
- **显示器设置**：分辨率、缩放、镜像
- **自启动应用**：输入法、壁纸、状态栏、通知中心等
- **快捷键绑定**：所有键盘快捷键定义
- **窗口规则**：应用自动分配到工作区
- **环境变量**：Wayland 环境变量配置
- **鼠标绑定**：鼠标操作配置
- **触摸板手势**：多指手势配置

#### `UserConfigs/` - 模块化配置

| 文件 | 功能 |
|------|------|
| **`Laptops.conf`** | 笔记本电脑特定配置（电池、亮度、触摸板等） |
| **`UserDecorAnimations.conf`** | 窗口动画、阴影、圆角、模糊等视觉效果 |
| **`UserSettings.conf`** | 个人偏好设置（边框、间距、布局、输入设备等） |

### 自启动应用清单

| 应用 | 说明 |
|------|------|
| **Fcitx5** | 中文输入法 |
| **Awww** | 壁纸守护进程（每 30 分钟随机更换） |
| **Waybar** | 状态栏 |
| **SwayNC** | 通知中心 |
| **AGS** | Aylur's GTK Shell（状态栏/小部件框架） |
| **Cliphist** | 剪贴板管理（文本 + 图像） |
| **wl-clip-persist** | 剪贴板持久化 |
| **Hypridle** | 电源管理/锁屏 |
| **Pyprland** | 下拉终端/窗口缩放 |
| **Kitty** | 终端模拟器 |
| **Nm-applet** | 网络管理器 |
| **Blueman-applet** | 蓝牙管理器 |
| **Rog-control-center** | 华硕设备控制中心 |
| **Hyprpolkitagent** | 权限认证代理 |
| **RainbowBorders** | 彩虹边框动画效果 |

### 窗口规则 - 工作区自动分配

| 应用类型 | 工作区 | 匹配的应用 |
|---------|-------|-----------|
| **浏览器** | 5 | Firefox, Chrome, Chromium, Edge, Brave, Zen, Thorium |
| **开发工具** | 4 | VSCode, Android Studio, IntelliJ IDEA, 微信开发者工具 |

### Fish Shell 配置

本配置使用 **Fish Shell** 作为默认命令行环境，提供以下特性：

- **智能自动补全**：基于历史命令的智能建议
- **语法高亮**：实时语法检查和错误提示
- **Tide 主题**：美观且高度可定制的提示符
- **FZF 集成**：强大的模糊搜索功能
- **Z 跳转**：智能目录导航
- **自动配对**：括号、引号自动补全

**已安装的 Fish 插件：**
- `jethrokuan/z` - 智能目录跳转
- `patrickf1/fzf.fish` - FZF 集成
- `ilancosman/tide` - 现代化提示符主题
- `jorgebucaran/autopair.fish` - 自动配对
- `gazorby/fish-abbreviation-tips` - 缩写提示
- `oh-my-fish/plugin-extract` - 自动解压
- `meaningful-ooo/sponge` - 管道处理优化
- `nickeb96/puffer-fish` - 命令预览

---

## ⌨️ 快捷键大全

> 💡 **说明**：`WIN` = Super/Win 键，所有快捷键基于 [`config/hypr/hyprland.conf`](./config/hypr/hyprland.conf)

### 📌 基础操作

| 快捷键 | 功能 | 详细说明 |
|--------|------|----------|
| `WIN + WIN` | 应用启动器 | 打开 Rofi 应用启动器（支持搜索、运行、窗口切换） |
| `WIN + E` | 文件管理器 | 打开 Thunar 文件管理器 |
| `WIN + C` | 关闭窗口 | 关闭当前活动窗口 |
| `WIN + F` | 文件浏览器 | 打开 Rofi 文件浏览器 |
| `WIN + UP` | 退出全屏 | 退出全屏模式 |
| `WIN + DOWN` | 进入全屏 | 进入全屏模式 |
| `WIN + L` | 锁屏 | 立即锁定屏幕（Hyprlock） |

### 🔧 系统控制

| 快捷键 | 功能 | 详细说明 |
|--------|------|----------|
| `Ctrl + Alt + Delete` | 退出 Hyprland | 退出当前 Hyprland 会话 |
| `Ctrl + Alt + O` | 注销菜单 | 打开 Wlogout 注销/关机菜单 |
| `Ctrl + WIN + R` | 重启系统 | 重启计算机 |
| `Ctrl + WIN + P` | 关机 | 关闭计算机 |
| `WIN + I` | 编辑配置 | 使用 Micro 编辑 Hyprland 配置文件 |

### 🖥️ 工作区管理

| 快捷键 | 功能 | 详细说明 |
|--------|------|----------|
| `WIN + 1~10` | 切换工作区 | 切换到第 1-10 个工作区 |
| `WIN + Shift + 1~10` | 移动并跟随 | 将窗口移到第 1-10 工作区并跟随切换 |
| `WIN + Ctrl + 1~10` | 静默移动 | 将窗口移到第 1-10 工作区但不跟随 |
| `Alt + Tab` | 下一工作区 | 切换到下一个工作区 |
| `Alt + 鼠标滚轮上/下` | 切换工作区 | 向上/向下切换工作区 |
| `WIN + Shift + [ / ]` | 移动到上一个/下一个工作区 | 将窗口移到上一个/下一个工作区并跟随 |
| `WIN + Ctrl + [ / ]` | 静默移动到上一个/下一个工作区 | 将窗口移到上一个/下一个工作区但不跟随 |
| `Alt + U` | 特殊工作区 | 显示/隐藏特殊工作区（scratchpad） |
| `WIN + Ctrl + D` | 移动到特殊工作区 | 将当前窗口移动到特殊工作区 |

### 🪟 窗口管理

| 快捷键 | 功能 | 详细说明 |
|--------|------|----------|
| `WIN + Ctrl + ←/→/↑/↓` | 移动窗口 | 将窗口向对应方向移动 |
| `WIN + Shift + ←/→/↑/↓` | 调整窗口大小 | 以 50 像素为单位调整窗口大小 |
| `Shift + 鼠标左键拖动` | 拖动窗口 | 按住 Shift+ 鼠标左键拖动窗口 |
| `Shift + 鼠标右键拖动` | 调整窗口大小 | 按住 Shift+ 鼠标右键调整窗口大小 |
| `Alt + ←/→/↑/↓` | 切换焦点 | 将焦点移到对应方向的窗口 |

### 🛠️ 实用工具

| 快捷键 | 功能 | 详细说明 |
|--------|------|----------|
| `WIN + V` | 剪贴板管理 | 打开 Cliphist 剪贴板历史管理器 |
| `WIN + S` | 网络搜索 | 使用 Rofi 进行网络搜索 |
| `WIN + K` | 下拉终端 | Pyprland 下拉式终端（类似 Quake） |
| `WIN + R` | 运行对话框 | 左下角运行对话框（类似 Windows 运行） |
| `WIN + B` | 显示/隐藏状态栏 | 切换 Waybar 状态栏可见性 |
| `WIN + Shift + N` | 通知中心 | 切换 SwayNC 通知中心面板 |
| `WIN + Alt + R` | 刷新配置 | 刷新 Waybar、SwayNC、Rofi 配置 |
| `WIN + Shift + C` | 屏幕取色器 | 打开 Hyprpicker 屏幕取色器 |
| `WIN + Shift + B` | Firefox 浏览器 | 启动 Firefox Developer Edition |
| `WIN + Shift + V` | VSCode | 启动 Visual Studio Code |

### 🎨 壁纸控制

| 快捷键 | 功能 | 详细说明 |
|--------|------|----------|
| `WIN + W` | 选择壁纸 | 打开壁纸选择器（Awww） |
| `Ctrl + Alt + W` | 随机壁纸 | 随机切换壁纸（每 30 分钟自动更换） |
| `WIN + Shift + W` | 壁纸特效 | 应用壁纸特效 |

### 🎵 媒体控制

| 快捷键 | 功能 | 详细说明 |
|--------|------|----------|
| `XF86AudioRaiseVolume` | 音量增加 | 提高系统音量 |
| `XF86AudioLowerVolume` | 音量减小 | 降低系统音量 |
| `XF86AudioMute` | 静音开关 | 切换系统静音 |
| `XF86AudioMicMute` | 麦克风静音 | 切换麦克风静音 |
| `XF86AudioPlay/Pause` | 播放/暂停 | 控制媒体播放/暂停 |
| `XF86AudioNext` | 下一曲 | 切换到下一首歌曲 |
| `XF86AudioPrev` | 上一曲 | 切换到上一首歌曲 |
| `XF86AudioStop` | 停止播放 | 停止媒体播放 |
| `XF86Sleep` | 睡眠 | 系统进入睡眠状态 |
| `XF86Rfkill` | 飞行模式 | 切换飞行模式 |

### 📸 截图功能

| 快捷键 | 功能 | 详细说明 |
|--------|------|----------|
| `WIN + Shift + S` | 区域截图 | 选择区域截图并复制到剪贴板 |

### 🎯 状态栏控制

| 快捷键 | 功能 | 详细说明 |
|--------|------|----------|
| `WIN + B` | 切换状态栏 | 显示/隐藏 Waybar 状态栏 |
| `WIN + Ctrl + B` | 更改样式 | 切换 Waybar 预设样式 |
| `WIN + Alt + B` | 更改布局 | 切换 Waybar 布局 |

---

## 👆 触摸板手势

> 💡 所有手势基于 [`config/hypr/hyprland.conf`](./config/hypr/hyprland.conf) 中的 `gesture` 配置

### 三指手势

| 手势 | 功能 | 详细说明 |
|------|------|----------|
| **三指左右滑动** | 切换工作区 | 水平滑动切换工作区 |
| **三指下滑** | 退出全屏 | 退出全屏模式 |
| **三指上滑** | 进入全屏 | 进入全屏模式 |
| **三指下滑 + Alt** | 窗口截图 | 截取活动窗口并复制到剪贴板 |
| **三指上滑 + Alt** | 锁屏 | 立即锁定屏幕 |
| **三指下滑 + Ctrl** | 关闭窗口 | 关闭当前活动窗口 |

### 四指手势

| 手势 | 功能 | 详细说明 |
|------|------|----------|
| **四指下滑 + Ctrl** | 打开终端 | 启动 Kitty 终端 |
| **四指上滑 + Ctrl** | 文件管理器 | 打开 Thunar 文件管理器 |

---

## 🎨 自定义指南

### 更换壁纸

1. 将新壁纸放入 `~/Pictures/wallpapers/` 目录
2. 使用 `WIN + W` 选择壁纸
3. 或使用 `Ctrl + Alt + W` 随机切换
4. 修改自动更换间隔：编辑 [`config/hypr/UserScripts/WallpaperAutoChange.sh`](./config/hypr/UserScripts/WallpaperAutoChange.sh)

### 更换终端主题

1. 从 [`config/kitty/kitty-themes/`](./config/kitty/kitty-themes/) 选择主题
2. 编辑 [`config/kitty/kitty.conf`](./config/kitty/kitty.conf)
3. 修改 `include` 指令指向新主题文件

### 更改主题颜色

主题颜色已在配置文件中静态定义，如需修改：

1. 编辑 [`config/hypr/UserConfigs/UserSettings.conf`](./config/hypr/UserConfigs/UserSettings.conf)
2. 修改 `$color0` 到 `$color15` 的颜色值
3. 运行 `~/.config/hypr/scripts/Refresh.sh` 刷新

**注意：** 颜色格式为 `rgb(十六进制颜色值)`，例如：`$color0 = rgb(4E5056)`

### 修改状态栏样式

1. 运行 `~/.config/hypr/scripts/WaybarStyles.sh` 选择预设样式
2. 或手动编辑 [`config/waybar/style.css`](./config/waybar/style.css)
3. 运行 `~/.config/hypr/scripts/Refresh.sh` 刷新

### 添加开机自启动

编辑 [`config/hypr/hyprland.conf`](./config/hypr/hyprland.conf)，在 `exec-once` 区域添加：

```conf
exec-once = 你的命令 &
```

### 自定义快捷键

编辑 [`config/hypr/hyprland.conf`](./config/hypr/hyprland.conf)，参考现有格式添加：

```conf
# 语法：bind = 修饰键，按键，动作，参数
bind = $mainMod, X, exec, 命令
```

### 修改窗口规则

编辑 [`config/hypr/hyprland.conf`](./config/hypr/hyprland.conf)，在 `windowrule` 区域添加：

```conf
# 语法：windowrule = 规则，class:^应用类名$
windowrule = workspace 3, class:^MyApp$
```

### 自定义 Fish Shell

编辑 [`config/fish/config.fish`](./config/fish/config.fish) 添加个性化配置：

```fish
# 添加别名
alias ll 'eza -la --icons'
alias gs 'git status'

# 设置环境变量
set -gx EDITOR micro
```

安装新的 Fish 插件：

```fish
fisher install 插件名称
```

---



## 🙏 致敬

- [Hyprland](https://github.com/hyprwm/Hyprland)
- [JaKooLit](https://github.com/JaKooLit)
- [Fish Shell](https://fishshell.com/)
- [Tide](https://github.com/IlanCosman/tide)
