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
| `SUPER` + `Enter` | 打开终端 (kitty) |
| `SUPER` + `Shift` + `T` | 打开终端 (kitty) |
| `SUPER` + `Shift` + `F` | 切换浮动模式 |
| `SUPER` + `Shift` + `A` | 切换所有窗口为浮动模式 |
| `SUPER` + `F` | 全屏切换 |
| `SUPER` + `C` | 关闭窗口 |
| `SUPER` + `Shift` + `Q` | 强制关闭窗口 |
| `SUPER` + `ALT` + `L` | 切换 Dwindle/Master 布局 |
| `SUPER` + `Shift` + `M` | 云音乐播放器 |
| `SUPER` + `W` | 选择壁纸 |
| `CTRL` + `ALT` + `W` | 随机壁纸 |
| `SUPER` + `Shift` + `W` | 壁纸特效 |

### 系统控制

| 快捷键 | 功能 |
|--------|------|
| `CTRL` + `ALT` + `U` | 切换浮动/平铺模式 |
| `CTRL` + `ALT` + `O` | 退出界面 (wlogout) |
| `SUPER` + `ALT` + `C` | 计算器 (qalculate) |
| `SUPER` + `ALT` + `R` | 刷新 Waybar, SwayNC, Rofi |
| `SUPER` + `ALT` + `E` | Rofi 表情符号 |
| `SUPER` + `S` | Rofi 搜索 (Bing) |
| `SUPER` + `V` | 剪贴板管理器 (cliphist) |
| `SHIFT` + `ALT` | 切换键盘布局 |
| `SUPER` + `Shift` + `N` | 打开通知面板 (swaync) |
| `SUPER` + `B` | 显示/隐藏状态栏 |
| `SUPER` + `CTRL` + `B` | 选择 Waybar 样式 |
| `SUPER` + `ALT` + `B` | 选择 Waybar 布局 |

### 应用启动器

| 快捷键 | 功能 |
|--------|------|
| `SUPER` + `D` | 打开应用启动器 (rofi) |
| `SUPER` + `SUPER_L` | 打开应用启动器 (rofi) |
| `SUPER` + `Shift` + `F` | 打开文件管理器 (thunar) |
| `SUPER` + `Shift` + `Q` | QQ |
| `SUPER` + `Shift` + `E` | Firefox Nightly |
| `SUPER` + `Shift` + `W` | 微信 |
| `SUPER` + `Shift` + `C` | VSCode |

### 系统操作

| 快捷键 | 功能 |
|--------|------|
| `CTRL` + `SUPER` + `R` | 重启 |
| `CTRL` + `SUPER` + `P` | 关机 |
| `CTRL` + `SUPER` + `L` | 锁屏 (hyprlock) |
| `CTRL` + `ALT` + `Delete` | 退出 Hyprland |
| `Print` | 截图 (grim) |
| `Shift` + `Print` | 区域截图 (grim + slurp) |
| `Shift` + `S` | 区域截图 (swappy) |
| `CTRL` + `Print` | 5秒延时截图 |
| `CTRL` + `SHIFT` + `Print` | 10秒延时截图 |
| `ALT` + `Print` | 活动窗口截图 |
| `SUPER` + `K` | 下拉终端 (pypr) |
| `SUPER` + `Z` | 桌面缩放 (pypr) |

### 其他功能

| 快捷键 | 功能 |
|--------|------|
| `SUPER` + `Shift` + `B` | 切换模糊效果 |
| `SUPER` + `Shift` + `G` | 游戏模式 (关闭动画) |
| `SUPER` + `H` | 快捷键帮助 |
| `SUPER` + `E` | 查看/编辑配置文件 |

## 🤝 贡献

欢迎提交 Issue 和 Pull Request 来帮助改进这个项目！

## 📄 许可证

本项目采用 [MIT License](./LICENSE) 许可证。

## 🙏 鸣谢

- [Hyprland](https://github.com/hyprwm/Hyprland) - 非常棒的动态平铺 Wayland 合成器
- [wallust](https://github.com/mikar314/wallust) - 从壁纸提取配色的工具
- [JaKooLit](https://github.com/JaKooLit) - 提供了大量脚本和配置灵感