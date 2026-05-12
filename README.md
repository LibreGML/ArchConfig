# ArchConfig

> 🚀 TZGML Arch Linux Hyprland Dotfiles - 现代化、高效的 Wayland 桌面环境配置

---

## 📖 目录

- [项目结构](#-项目结构)
- [快速安装](#-快速安装)
- [核心配置说明](#-核心配置说明)
- [快捷键大全](#-快捷键大全)
- [触摸板手势](#-触摸板手势)
- [强大的 Bashrc 函数库](#-强大的-bashrc-函数库)
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
│   ├── hypr/                        # Hyprland 窗口管理器配置（Lua）
│   │   ├── hyprland.lua             # 主配置文件（快捷键、窗口规则、自启动）
│   │   ├── hyprlock.conf            # 锁屏配置
│   │   ├── hypridle.conf            # 空闲检测/电源管理配置
│   │   ├── scripts/                 # 系统功能脚本（21 个）
│   │   │   ├── AirplaneMode.sh      # 飞行模式切换
│   │   │   ├── Battery.sh           # 电池状态显示
│   │   │   ├── Brightness.sh        # 屏幕亮度调节
│   │   │   ├── BrightnessKbd.sh     # 键盘背光调节
│   │   │   ├── ClipManager.sh       # 剪贴板管理器
│   │   │   ├── KeyHints.sh          # 快捷键提示面板
│   │   │   ├── LockScreen.sh        # 锁屏快捷方式
│   │   │   ├── MediaCtrl.sh         # 媒体播放控制
│   │   │   ├── Polkit.sh            # 权限认证代理
│   │   │   ├── Refresh.sh           # 刷新配置
│   │   │   ├── RofiSearch.sh        # 网络搜索
│   │   │   ├── ScreenShot.sh        # 截图功能（多种模式）
│   │   │   ├── Sounds.sh            # 音效播放
│   │   │   ├── TouchPad.sh          # 触摸板开关
│   │   │   ├── Volume.sh            # 音量控制
│   │   │   ├── WallpaperSelect.sh   # 壁纸选择器
│   │   │   ├── WaybarCava.sh        # Waybar CAVA 可视化
│   │   │   ├── WaybarLayout.sh      # 状态栏布局切换
│   │   │   ├── WaybarStyles.sh      # 状态栏样式切换
│   │   │   └── Wlogout.sh           # 注销/关机菜单
│   │   └── wallust/                 # Wallust 动态主题生成
│   │       ├── wallust-hyprland.conf
│   │       └── wallust.lua
│   ├── kitty/                       # Kitty 终端配置
│   │   ├── kitty.conf               # 主配置文件
│   │   └── kitty-themes/            # 终端主题目录
│   ├── waybar/                      # Waybar 状态栏配置
│   │   ├── style.css                # 当前样式文件（符号链接）
│   │   ├── style/                   # 预设样式库
│   │   │   └── [Wallust] Chroma Tally.css
│   │   └── wallust/                 # Wallust 生成的颜色
│   │       └── colors-waybar.css
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
│   │       ├── clipboard.conf       # 剪贴板设置
│   │       ├── cloudpinyin.conf     # 云拼音
│   │       ├── notifications.conf   # 通知设置
│   │       ├── pinyin.conf          # 拼音输入
│   │       ├── punctuation.conf     # 标点符号
│   │       └── quickphrase.conf     # 快速短语
│   ├── micro/                       # Micro 编辑器配置
│   │   ├── bindings.json            # 键位绑定
│   │   └── plug/                    # 插件目录（6 个插件）
│   │       ├── autofmt/             # 代码格式化
│   │       ├── jump/                # 跳转导航
│   │       ├── lsp/                 # 语言服务器协议
│   │       ├── quickfix/            # 快速修复
│   │       ├── runit/               # 运行工具
│   │       └── snippets/            # 代码片段
│   ├── pypr/                        # Pyprland 增强工具配置
│   │   └── config.toml              # 配置文件
│   ├── qt5ct/                       # Qt5 外观配置
│   │   ├── colors/                  # 颜色主题
│   │   └── qt5ct.conf
│   ├── qt6ct/                       # Qt6 外观配置
│   │   ├── colors/                  # 颜色主题
│   │   └── qt6ct.conf
│   ├── xsettingsd/                  # XSettings 配置
│   │   └── xsettingsd.conf
│   ├── gtk-3.0/                     # GTK3 配置
│   │   ├── gtk.css
│   │   └── settings.ini
│   ├── gtk-4.0/                     # GTK4 配置
│   │   └── settings.ini
│   ├── chrome-flags.conf            # Chrome 标志
│   ├── electron-flags.conf          # Electron 应用标志
│   └── qq-flags.conf                # QQ 标志
├── etc/                             # 系统级配置文件
│   ├── bash.bashrc                  # Bash 全局配置（强大函数库）
│   ├── environment                  # 环境变量
│   ├── makepkg.conf                 # Makepkg 构建配置
│   ├── pacman.conf                  # Pacman 包管理器配置
│   ├── profile                      # Shell Profile
│   ├── safe-rm.conf                 # Safe-rm 保护目录配置
│   ├── tlp.conf                     # TLP 电源管理配置
│   ├── zram-generator.conf          # ZRAM 内存压缩配置
│   └── systemd/                     # Systemd 服务配置
│       ├── journald.conf            # 日志服务配置
│       └── system.conf              # 系统服务配置
├── home/                            # 用户家目录配置
│   └── dot_themes/                  # GTK 主题
│       ├── Flat-Remix-GTK-Blue-Dark
│       └── Flat-Remix-GTK-Blue-Light
├── local/                           # 用户本地数据
│   └── share/
│       └── fcitx5/                  # 输入法主题
│           └── themes/kagami
├── vscode/                          # VSCode 配置
│   └── neovide-cursor.js            # Neovide 光标配置
├── install.sh                       # 自动化安装脚本
├── arch_note.md                     # Arch 安装笔记
└── README.md                        # 项目说明文档
```

### 核心组件说明

| 组件           | 说明                                   | 配置文件路径                                               |
| -------------- | -------------------------------------- | ---------------------------------------------------------- |
| **Hyprland**   | Wayland 合成器（窗口管理器，Lua 配置） | [`config/hypr/hyprland.lua`](./config/hypr/hyprland.lua)   |
| **Waybar**     | 可定制状态栏                           | [`config/waybar/style.css`](./config/waybar/style.css)     |
| **SwayNC**     | 通知中心                               | [`config/swaync/config.json`](./config/swaync/config.json) |
| **Kitty**      | GPU 加速终端                           | [`config/kitty/kitty.conf`](./config/kitty/kitty.conf)     |
| **Bash Shell** | 强大的 Bash 配置与函数库               | [`etc/bash.bashrc`](./etc/bash.bashrc)                     |
| **Hyprlock**   | 锁屏工具                               | [`config/hypr/hyprlock.conf`](./config/hypr/hyprlock.conf) |
| **Rofi**       | 应用启动器/搜索                        | -                                                          |
| **Thunar**     | 文件管理器                             | [`config/Thunar/`](./config/Thunar/)                       |
| **Fcitx5**     | 中文输入法                             | [`config/fcitx5/conf/`](./config/fcitx5/conf/)             |
| **Pyprland**   | 增强工具（下拉终端等）                 | [`config/pypr/config.toml`](./config/pypr/config.toml)     |
| **Cliphist**   | 剪贴板管理器                           | -                                                          |
| **Wlogout**    | 注销/关机菜单                          | [`config/wlogout/style.css`](./config/wlogout/style.css)   |
| **Micro**      | 现代化文本编辑器                       | [`config/micro/`](./config/micro/)                         |

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
- ✅ 部署系统级配置文件（Pacman、Systemd、TLP 等）
- ✅ 部署用户家目录配置（GTK 主题等）
- ✅ 配置 MySQL 数据库服务
- ✅ 创建必要目录
- ✅ 禁用休眠和睡眠目标

### 方式二：手动安装

#### 1. 安装核心依赖

```bash
# 基础系统工具
sudo pacman -S hyprland kitty bash waybar swaync rofi thunar micro fcitx5 fcitx5-chinese-addons cliphist wl-clip-persist fastfetch pyprland wlogout firefox-developer-edition fzf swappy grim slurp hyprpicker eza ripgrep ttf-fira-code ttf-jetbrains-mono ttf-victor-mono-nerd noto-fonts noto-fonts-cjk noto-fonts-emoji hyprshot jq curl perl openssl tmux

# 音频支持
sudo pacman -S pipewire pipewire-alsa wireplumber alsa-firmware alsa-ucm-conf sof-firmware

# 图形驱动（AMD）
sudo pacman -S mesa lib32-mesa xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon amd-ucode

# 网络与蓝牙
sudo pacman -S network-manager-applet bluez bluez-utils blueman pkgfile

# 开发工具
sudo pacman -S nodejs npm jdk21-openjdk android-tools docker docker-compose lazydocker mysql

# 其他实用工具
sudo pacman -S btop clash-verge-rev mihomo localsend nginx syncthing tlp powertop cups cups-filters ghostscript imagemagick mpv loupe obs-studio
```

#### 2. 复制配置文件

```bash
# 复制用户配置（使用符号链接）
ln -s $(pwd)/config/hypr ~/.config/hypr
ln -s $(pwd)/config/kitty ~/.config/kitty
ln -s $(pwd)/config/waybar ~/.config/waybar
ln -s $(pwd)/config/swaync ~/.config/swaync
ln -s $(pwd)/config/wlogout ~/.config/wlogout
ln -s $(pwd)/config/Thunar ~/.config/Thunar
ln -s $(pwd)/config/fcitx5 ~/.config/fcitx5
ln -s $(pwd)/config/micro ~/.config/micro
ln -s $(pwd)/config/pypr ~/.config/pypr
ln -s $(pwd)/config/qt5ct ~/.config/qt5ct
ln -s $(pwd)/config/qt6ct ~/.config/qt6ct
ln -s $(pwd)/config/xsettingsd ~/.config/xsettingsd

# 复制系统级配置
sudo cp etc/pacman.conf /etc/pacman.conf
sudo cp etc/makepkg.conf /etc/makepkg.conf
sudo cp etc/environment /etc/environment
sudo cp etc/systemd/journald.conf /etc/systemd/journald.conf
sudo cp etc/systemd/system.conf /etc/systemd/system.conf
sudo cp etc/tlp.conf /etc/tlp.conf
sudo cp etc/zram-generator.conf /etc/systemd/zram-generator.conf
sudo cp etc/safe-rm.conf /etc/safe-rm.conf

# 部署 Bash 配置
sudo cp etc/bash.bashrc /etc/bash.bashrc

# 部署 Fcitx5 主题
cp -r local/share/fcitx5/themes ~/.local/share/fcitx5/
```

#### 3. 重启 Hyprland

重新登录或重启系统使配置生效。

---

## 📝 核心配置说明

### 主要配置文件详解

#### `config/hypr/hyprland.lua` - 主配置文件（Lua）

**包含内容：**

- **变量定义**：路径、修饰键、默认应用
- **显示器设置**：分辨率、缩放、镜像
- **自启动应用**：输入法、壁纸、状态栏、通知中心等
- **快捷键绑定**：所有键盘快捷键定义
- **窗口规则**：应用自动分配到工作区
- **环境变量**：Wayland 环境变量配置
- **鼠标绑定**：鼠标操作配置
- **触摸板手势**：多指手势配置
- **动画曲线**：窗口动画效果
- **装饰配置**：圆角、模糊、透明度等

### 自启动应用清单

| 应用                | 说明                                   |
| ------------------- | -------------------------------------- |
| **Fcitx5**          | 中文输入法                             |
| **Waybar**          | 状态栏                                 |
| **SwayNC**          | 通知中心                               |
| **AGS**             | Aylur's GTK Shell（状态栏/小部件框架） |
| **Cliphist**        | 剪贴板管理（文本 + 图像）              |
| **wl-clip-persist** | 剪贴板持久化                           |
| **Hypridle**        | 电源管理/锁屏                          |
| **Pyprland**        | 下拉终端/窗口缩放                      |
| **Kitty**           | 终端模拟器                             |
| **Nm-applet**       | 网络管理器                             |
| **Blueman-applet**  | 蓝牙管理器                             |
| **Hyprpolkitagent** | 权限认证代理                           |

### 窗口规则 - 工作区自动分配

| 应用类型     | 工作区 | 匹配的应用                                            |
| ------------ | ------ | ----------------------------------------------------- |
| **浏览器**   | 5      | Firefox, Chrome, Chromium, Edge, Brave, Zen, Thorium  |
| **开发工具** | 4      | VSCode, Android Studio, IntelliJ IDEA, 微信开发者工具 |

### 窗口动画配置

**动画曲线：**

- `wind` - 窗口打开动画
- `winIn` - 窗口进入动画
- `winOut` - 窗口退出动画
- `smoothOut` - 平滑退出
- `smoothIn` - 平滑进入
- `overshot` - 工作区切换动画

**动画效果：**

- 窗口动画：滑动效果，速度 6
- 边框动画：循环渐变，速度 100
- 淡入淡出：速度 3
- 工作区切换：滑动效果，速度 5

### 装饰配置

- **圆角半径**：20px
- **活动窗口不透明度**：0.87
- **非活动窗口不透明度**：0.7
- **全屏窗口不透明度**：0.95
- **模糊效果**：启用，大小 7px，2 次传递
- **边框大小**：2px
- **内外边距**：gaps_in 6px, gaps_out 8px

---

## ⌨️ 快捷键大全

> 💡 **说明**：`` = Super/Win 键，所有快捷键基于 [`config/hypr/hyprland.lua`](./config/hypr/hyprland.lua)

### 🚀 核心功能

| 快捷键         | 功能          | 详细说明                                         |
| -------------- | ------------- | ------------------------------------------------ |
| `  (双击)`   | 应用启动器    | 打开 Rofi 应用启动器（支持搜索、运行、窗口切换） |
| ` T`          | 终端模拟器    | 打开 Kitty 终端                                  |
| ` E`          | 文件管理器    | 打开 Thunar 文件管理器                           |
| ` F`          | 文件浏览器    | 打开 Rofi 文件浏览器                             |
| ` C`          | 关闭当前窗口  | 关闭当前活动窗口                                 |
| ` L`          | 锁定屏幕      | 立即锁定屏幕（Hyprlock）                         |
| `CTRL ALT Del` | 退出 Hyprland | 退出当前 Hyprland 会话                           |

### 🪟 窗口管理

| 快捷键             | 功能           | 详细说明                         |
| ------------------ | -------------- | -------------------------------- |
| `ALT ←/→/↑/↓`      | 切换窗口焦点   | 将焦点移到对应方向的窗口         |
| ` CTRL ←/→/↑/↓`   | 移动窗口位置   | 将窗口向对应方向移动             |
| ` SHIFT ←/→/↑/↓`  | 调整窗口大小   | 以 50 像素为单位调整窗口大小     |
| ` ↑`              | 进入全屏模式   | 切换全屏模式                     |
| ` ↓`              | 进入最大化模式 | 切换最大化模式                   |
| `SHIFT + 鼠标左键` | 拖动窗口       | 按住 Shift+ 鼠标左键拖动窗口     |
| `SHIFT + 鼠标右键` | 调整窗口大小   | 按住 Shift+ 鼠标右键调整窗口大小 |
| ` Z`              | 缩放切换       | Pyprland 窗口缩放功能            |

### 📋 工作区管理

| 快捷键          | 功能                  | 详细说明                              |
| --------------- | --------------------- | ------------------------------------- |
| ` 1-0`         | 切换到工作区 1-10     | 切换到第 1-10 个工作区                |
| `ALT Tab`       | 下一个工作区          | 切换到下一个工作区                    |
| `ALT 滚轮上/下` | 上一个/下一个工作区   | 向上/向下切换工作区                   |
| ` SHIFT 1-0`   | 移动窗口到工作区 1-10 | 将窗口移到第 1-10 工作区并跟随        |
| ` SHIFT [/]`   | 移动到相邻工作区      | 将窗口移到上一个/下一个工作区并跟随   |
| ` CTRL 1-0`    | 静默移到工作区 1-10   | 将窗口移到第 1-10 工作区但不跟随      |
| ` CTRL [/]`    | 静默移到相邻工作区    | 将窗口移到上一个/下一个工作区但不跟随 |
| ` CTRL D`      | 移动到特殊工作区      | 将当前窗口移动到特殊工作区            |
| `ALT U`         | 显示/隐藏特殊工作区   | 切换特殊工作区（scratchpad）可见性    |

### 💻 系统控制

| 快捷键      | 功能           | 详细说明                     |
| ----------- | -------------- | ---------------------------- |
| `CTRL  O`  | 电源管理菜单   | 打开 Wlogout 注销/关机菜单   |
| `CTRL  R`  | 重启系统       | 重启计算机                   |
| `CTRL  P`  | 关机           | 关闭计算机                   |
| ` I`       | 编辑配置文件   | 使用 Micro 编辑 hyprland.lua |
| ` B`       | 切换状态栏显示 | 显示/隐藏 Waybar 状态栏      |
| ` CTRL B`  | 切换状态栏样式 | 切换 Waybar 预设样式         |
| ` ALT B`   | 切换状态栏布局 | 切换 Waybar 布局             |
| ` SHIFT N` | 通知中心       | 切换 SwayNC 通知中心面板     |

### 🛠️ 实用工具

| 快捷键      | 功能           | 详细说明                          |
| ----------- | -------------- | --------------------------------- |
| ` K`       | 下拉式终端     | Pyprland 下拉式终端（类似 Quake） |
| ` R`       | 快速运行命令   | Pyprland 运行对话框               |
| ` V`       | 剪贴板管理器   | 打开 Cliphist 剪贴板历史管理器    |
| ` S`       | 网络搜索       | 使用 Rofi 进行网络搜索            |
| ` W`       | 选择壁纸       | 打开壁纸选择器                    |
| ` SHIFT C` | 屏幕取色器     | 打开 Hyprpicker 屏幕取色器        |
| ` SHIFT B` | Firefox 浏览器 | 启动 Firefox Developer Edition    |
| ` SHIFT V` | VSCode         | 启动 Visual Studio Code           |

### 📸 截图功能

| 快捷键        | 功能             | 详细说明                   |
| ------------- | ---------------- | -------------------------- |
| ` SHIFT S`   | 区域截图(剪贴板) | 选择区域截图并复制到剪贴板 |
| `3指下滑+ALT` | 活动窗口截图     | 截取活动窗口并复制到剪贴板 |
| `3指上滑+ALT` | 锁屏             | 立即锁定屏幕               |
| ` F6`        | 立即截图         | 立即截取整个屏幕           |
| ` SHIFT F6`  | 区域截图         | 选择区域截图               |
| ` CTRL F6`   | 5秒后截图        | 延迟 5 秒后截图            |
| ` ALT F6`    | 10秒后截图       | 延迟 10 秒后截图           |
| `ALT F6`      | 活动窗口截图     | 截取当前活动窗口           |

### 🔊 媒体控制

| 快捷键         | 功能          | 详细说明          |
| -------------- | ------------- | ----------------- |
| `音量增大键`   | 增大音量      | 提高系统音量      |
| `音量减小键`   | 减小音量      | 降低系统音量      |
| `静音键`       | 静音/取消静音 | 切换系统静音      |
| `麦克风静音键` | 麦克风静音    | 切换麦克风静音    |
| `播放/暂停键`  | 播放/暂停     | 控制媒体播放/暂停 |
| `下一曲键`     | 下一曲        | 切换到下一首歌曲  |
| `上一曲键`     | 上一曲        | 切换到上一首歌曲  |
| `停止键`       | 停止播放      | 停止媒体播放      |

### 👆 触摸板手势

| 手势             | 功能           | 详细说明               |
| ---------------- | -------------- | ---------------------- |
| **3指左右滑动**  | 切换工作区     | 水平滑动切换工作区     |
| **3指上滑**      | 切换全屏模式   | 进入/退出全屏模式      |
| **3指下滑**      | 切换全屏模式   | 进入/退出全屏模式      |
| **3指下滑+CTRL** | 关闭窗口       | 关闭当前活动窗口       |
| **4指下滑+CTRL** | 打开终端       | 启动 Kitty 终端        |
| **4指上滑+CTRL** | 打开文件管理器 | 打开 Thunar 文件管理器 |

### 💡 ASUS G15 专用

| 快捷键         | 功能            | 详细说明              |
| -------------- | --------------- | --------------------- |
| `键盘亮度减`   | 降低键盘背光    | 调节键盘背光亮度      |
| `键盘亮度加`   | 提高键盘背光    | 调节键盘背光亮度      |
| `屏幕亮度减`   | 降低屏幕亮度    | 调节屏幕亮度          |
| `屏幕亮度加`   | 提高屏幕亮度    | 调节屏幕亮度          |
| `触摸板开关键` | 启用/禁用触摸板 | 切换触摸板状态        |
| `XF86Launch1`  | ROG 控制中心    | 打开华硕 ROG 控制中心 |
| `XF86Launch3`  | 切换 LED 模式   | 切换键盘 LED 灯效模式 |
| `XF86Launch4`  | 切换性能模式    | 切换 CPU/GPU 性能模式 |

### ✈️ 其他快捷键

| 快捷键       | 功能         | 详细说明         |
| ------------ | ------------ | ---------------- |
| `飞行模式键` | 飞行模式开关 | 切换飞行模式     |
| `睡眠键`     | 系统睡眠     | 系统进入睡眠状态 |

---

## 💪 强大的 Bashrc 函数库

> 💡 **说明**：本配置提供超过 50 个强大的 Bash 函数，大幅提升命令行工作效率。所有函数已预装在 [`etc/bash.bashrc`](./etc/bash.bashrc) 中。

### 🔍 智能文件查找

| 函数       | 功能                             | 用法示例                                       |
| ---------- | -------------------------------- | ---------------------------------------------- |
| `findfile` | 按名称查找文件                   | `findfile pattern` 或 `findfile /path pattern` |
| `finddir`  | 按名称查找目录                   | `finddir pattern` 或 `finddir /path pattern`   |
| `findtext` | 在文件中搜索文本（支持 ripgrep） | `findtext pattern` 或 `findtext /path pattern` |

**特点：**

- 支持递归搜索
- 自动忽略 `.git`、`node_modules` 等无关目录
- 彩色输出，易于阅读
- 限制结果数量，避免刷屏

### 🧹 空目录清理

| 函数         | 功能           | 用法示例                           |
| ------------ | -------------- | ---------------------------------- |
| `rmemptydir` | 递归删除空目录 | `rmemptydir` 或 `rmemptydir /path` |

**特点：**

- 安全保护：拒绝操作系统关键目录
- 迭代清理：多轮扫描确保彻底清理
- 详细反馈：显示每个删除的目录

### 🌐 HTTP 请求封装

| 函数   | 功能           | 用法示例                                           |
| ------ | -------------- | -------------------------------------------------- |
| `get`  | 发送 GET 请求  | `get 'https://api.example.com' 'param=value'`      |
| `post` | 发送 POST 请求 | `post 'https://api.example.com' '{"key":"value"}'` |

**特点：**

- 自动处理 JSON 格式化和美化输出（需要 jq）
- 支持 URL 参数编码
- 详细的错误提示和状态码显示
- 超时保护（10 秒）

### 🛠️ 开发工具

| 函数     | 功能           | 用法示例          |
| -------- | -------------- | ----------------- |
| `genkey` | 生成随机密钥   | `genkey`          |
| `mine`   | 修改文件所有权 | `mine file1 dir1` |

### ✏️ 批量重命名

| 函数          | 功能                 | 用法示例                              |
| ------------- | -------------------- | ------------------------------------- |
| `batchrename` | 正则表达式批量重命名 | `batchrename 'old' 'new' file1 file2` |
| `multirename` | 交互式批量重命名     | `multirename file1 file2`             |

### 🔄 文本替换

| 函数          | 功能             | 用法示例                          |
| ------------- | ---------------- | --------------------------------- |
| `replacetext` | 批量替换文件内容 | `replacetext '*.txt' 'old' 'new'` |

**特点：**

- 支持通配符匹配文件
- 使用 Perl 正则引擎
- 安全的转义处理

### 📦 压缩与目录工具

| 函数    | 功能            | 用法示例           |
| ------- | --------------- | ------------------ |
| `mktar` | 创建 tar 压缩包 | `mktar dir1 file1` |
| `mkcd`  | 创建目录并进入  | `mkcd newdir`      |

### 🎨 智能路径显示

**特性：**

- 自动将 `$HOME` 显示为 `~`
- 符号链接用青色高亮
- 不存在的目录用红色警告
- 彩色分级显示路径层次

### 🌿 Git 版本控制别名

| 别名          | 功能               | 完整命令                                                     |
| ------------- | ------------------ | ------------------------------------------------------------ |
| `g`           | Git 缩写           | `git`                                                        |
| `ginit`       | 初始化仓库         | `git init`                                                   |
| `gclone`      | 克隆仓库（浅克隆） | `git clone --recursive --depth=1`                            |
| `gadd`        | 添加文件           | `git add`                                                    |
| `gcommit`     | 提交更改           | `git commit`                                                 |
| `gupdate`     | 快速提交所有更改   | `git add . && git commit -m "fix bugs and add new features"` |
| `gpush`       | 推送远程           | `git push`                                                   |
| `gpull`       | 拉取远程           | `git pull`                                                   |
| `gsync`       | 同步当前分支       | `git pull origin <branch>`                                   |
| `gsyncrebase` | Rebase 同步        | `git pull --rebase origin <branch>`                          |
| `pushremote`  | 一键推送           | `git add . && commit && pull && push`                        |
| `gstatus`     | 查看状态           | `git status`                                                 |
| `glog`        | 查看日志           | `git log`                                                    |
| `gloggraph`   | 图形化日志         | `git log --graph --oneline --all`                            |
| `gdiff`       | 查看差异           | `git diff`                                                   |
| `greset`      | 硬重置             | `git reset --hard`                                           |
| `gundo`       | 撤销上次提交       | `git reset --soft HEAD~1`                                    |
| `gstash`      | 暂存更改           | `git stash`                                                  |
| `gstashpop`   | 恢复暂存           | `git stash pop`                                              |
| `gwhatchange` | 交互式查看变更     | 选择哈希查看详细                                             |

### 🪟 Tmux 会话管理器

| 函数      | 功能              | 用法示例  |
| --------- | ----------------- | --------- |
| `tmuxmgr` | Tmux 会话管理界面 | `tmuxmgr` |

**功能：**

- 🔗 进入已有会话
- ➕ 创建新会话
- 🗑️ 删除会话
- 基于 FZF 的交互式界面
- 实时会话列表

### 🐳 Docker 容器管理

| 别名/函数  | 功能                 | 用法示例                      |
| ---------- | -------------------- | ----------------------------- |
| `dex`      | 进入容器             | `dex container_name`          |
| `dlogs`    | 查看日志             | `dlogs container_name`        |
| `dstart`   | 启动容器             | `dstart container_name`       |
| `dstop`    | 停止容器             | `dstop container_name`        |
| `drestart` | 重启容器             | `drestart container_name`     |
| `drun`     | 运行临时容器         | `drun image_name`             |
| `drm`      | 强制删除容器         | `drm container_name`          |
| `drmi`     | 强制删除镜像         | `drmi image_name`             |
| `dbuild`   | 构建镜像             | `dbuild tag .`                |
| `dpull`    | 拉取镜像             | `dpull image:tag`             |
| `dps`      | 查看运行中的容器     | `dps`                         |
| `dpsa`     | 查看所有容器         | `dpsa`                        |
| `dimages`  | 查看镜像列表         | `dimages`                     |
| `dcup`     | Docker Compose 启动  | `dcup`                        |
| `dcdown`   | Docker Compose 停止  | `dcdown`                      |
| `dcbuild`  | Docker Compose 构建  | `dcbuild`                     |
| `dtop`     | 容器资源监控         | `dtop`                        |
| `dip`      | 查看容器 IP          | `dip` 或 `dip container_name` |
| `denter`   | 智能进入容器         | `denter container_name`       |
| `dcp`      | 复制文件到容器       | `dcp source dest`             |
| `drestore` | 重置 Docker 环境     | `drestore`                    |
| `dvol`     | 创建并使用数据卷     | `dvol vol_name /path image`   |
| `dvollist` | 列出数据卷及使用情况 | `dvollist`                    |

**Docker Compose 支持：**

- 自动检测 `docker-compose` 或 `docker compose`
- 统一的命令接口

### 🗄️ MySQL 数据库管理

| 别名/函数       | 功能           | 用法示例                          |
| --------------- | -------------- | --------------------------------- |
| `my`            | 连接 MySQL     | `my`                              |
| `my-ls`         | 列出数据库     | `my-ls`                           |
| `my-tables`     | 列出表         | `my-tables`                       |
| `my-conn`       | 查看连接列表   | `my-conn`                         |
| `my-vars`       | 查看变量       | `my-vars`                         |
| `my-backup`     | 备份单个数据库 | `my-backup dbname`                |
| `my-backup-all` | 备份所有数据库 | `my-backup-all`                   |
| `my-restore`    | 恢复数据库     | `my-restore backup.sql.gz dbname` |

**特点：**

- 自动读取 `~/.my.cnf` 配置
- 支持 gzip 压缩备份
- 安全确认机制

### 📋 文件操作别名

| 别名  | 功能         | 完整命令                                             |
| ----- | ------------ | ---------------------------------------------------- |
| `ls`  | 彩色文件列表 | `eza --color=auto --icons --group-directories-first` |
| `l`   | 详细列表     | `eza -lbah --icons`                                  |
| `ll`  | 长格式列表   | `eza -lbg --icons`                                   |
| `la`  | 显示隐藏文件 | `eza -labgh --icons`                                 |
| `lsa` | 递归列表     | `eza -lbagR --icons`                                 |
| `lst` | 按时间排序   | `eza -lTabgh --icons`                                |
| `sl`  | 简单列表     | `eza --icons`                                        |

**注意：** 优先使用 `eza`，其次 `exa`，最后回退到原生 `ls`

### 🧭 快速导航别名

| 别名         | 功能             |
| ------------ | ---------------- |
| `..`         | 上一级目录       |
| `...`        | 上两级目录       |
| `....`       | 上三级目录       |
| `.....`      | 上四级目录       |
| `home`       | 回到主目录       |
| `cache`      | 进入缓存目录     |
| `config`     | 进入配置目录     |
| `localshare` | 进入本地共享目录 |
| `docs`       | 进入文档目录     |
| `downs`      | 进入下载目录     |

### ⚙️ 系统管理别名

| 别名         | 功能             |
| ------------ | ---------------- |
| `sc-start`   | 启动服务         |
| `sc-stop`    | 停止服务         |
| `sc-restart` | 重启服务         |
| `sc-enable`  | 启用服务         |
| `sc-disable` | 禁用服务         |
| `sc-status`  | 查看服务状态     |
| `sc-failed`  | 查看失败的服务   |
| `sc-ls`      | 列出所有服务     |
| `boottime`   | 分析启动时间     |
| `sshd`       | 启动 SSH 服务    |
| `dockerd`    | 启动 Docker 服务 |
| `mysqld`     | 启动 MySQL 服务  |

### 🛠️ 常用工具别名

| 别名            | 功能                                   |
| --------------- | -------------------------------------- |
| `_`             | sudo 缩写                              |
| `sus`           | sudo -s                                |
| `uncd`          | cd -（返回上次目录）                   |
| `e`             | 编辑器（优先 Micro，备选 Vim/Vi/Nano） |
| `vim/nvim/nano` | 统一指向首选编辑器                     |
| `python/py`     | Python3                                |
| `h`             | history                                |
| `grubmk`        | 更新 GRUB 配置                         |
| `btrfszip`      | Btrfs 压缩优化                         |
| `diskinfo`      | 磁盘信息汇总                           |
| `ducks`         | 找出最大的文件/目录                    |
| `dusort`        | 按大小排序目录                         |
| `topcpu`        | CPU 占用前 10 进程                     |
| `topmem`        | 内存占用前 10 进程                     |
| `portproc`      | 查询端口占用进程                       |

### 📝 系统配置文件快速编辑

| 函数            | 编辑的文件                   |
| --------------- | ---------------------------- |
| `bashrc()`      | `/etc/bash.bashrc`           |
| `localeconf()`  | `/etc/locale.gen`            |
| `systemconf()`  | `/etc/systemd/system.conf`   |
| `journalconf()` | `/etc/systemd/journald.conf` |
| `grubconf()`    | `/etc/default/grub`          |
| `makepkgconf()` | `/etc/makepkg.conf`          |

**特点：**

- 自动检测编辑器可用性
- 自动提权编辑只读文件
- 统一的编辑体验

---

## 🎨 自定义指南

### 更换壁纸

1. 将新壁纸放入 `~/Pictures/wallpapers/` 目录
2. 使用 ` W` 选择壁纸
3. 或使用脚本随机切换

### 更换终端主题

1. 从 [`config/kitty/kitty-themes/`](./config/kitty/kitty-themes/) 选择主题
2. 编辑 [`config/kitty/kitty.conf`](./config/kitty/kitty.conf)
3. 修改 `include` 指令指向新主题文件

### 更改主题颜色

主题颜色通过 Wallust 动态生成：

1. 编辑 [`config/hypr/wallust/wallust.lua`](./config/hypr/wallust/wallust.lua)
2. 运行 `~/.config/hypr/scripts/Refresh.sh` 刷新

### 修改状态栏样式

1. 运行 `~/.config/hypr/scripts/WaybarStyles.sh` 选择预设样式
2. 或手动编辑 [`config/waybar/style.css`](./config/waybar/style.css)
3. 运行 `~/.config/hypr/scripts/Refresh.sh` 刷新

### 添加开机自启动

编辑 [`config/hypr/hyprland.lua`](./config/hypr/hyprland.lua)，在 `hyprland.start` 钩子中添加：

```lua
hl.on("hyprland.start", function()
    hl.exec_cmd("你的命令 &")
end)
```

### 自定义快捷键

编辑 [`config/hypr/hyprland.lua`](./config/hypr/hyprland.lua)，参考现有格式添加：

```lua
-- 语法：hl.bind("修饰键 + 按键", hl.dsp.exec_cmd("命令"))
hl.bind("SUPER + X", hl.dsp.exec_cmd("your_command"))
```

### 修改窗口规则

编辑 [`config/hypr/hyprland.lua`](./config/hypr/hyprland.lua)，添加窗口规则：

```lua
hl.window_rule({
    name = "rule-name",
    match = { class = "^AppClass$" },
    workspace = "3"
})
```

### 自定义 Bash 函数

编辑 [`etc/bash.bashrc`](./etc/bash.bashrc) 添加个性化函数：

```bash
# 添加别名
alias ll='eza -la --icons'
alias gs='git status'

# 添加函数
myfunc() {
    echo "Hello World"
}
```

---
