-- ══════════════════════════════════════════════════════════════════════════════
-- 变量定义
-- ══════════════════════════════════════════════════════════════════════════════

local home = os.getenv("HOME")
Colors = require("wallust.wallust")

local scriptsDir = home .. "/.config/hypr/scripts"
local wallDIR = home .. "/Pictures/wallpapers"
local lock = scriptsDir .. "/LockScreen.sh"

local mainMod = "SUPER"
local files = "thunar"
local term = "kitty"



-- ══════════════════════════════════════════════════════════════════════════════
-- 显示器配置
-- ══════════════════════════════════════════════════════════════════════════════

hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1.25, mirror = "HDMI-A-1" })

hl.on("monitor.added", function(m) 
    if m.name == "HDMI-A-1" then
        hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 2.0, mirror = "HDMI-A-1" }) 
        hl.exec_cmd('PIC=$(find "$HOME"/Pictures/wallpapers -type f | shuf -n 1); [ -n "$PIC" ] && awww img "$PIC" --transition-fps 60 --transition-type any --transition-duration 2')
    end 
end)

hl.on("monitor.removed", function(m) 
    if m.name == "HDMI-A-1" then 
        hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1.25, mirror = "HDMI-A-1" }) 
        hl.exec_cmd('PIC=$(find "$HOME"/Pictures/wallpapers -type f | shuf -n 1); [ -n "$PIC" ] && awww img "$PIC" --transition-fps 60 --transition-type any --transition-duration 2')
    end 
end)


-- ══════════════════════════════════════════════════════════════════════════════
-- 系统服务和应用启动
-- ══════════════════════════════════════════════════════════════════════════════

hl.on("hyprland.start", function()
    hl.exec_cmd(scriptsDir .. "/Polkit.sh")    
    hl.exec_cmd("kitty & waybar & nm-applet --indicator & swaync & ags & blueman-applet & hypridle & pypr")    
    hl.exec_cmd("fcitx5 -d")    
    hl.exec_cmd("wl-paste --type text --watch cliphist store & wl-paste --type image --watch cliphist store & wl-clip-persist --clipboard regular")
    hl.exec_cmd("awww-daemon --format xrgb")    
    -- hl.exec_cmd("hyprpaper")  -- hyprpaper只用于Debian等非Arch发行版
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")    
    hl.exec_cmd("sudo systemctl start mysqld")    
end)


-- ══════════════════════════════════════════════════════════════════════════════
-- 键位绑定
-- ══════════════════════════════════════════════════════════════════════════════

-- ── 基础窗口操作 ──
hl.bind("SUPER + C", hl.dsp.window.close())
hl.bind("SUPER + F", hl.dsp.exec_cmd("pkill rofi || rofi -show filebrowser -modi filebrowser,run,window,drun"))

-- ── 窗口移动 ──
hl.bind("SUPER + CTRL + left", hl.dsp.window.move({ direction = "left" }))
hl.bind("SUPER + CTRL + right", hl.dsp.window.move({ direction = "right" }))
hl.bind("SUPER + CTRL + up", hl.dsp.window.move({ direction = "up" }))
hl.bind("SUPER + CTRL + down", hl.dsp.window.move({ direction = "down" }))

-- ── 调整窗口大小 ──
hl.bind("SUPER + SHIFT + left", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + SHIFT + right", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + SHIFT + up", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
hl.bind("SUPER + SHIFT + down", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })

-- ── 焦点切换 ──
hl.bind("ALT + left", hl.dsp.focus({ direction = "left" }))
hl.bind("ALT + right", hl.dsp.focus({ direction = "right" }))
hl.bind("ALT + up", hl.dsp.focus({ direction = "up" }))
hl.bind("ALT + down", hl.dsp.focus({ direction = "down" }))

-- ── 全屏控制 ──
hl.bind("SUPER + up", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind("SUPER + down", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))

-- ── 特殊工作区 ──
hl.bind("SUPER + CTRL + D", hl.dsp.window.move({ workspace = "special" }))
hl.bind("ALT + U", hl.dsp.workspace.toggle_special(""))

-- ── 工作区切换 ──
for i = 1, 10 do
    local code = 9 + i
    hl.bind("SUPER + code:" .. code, hl.dsp.focus({ workspace = tostring(i) }))
    hl.bind("SUPER + SHIFT + code:" .. code, hl.dsp.window.move({ workspace = tostring(i) }))
    hl.bind("SUPER + CTRL + code:" .. code, hl.dsp.window.move({ workspace = tostring(i), follow = false }))
end

hl.bind("SUPER + SHIFT + bracketleft", hl.dsp.window.move({ workspace = "-1" }))
hl.bind("SUPER + SHIFT + bracketright", hl.dsp.window.move({ workspace = "+1" }))
hl.bind("SUPER + CTRL + bracketleft", hl.dsp.window.move({ workspace = "-1", follow = false }))
hl.bind("SUPER + CTRL + bracketright", hl.dsp.window.move({ workspace = "+1", follow = false }))

-- ── 工作区浏览 ──
hl.bind("ALT + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("ALT + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("ALT + tab", hl.dsp.focus({ workspace = "e+1" }))

-- ── 应用启动器 ──
hl.bind("SUPER + SUPER_L", hl.dsp.exec_cmd("pkill rofi || rofi -show drun -modi drun,filebrowser,run,window"), { release = true })
hl.bind("SUPER + T", hl.dsp.exec_cmd(term))
hl.bind("SUPER + E", hl.dsp.exec_cmd(files))
hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd("firefox"))
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"))
hl.bind("SUPER + SHIFT + V", hl.dsp.exec_cmd("code"))

-- ── 系统控制 ──
hl.bind("CTRL + ALT + Delete", hl.dsp.exit())
hl.bind("SUPER + L", hl.dsp.exec_cmd("hyprlock -q"))
hl.bind("SUPER + I", hl.dsp.exec_cmd(term .. " -e micro " .. home .. "/.config/hypr/hyprland.lua"))
hl.bind("CTRL + SUPER + O", hl.dsp.exec_cmd(scriptsDir .. "/Wlogout.sh"))
hl.bind("CTRL + SUPER + R", hl.dsp.exec_cmd("systemctl reboot"))
hl.bind("CTRL + SUPER + P", hl.dsp.exec_cmd("systemctl poweroff"))

-- ── 实用功能 ──
hl.bind("SUPER + S", hl.dsp.exec_cmd(scriptsDir .. "/RofiSearch.sh"))
hl.bind("SUPER + V", hl.dsp.exec_cmd(scriptsDir .. "/ClipManager.sh"))
hl.bind("SUPER + SHIFT + N", hl.dsp.exec_cmd("swaync-client -t -sw"))

-- ── Pyprland ──
hl.bind("SUPER + K", hl.dsp.exec_cmd("pypr toggle term"))
hl.bind("SUPER + Z", hl.dsp.exec_cmd("pypr zoom"))
hl.bind("SUPER + R", hl.dsp.exec_cmd("pypr toggle run"))

-- ── 媒体控制 ──
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(scriptsDir .. "/Volume.sh --inc"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(scriptsDir .. "/Volume.sh --dec"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(scriptsDir .. "/Volume.sh --toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(scriptsDir .. "/Volume.sh --toggle-mic"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(scriptsDir .. "/MediaCtrl.sh --pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(scriptsDir .. "/MediaCtrl.sh --pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(scriptsDir .. "/MediaCtrl.sh --nxt"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(scriptsDir .. "/MediaCtrl.sh --prv"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd(scriptsDir .. "/MediaCtrl.sh --stop"), { locked = true })
hl.bind("XF86Sleep", hl.dsp.exec_cmd("systemctl suspend"), { locked = true })
hl.bind("XF86Rfkill", hl.dsp.exec_cmd(scriptsDir .. "/AirplaneMode.sh"), { locked = true })

-- ── 截图 ──
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("hyprshot -m region -z --clipboard-only"))

-- ── 壁纸 ──
hl.bind("SUPER + W", hl.dsp.exec_cmd(scriptsDir .. "/WallpaperSelect.sh"))

-- ── Waybar ──
hl.bind("SUPER + B", hl.dsp.exec_cmd("killall -SIGUSR1 waybar"))

-- ── 鼠标绑定 ──
hl.bind("SHIFT + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SHIFT + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- ── 滚动布局 ──
hl.bind("SUPER + equal", hl.dsp.layout("colresize +0.1"))
hl.bind("SUPER + minus", hl.dsp.layout("colresize -0.1")) 
hl.bind("SUPER + SHIFT + Return", hl.dsp.layout("consume_or_expel next"))

-- ══════════════════════════════════════════════════════════════════════════════
-- 触摸板手势
-- ══════════════════════════════════════════════════════════════════════════════

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "up", action = function() hl.dispatch(hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" })) end })
hl.gesture({ fingers = 3, direction = "down", action = function() hl.dispatch(hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" })) end })
hl.gesture({ fingers = 3, direction = "down", mods = "CTRL", action = "close" })
hl.gesture({ fingers = 4, direction = "horizontal", action = "scroll_move" })


-- ══════════════════════════════════════════════════════════════════════════════
-- 笔记本专用配置 (ASUS G15)
-- ══════════════════════════════════════════════════════════════════════════════

-- ── 键盘背光 ──
hl.bind("XF86KbdBrightnessDown", hl.dsp.exec_cmd(scriptsDir .. "/BrightnessKbd.sh --dec"), { repeating = true })
hl.bind("XF86KbdBrightnessUp", hl.dsp.exec_cmd(scriptsDir .. "/BrightnessKbd.sh --inc"), { repeating = true })

-- ── ASUS 专用键 ──
hl.bind("XF86Launch1", hl.dsp.exec_cmd("rog-control-center"))
hl.bind("XF86Launch3", hl.dsp.exec_cmd("asusctl led-mode -n"))
hl.bind("XF86Launch4", hl.dsp.exec_cmd("asusctl profile -n"))

-- ── 屏幕亮度 ──
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(scriptsDir .. "/Brightness.sh --dec"), { repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(scriptsDir .. "/Brightness.sh --inc"), { repeating = true })

-- ── 触摸板开关 ──
hl.bind("XF86TouchpadToggle", hl.dsp.exec_cmd(scriptsDir .. "/TouchPad.sh"))

-- ── 截图 ──
hl.bind("SUPER + F6", hl.dsp.exec_cmd(scriptsDir .. "/ScreenShot.sh --now"))
hl.bind("SUPER + SHIFT + F6", hl.dsp.exec_cmd(scriptsDir .. "/ScreenShot.sh --area"))
hl.bind("SUPER + CTRL + F6", hl.dsp.exec_cmd(scriptsDir .. "/ScreenShot.sh --in5"))
hl.bind("SUPER + ALT + F6", hl.dsp.exec_cmd(scriptsDir .. "/ScreenShot.sh --in10"))
hl.bind("ALT + F6", hl.dsp.exec_cmd(scriptsDir .. "/ScreenShot.sh --active"))

-- ── 触摸板设备设置 ──
hl.device({ name = "syna3255:00-06cb:7f28-touchpad", enabled = true })


-- ══════════════════════════════════════════════════════════════════════════════
-- 环境变量
-- ══════════════════════════════════════════════════════════════════════════════

hl.env("CLUTTER_BACKEND", "wayland")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_SCALE_FACTOR", "1")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")


-- ══════════════════════════════════════════════════════════════════════════════
-- 窗口动画与装饰配置
-- ══════════════════════════════════════════════════════════════════════════════

hl.curve("wind", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })
hl.curve("winIn", { type = "bezier", points = { {0.1, 1.1}, {0.1, 1.14} } })
hl.curve("winOut", { type = "bezier", points = { {0.3, -0.3}, {0, 1} } })
hl.curve("liner", { type = "bezier", points = { {1, 1}, {1, 1} } })
hl.curve("overshot", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })
hl.curve("smoothOut", { type = "bezier", points = { {0.5, 0}, {0.99, 0.99} } })
hl.curve("smoothIn", { type = "bezier", points = { {0.5, -0.5}, {0.68, 1.5} } })

hl.animation({ leaf = "windows", enabled = true, speed = 6, bezier = "wind", style = "slide" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 5, bezier = "winIn", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "smoothOut", style = "slide" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 5, bezier = "wind", style = "slide" })
hl.animation({ leaf = "border", enabled = true, speed = 1, bezier = "liner" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 100, bezier = "liner", style = "loop" })
hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "smoothOut" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "overshot" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 5, bezier = "winIn", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 5, bezier = "winOut", style = "slide" })

hl.config({ decoration = { rounding = 20, active_opacity = 0.87, inactive_opacity = 0.7, fullscreen_opacity = 0.95, dim_inactive = false, blur = { enabled = true, size = 7, passes = 2, ignore_opacity = false, new_optimizations = true, special = true } } })


-- ══════════════════════════════════════════════════════════════════════════════
-- 布局、输入、杂项、分组、绑定、XWayland、光标配置
-- ══════════════════════════════════════════════════════════════════════════════

hl.config({ dwindle = { preserve_split = true, special_scale_factor = 0.8 } })
hl.config({ master = { new_status = "master", new_on_top = true, mfact = 0.5 } })
hl.config({ scrolling = { column_width = 0.45 } })


hl.config({ general = { border_size = 2, gaps_in = 6, gaps_out = 8, resize_on_border = true, col = { active_border = { colors = { "rgba(00ffffff)", "rgba(00ccffff)", "rgba(0099ffff)", "rgba(3366ffff)", "rgba(6633ffff)", "rgba(9900ffff)", "rgba(cc00ffff)", "rgba(ff00ffff)", "rgba(ff33ccff)", "rgba(ff6699ff)" }, angle = 270 }, inactive_border = { colors = { "rgba(003366ff)", "rgba(004488ff)", "rgba(005599ff)", "rgba(0066aaff)", "rgba(0077bbff)", "rgba(0088ccff)", "rgba(0099ddff)", "rgba(00aaeeff)", "rgba(00bbffff)", "rgba(11ccffff)" }, angle = 270 } }, layout = "scrolling" } })

hl.config({ input = { kb_layout = "us", kb_variant = "", kb_model = "", kb_options = "", kb_rules = "", repeat_rate = 50, repeat_delay = 300, sensitivity = 0, numlock_by_default = true, left_handed = false, follow_mouse = true, float_switch_override_focus = false, touchpad = { disable_while_typing = true, natural_scroll = false, clickfinger_behavior = false, middle_button_emulation = true, tap_to_click = true, drag_lock = false }, touchdevice = { enabled = true }, tablet = { transform = 0, left_handed = false } } })

hl.config({ group = { col = { border_active = Colors.color15 }, groupbar = { col = { active = Colors.color0 } } } })

hl.config({ misc = { disable_hyprland_logo = true, disable_splash_rendering = true, mouse_move_enables_dpms = true, enable_swallow = true, swallow_regex = "^(kitty)$", focus_on_activate = false, initial_workspace_tracking = 0, middle_click_paste = false } })

hl.config({ binds = { workspace_back_and_forth = true, allow_workspace_cycles = true, pass_mouse_when_bound = false } })

hl.config({ xwayland = { force_zero_scaling = true } })

hl.config({ cursor = { no_hardware_cursors = false, enable_hyprcursor = true, warp_on_change_workspace = true, no_warps = true } })



-- ══════════════════════════════════════════════════════════════════════════════
-- 窗口规则
-- ══════════════════════════════════════════════════════════════════════════════

hl.window_rule({ name = "kitty-run-style", match = { class = "^(kitty-run)$" }, border_size = 2, rounding = 10 })

--  ── Scrolling布局窗口规则 ──
hl.window_rule({ name = "term_width", match = { class = "^(kitty)$" }, scrolling_width = 0.5 })
hl.window_rule({ name = "browser_width", match = { class = "^(firefox)$" }, scrolling_width = 0.7 })
hl.window_rule({ name = "code_width", match = { class = "^(code)$" }, scrolling_width = 0.7 })
hl.window_rule({ name = "office_width", match = { class = "^(ONLYOFFICE)$" }, scrolling_width = 0.7 })
