# ArchConfig

> 🌟 Arch Linux Hyprland 配置集合，包含完整的桌面环境配置

<div align="center">

[![GitHub stars](https://img.shields.io/github/stars/tzgml/ArchConfig?style=social)](https://github.com/tzgml/ArchConfig)
[![GitHub forks](https://img.shields.io/github/forks/tzgml/ArchConfig?style=social)](https://github.com/tzgml/ArchConfig)
[![License](https://img.shields.io/github/license/tzgml/ArchConfig)](https://github.com/tzgml/ArchConfig/blob/main/LICENSE)

</div>

## 📖 目录

- [介绍](#介绍)
- [功能特性](#功能特性)
- [组件构成](#组件构成)
- [屏幕截图](#屏幕截图)
- [安装](#安装)
- [自定义](#自定义)
- [快捷键](#快捷键)
- [贡献](#贡献)
- [许可证](#许可证)

## 📖 介绍

这是一个为 Arch Linux 系统配置 Hyprland 桌面环境的完整配置集合。它包含了窗口管理器、状态栏、通知中心、终端、编辑器等所有必要的组件配置，旨在创建一个美观、高效且功能强大的 Linux 桌面体验。

## ✨ 功能特性

- 🌈 **动态主题**: 通过 wallust 实现的动态主题系统，根据壁纸自动调整配色
- ⚡ **快速启动**: 优化的启动脚本和延迟加载
- 🎨 **美观界面**: 现代化的 UI 设计和动画效果
- 🧩 **模块化设计**: 各组件独立配置，易于自定义
- 🔧 **丰富的脚本**: 提供多种自动化脚本

## 🧩 组件构成

### 窗口管理器
- **Hyprland**: 基于 wlroots 的动态平铺 Wayland 合成器
- **配置文件**: [hyprland.conf](./hypr/hyprland.conf) - 主配置文件

### 状态栏
- **Waybar**: 高度可定制的状态栏
- **样式**: 多种主题可选 ([查看样式](./waybar/style/))

### 通知中心
- **SwayNotificationCenter**: Wayland 原生通知中心
- **配置**: [config.json](./swaync/config.json) 和 [style.css](./swaync/style.css)

### 终端
- **Kitty**: GPU 加速的终端模拟器
- **主题**: 包含 150+ 预设主题 ([kitty-themes](./kitty/kitty-themes/))

### 编辑器
- **Neovim**: 高效的文本编辑器
- **配置**: [init.lua](./nvim/init.lua) - 使用 Lua 编写的配置

### 锁屏
- **Hyprlock**: Hyprland 专用锁屏器
- **配置**: [hyprlock.conf](./hypr/hyprlock.conf) - 支持多种分辨率

### 脚本工具
- **自动化脚本**: 位于 [hypr/scripts](./hypr/scripts/) 目录
- **用户脚本**: 位于 [hypr/UserScripts](./hypr/UserScripts/) 目录

## 🖼️ 屏幕截图

### Terminal
![home](https://github.com/user-attachments/assets/7b01431f-8c07-4685-a4a4-a26aff4b00e7)
![nvim](https://github.com/user-attachments/assets/6129ac65-031d-4195-b507-0c30ece7ff55)

### Linuxqq
<img width="1920" height="1080" alt="linuxqq" src="https://github.com/user-attachments/assets/ad27050d-86ca-4248-9821-5bcf0979c5a4" />

### Android Studio
<img width="1896" height="1016" alt="Screenshot_30-12月_10-31-42_jetbrains-studio" src="https://github.com/user-attachments/assets/9cf36826-884e-445e-9891-d4299902f8d1" />

### VScode
![vscode](https://github.com/user-attachments/assets/ef4abd6e-a841-4471-bb94-15cebd2283ec)

## 🔧 安装

### 前提条件

确保已安装以下包:
```bash
sudo pacman -S hyprland kitty waybar swaync rofi
```

### 安装步骤

1. 备份当前配置:
```bash
mv ~/.config/hypr ~/.config/hypr.bak
```

2. 克隆配置:
```bash
git clone https://github.com/tzgml/ArchConfig.git
```

3. 复制配置:
```bash
cp -r ArchConfig/hypr ~/.config/
cp -r ArchConfig/kitty ~/.config/
cp -r ArchConfig/waybar ~/.config/
cp -r ArchConfig/swaync ~/.config/
cp -r ArchConfig/nvim ~/.config/
```

4. 重启 Hyprland 或重新登录

## 🎨 自定义

### 更改主题

1. 修改 [wallust.toml](./wallust/wallust.toml) 中的 `palette` 选项
2. 运行 `Refresh.sh` 脚本来应用更改

### 更改状态栏样式

1. 运行 `~/.config/hypr/scripts/WaybarStyles.sh` 选择样式
2. 或手动编辑 `~/.config/waybar/config` 和 `~/.config/waybar/style.css`

### 更改终端主题

1. 从 `~/.config/kitty/kitty-themes/` 目录中选择主题
2. 修改 `~/.config/kitty/kitty.conf` 中的 `include` 指令

## ⌨️ 快捷键

### 窗口管理

| 快捷键 | 功能 |
|--------|------|
| `WIN` + `C` | 关闭当前窗口 |
| `WIN` + `F` | 打开文件浏览器 |
| `WIN` + `Up` | 退出全屏模式 |
| `WIN` + `Down` | 进入全屏模式 |
| `WIN` + `Shift` + `Left` | 向左缩小窗口宽度50像素 |
| `WIN` + `Shift` + `Right` | 向右扩大窗口宽度50像素 |
| `WIN` + `Shift` + `Up` | 向上缩小窗口高度50像素 |
| `WIN` + `Shift` + `Down` | 向下扩大窗口高度50像素 |
| `WIN` + `Ctrl` + `Left` | 将窗口向左移动 |
| `WIN` + `Ctrl` + `Right` | 将窗口向右移动 |
| `WIN` + `Ctrl` + `Up` | 将窗口向上移动 |
| `WIN` + `Ctrl` + `Down` | 将窗口向下移动 |

### 工作区管理

| 快捷键 | 功能 |
|--------|------|
| `Ctrl` + `数字键1-0` | 切换到对应工作区 (1-10) |
| `WIN` + `Shift` + `数字键1-0` | 将当前窗口移动到指定工作区 |
| `WIN` + `Shift` + `[` | 将当前窗口移动到上一个工作区 |
| `WIN` + `Shift` + `]` | 将当前窗口移动到下一个工作区 |
| `WIN` + `Ctrl` + `数字键1-0` | 将当前窗口静默移动到指定工作区 |
| `WIN` + `Ctrl` + `[` | 将当前窗口静默移动到上一个工作区 |
| `WIN` + `Ctrl` + `]` | 将当前窗口静默移动到下一个工作区 |
| `Alt` + `鼠标滚轮向上` | 切换到上一个工作区 |
| `Alt` + `鼠标滚轮向下` | 切换到下一个工作区 |
| `Alt` + `Tab` | 切换到下一个工作区 |
| `WIN` + `Right` | 切换到下一个工作区 |

### 应用启动器

| 快捷键 | 功能 |
|--------|------|
| `WIN` + `WIN_L` | 打开应用启动器 (rofi) |
| `WIN` + `D` | 打开应用启动器 (rofi) |
| `WIN` + `T` | 打开终端 (kitty) |
| `WIN` + `E` | 打开文件管理器 (thunar) |
| `WIN` + `Shift` + `B` | 打开Firefox Nightly浏览器 |
| `WIN` + `Shift` + `C` | 打开屏幕取色器 (hyprpicker) |

### 系统控制

| 快捷键 | 功能 |
|--------|------|
| `Ctrl` + `Alt` + `Delete` | 退出Hyprland |
| `Ctrl` + `Alt` + `O` | 打开注销菜单 (wlogout) |
| `WIN` + `L` | 锁定屏幕 (hyprlock) |
| `WIN` + `I` | 编辑Hyprland配置文件 |
| `Ctrl` + `WIN` + `R` | 重启系统 |
| `Ctrl` + `WIN` + `P` | 关闭系统 |

### 实用功能

| 快捷键 | 功能 |
|--------|------|
| `WIN` + `Alt` + `R` | 刷新Waybar、SwayNC、Rofi |
| `WIN` + `S` | 打开Rofi网络搜索 |
| `WIN` + `V` | 打开剪贴板管理器 |
| `WIN` + `Shift` + `N` | 切换通知中心面板 |
| `WIN` + `K` | 切换下拉终端 (pypr) |
| `WIN` + `Z` | 切换窗口缩放/聚焦模式 |
| `WIN` + `B` | 切换状态栏可见性 |
| `WIN` + `Ctrl` + `B` | 更改状态栏样式 |
| `WIN` + `Alt` + `B` | 更改状态栏布局 |

### 媒体和音频控制

| 快捷键 | 功能 |
|--------|------|
| `XF86AudioRaiseVolume` | 音量增大 |
| `XF86AudioLowerVolume` | 音量减小 |
| `XF86AudioMute` | 开关静音 |
| `XF86AudioMicMute` | 开关麦克风静音 |
| `XF86AudioPlayPause` | 播放/暂停媒体 |
| `XF86AudioPause` | 暂停媒体 |
| `XF86AudioPlay` | 播放媒体 |
| `XF86AudioNext` | 下一曲 |
| `XF86AudioPrev` | 上一曲 |
| `XF86AudioStop` | 停止媒体播放 |

### 屏幕截图

| 快捷键 | 功能 |
|--------|------|
| `Shift` + `Print` | 立即截图 |
| `Ctrl` + `Print` | 截取选定区域 |
| `WIN` + `Ctrl` + `Print` | 5秒后截图 |
| `WIN` + `Alt` + `Print` | 10秒后截图 |
| `Alt` + `Print` | 截取活动窗口 |
| `WIN` + `Shift` + `S` | 截图并编辑 |

### 壁纸控制

| 快捷键 | 功能 |
|--------|------|
| `WIN` + `W` | 选择新壁纸 |
| `Ctrl` + `Alt` + `W` | 随机更换壁纸 |

### 窗口焦点与特殊操作

| 快捷键 | 功能 |
|--------|------|
| `Alt` + `Left` | 将焦点移到左侧窗口 |
| `Alt` + `Right` | 将焦点移到右侧窗口 |
| `Alt` + `Up` | 将焦点移到上方窗口 |
| `Alt` + `Down` | 将焦点移到下方窗口 |
| `WIN` + `Ctrl` + `D` | 将当前窗口移动到特殊工作区 |
| `Alt` + `U` | 显示/隐藏特殊工作区 |

### 鼠标与触摸板手势

| 快捷键 | 功能 |
|--------|------|
| `Shift` + `鼠标左键` | 移动窗口 |
| `Shift` + `鼠标右键` | 调整窗口大小 |
| `三指水平滑动` | 切换工作区 |
| `三指下滑` | 退出全屏 |
| `三指上滑` | 进入全屏 |
| `四指下滑+Ctrl` | 打开终端 |
| `四指上滑+Ctrl` | 打开文件管理器 |
| `三指下滑+Alt` | 截图并编辑 |
| `三指上滑+Alt` | 截图并编辑 |

## 🤝 贡献

欢迎提交 Issue 和 Pull Request 来帮助改进这个项目！

## 📄 许可证

本项目采用 [MIT License](./LICENSE) 许可证。

## 🙏 鸣谢

- [Hyprland](https://github.com/hyprwm/Hyprland) - 非常棒的动态平铺 Wayland 合成器
- [wallust](https://github.com/mikar314/wallust) - 从壁纸提取配色的工具
- [JaKooLit](https://github.com/JaKooLit) - 提供了大量脚本和配置灵感