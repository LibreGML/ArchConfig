#!/bin/bash

# 快捷键提示面板 - 基于 Hyprland Lua 配置
# 灵感来自 Garuda Hyprland

# GDK 后端。如有问题可更改为 wayland 或 x11
BACKEND=wayland

# 检测显示器分辨率和缩放比例
x_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
y_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .height')
hypr_scale=$(hyprctl -j monitors | jq '.[] | select (.focused == true) | .scale' | sed 's/\.//')

# 根据百分比和显示器分辨率计算宽高
width=$((x_mon * hypr_scale / 100))
height=$((y_mon * hypr_scale / 100))

# 设置最大宽度和高度
max_width=1200
max_height=1000

# 设置动态调整的屏幕尺寸百分比
percentage_width=70
percentage_height=70

# 计算动态宽高
dynamic_width=$((width * percentage_width / 100))
dynamic_height=$((height * percentage_height / 100))

# 限制宽高不超过最大值
dynamic_width=$(($dynamic_width > $max_width ? $max_width : $dynamic_width))
dynamic_height=$(($dynamic_height > $max_height ? $max_height : $dynamic_height))

# 使用计算出的宽高启动 yad
GDK_BACKEND=$BACKEND yad --width=$dynamic_width --height=$dynamic_height \
    --center \
    --title="⌨️ 键盘快捷键" \
    --no-buttons \
    --list \
    --column=按键: \
    --column=描述: \
    --column=命令: \
    --timeout-indicator=bottom \
"ESC" "关闭此面板" "" \
" (Super)" "主修饰键 (Windows键)" "(基础组合键)" \
\
"═══════════ 🚀 核心功能 ═══════════" "" "" \
"  (双击)" "应用启动器" "(rofi drun)" \
" T" "终端模拟器" "(kitty)" \
" E" "文件管理器" "(thunar)" \
" F" "文件浏览器" "(rofi filebrowser)" \
" C" "关闭当前窗口" "(killactive)" \
" L" "锁定屏幕" "(hyprlock)" \
"CTRL ALT Del" "退出 Hyprland" "(exit session)" \
\
"═══════════ 🪟 窗口管理 ═══════════" "" "" \
"ALT ←/→/↑/↓" "切换窗口焦点" "(movefocus)" \
" CTRL ←/→/↑/↓" "移动窗口位置" "(movewindow)" \
" SHIFT ←/→/↑/↓" "调整窗口大小" "(resizeactive ±50)" \
" ↑" "进入全屏模式" "(fullscreen toggle)" \
" ↓" "进入最大化模式" "(maximized toggle)" \
"SHIFT + 鼠标左键" "拖动窗口" "(movewindow)" \
"SHIFT + 鼠标右键" "调整窗口大小" "(resizewindow)" \
" Z" "缩放切换" "(pypr zoom)" \
\
"═══════════ 📋 工作区管理 ═══════════" "" "" \
" 1-0" "切换到工作区 1-10" "(workspace)" \
"ALT Tab" "下一个工作区" "(workspace e+1)" \
"ALT 滚轮上/下" "上一个/下一个工作区" "(workspace e±1)" \
" SHIFT 1-0" "移动窗口到工作区 1-10" "(movetoworkspace)" \
" SHIFT [/]" "移动窗口到相邻工作区" "(movetoworkspace ±1)" \
" CTRL 1-0" "静默移到工作区 1-10" "(movetoworkspacesilent)" \
" CTRL [/]" "静默移到相邻工作区" "(movetoworkspacesilent ±1)" \
" CTRL D" "移动到特殊工作区" "(movetoworkspace special)" \
"ALT U" "显示/隐藏特殊工作区" "(togglespecialworkspace)" \
\
"═══════════ 💻 系统控制 ═══════════" "" "" \
"CTRL  O" "电源管理菜单" "(wlogout)" \
"CTRL  R" "重启系统" "(systemctl reboot)" \
"CTRL  P" "关机" "(systemctl poweroff)" \
" I" "编辑配置文件" "(fresh hyprland.lua)" \
" B" "切换状态栏显示" "(waybar toggle)" \
" CTRL B" "切换状态栏样式" "(WaybarStyles.sh)" \
" ALT B" "切换状态栏布局" "(WaybarLayout.sh)" \
" SHIFT N" "通知中心" "(swaync-client)" \
\
"═══════════ 🛠️ 实用工具 ═══════════" "" "" \
" K" "下拉式终端" "(pypr toggle term)" \
" R" "快速运行命令" "(pypr toggle run)" \
" V" "剪贴板管理器" "(ClipManager.sh)" \
" S" "网络搜索" "(RofiSearch.sh)" \
" W" "选择壁纸" "(WallpaperSelect.sh)" \
" SHIFT C" "屏幕取色器" "(hyprpicker)" \
" SHIFT B" "Firefox 浏览器" "(firefox)" \
" SHIFT V" "VSCode 编辑器" "(code)" \
\
"═══════════ 📸 截图功能 ═══════════" "" "" \
" SHIFT S" "区域截图(剪贴板)" "(hyprshot region)" \
"3指下滑+ALT" "活动窗口截图" "(hyprshot window)" \
"3指上滑+ALT" "锁屏" "(hyprlock)" \
" F6" "立即截图" "(ScreenShot.sh --now)" \
" SHIFT F6" "区域截图" "(ScreenShot.sh --area)" \
" CTRL F6" "5秒后截图" "(ScreenShot.sh --in5)" \
" ALT F6" "10秒后截图" "(ScreenShot.sh --in10)" \
"ALT F6" "活动窗口截图" "(ScreenShot.sh --active)" \
\
"═══════════ 🔊 媒体控制 ═══════════" "" "" \
"音量增大键" "增大音量" "(Volume.sh --inc)" \
"音量减小键" "减小音量" "(Volume.sh --dec)" \
"静音键" "静音/取消静音" "(Volume.sh --toggle)" \
"麦克风静音键" "麦克风静音" "(Volume.sh --toggle-mic)" \
"播放/暂停键" "播放/暂停" "(MediaCtrl.sh --pause)" \
"下一曲键" "下一曲" "(MediaCtrl.sh --nxt)" \
"上一曲键" "上一曲" "(MediaCtrl.sh --prv)" \
"停止键" "停止播放" "(MediaCtrl.sh --stop)" \
\
"═══════════ 👆 触摸板手势 ═══════════" "" "" \
"3指左右滑动" "切换工作区" "(workspace switch)" \
"3指上滑" "切换全屏模式" "(fullscreen toggle)" \
"3指下滑" "切换全屏模式" "(fullscreen toggle)" \
"3指下滑+CTRL" "关闭窗口" "(close window)" \
"4指下滑+CTRL" "打开终端" "(kitty)" \
"4指上滑+CTRL" "打开文件管理器" "(thunar)" \
\
"═══════════ 💡 ASUS G15 专用 ═══════════" "" "" \
"键盘亮度减" "降低键盘背光" "(BrightnessKbd.sh --dec)" \
"键盘亮度加" "提高键盘背光" "(BrightnessKbd.sh --inc)" \
"屏幕亮度减" "降低屏幕亮度" "(Brightness.sh --dec)" \
"屏幕亮度加" "提高屏幕亮度" "(Brightness.sh --inc)" \
"触摸板开关键" "启用/禁用触摸板" "(TouchPad.sh)" \
"XF86Launch1" "ROG 控制中心" "(rog-control-center)" \
"XF86Launch3" "切换 LED 模式" "(asusctl led-mode)" \
"XF86Launch4" "切换性能模式" "(asusctl profile)" \
\
"═══════════ ✈️ 其他快捷键 ═══════════" "" "" \
"飞行模式键" "飞行模式开关" "(AirplaneMode.sh)" \
"睡眠键" "系统睡眠" "(systemctl suspend)" \
"" "" "" \
"🌐 更多信息:" "https://libregml.github.io"\
", 📄 配置文件:" "$HOME/.config/hypr/hyprland.lua"\
", 📝 脚本目录:" "$HOME/.config/hypr/scripts/" ""
