#!/bin/bash

# 快捷键提示。灵感来自 Garuda Hyprland

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
    --title="键盘快捷键" \
    --no-buttons \
    --list \
    --column=按键: \
    --column=描述: \
    --column=命令: \
    --timeout-indicator=bottom \
"ESC" "关闭此应用" "" "=" "超级键 (Windows键)" "(主修饰键)" \
\
"═══════════ 核心功能 ═══════════" "" "" \
" D" "应用启动器" "(rofi drun)" \
" T" "终端" "(kitty)" \
" E" "文件管理器" "(thunar)" \
" F" "文件浏览器" "(rofi filebrowser)" \
" C" "关闭窗口" "(killactive)" \
" L" "锁屏" "(hyprlock)" \
"CTRL ALT Del" "退出Hyprland" "(exit)" \
\
"═══════════ 窗口管理 ═══════════" "" "" \
"ALT ←/→/↑/↓" "切换窗口焦点" "(movefocus)" \
" CTRL ←/→/↑/↓" "移动窗口位置" "(movewindow)" \
" SHIFT ←/→/↑/↓" "调整窗口大小" "(resizeactive ±50)" \
" ↑" "进入全屏" "(fullscreen 1)" \
" ↓" "退出全屏" "(fullscreen 0)" \
"SHIFT + 鼠标左键" "拖动窗口" "(movewindow)" \
"SHIFT + 鼠标右键" "调整窗口大小" "(resizewindow)" \
" Z" "缩放切换" "(pypr zoom)" \
\
"═══════════ 工作区管理 ═══════════" "" "" \
" 1-0" "切换到工作区1-10" "(workspace)" \
"ALT Tab" "下一个工作区" "(workspace e+1)" \
"ALT 滚轮上/下" "上一个/下一个工作区" "(workspace e±1)" \
" SHIFT 1-0" "移动窗口到工作区1-10" "(movetoworkspace)" \
" SHIFT [/]" "移动窗口到上/下一个工作区" "(movetoworkspace ±1)" \
" CTRL 1-0" "静默移到工作区1-10" "(movetoworkspacesilent)" \
" CTRL [/]" "静默移到上/下一个工作区" "(movetoworkspacesilent ±1)" \
" CTRL D" "移动到特殊工作区" "(movetoworkspace special)" \
"ALT U" "显示/隐藏特殊工作区" "(togglespecialworkspace)" \
\
"═══════════ 系统控制 ═══════════" "" "" \
"CTRL   O" "电源菜单" "(wlogout)" \
"CTRL   R" "重启系统" "(reboot)" \
"CTRL   P" "关机" "(poweroff)" \
" I" "编辑配置文件" "(micro hyprland.conf)" \
" B" "切换状态栏" "(waybar)" \
" CTRL B" "切换状态栏样式" "(WaybarStyles.sh)" \
" ALT B" "切换状态栏布局" "(WaybarLayout.sh)" \
" SHIFT N" "通知中心" "(swaync-client)" \
\
"═══════════ 实用工具 ═══════════" "" "" \
" K" "下拉终端" "(pypr toggle term)" \
" R" "运行命令" "(pypr toggle run)" \
" V" "剪贴板管理器" "(ClipManager.sh)" \
" S" "网络搜索" "(RofiSearch.sh)" \
" W" "选择壁纸" "(WallpaperSelect.sh)" \
" SHIFT C" "屏幕取色器" "(hyprpicker)" \
" SHIFT B" "Firefox浏览器" "(firefox-developer-edition)" \
" SHIFT V" "VSCode编辑器" "(code)" \
\
"═══════════ 截图功能 ═══════════" "" "" \
" SHIFT S" "区域截图(剪贴板)" "(hyprshot -m region)" \
"3指下滑+ALT" "活动窗口截图" "(hyprshot -m window)" \
"3指上滑+ALT" "锁屏" "(hyprlock)" \
\
"═══════════ 媒体控制 ═══════════" "" "" \
"音量增大键" "增大音量" "(Volume.sh --inc)" \
"音量减小键" "减小音量" "(Volume.sh --dec)" \
"静音键" "静音/取消静音" "(Volume.sh --toggle)" \
"麦克风静音键" "麦克风静音" "(Volume.sh --toggle-mic)" \
"播放/暂停键" "播放/暂停" "(MediaCtrl.sh --pause)" \
"下一曲键" "下一曲" "(MediaCtrl.sh --nxt)" \
"上一曲键" "上一曲" "(MediaCtrl.sh --prv)" \
"停止键" "停止播放" "(MediaCtrl.sh --stop)" \
\
"═══════════ 触摸板手势 ═══════════" "" "" \
"3指左右滑动" "切换工作区" "(workspace)" \
"3指下滑" "退出全屏" "(fullscreen 0)" \
"3指上滑" "进入全屏" "(fullscreen 1)" \
"3指下滑+CTRL" "关闭窗口" "(close)" \
"4指下滑+CTRL" "打开终端" "(kitty)" \
"4指上滑+CTRL" "打开文件管理器" "(thunar)" \
\
"═══════════ 其他快捷键 ═══════════" "" "" \
"飞行模式键" "飞行模式开关" "(AirplaneMode.sh)" \
"睡眠键" "系统睡眠" "(systemctl suspend)" \
"" "" "" \
"欢迎参观:" "https://libregml.github.io"\
", 另外该面板文件位于:" "$HOME/.config/hypr/scripts/KeyHints.sh" ""\
