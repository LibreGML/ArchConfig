rofi_config="$HOME/.config/rofi/config-search.rasi"
    
if pgrep -x "rofi" >/dev/null; then
    pkill rofi
    exit 0
fi

echo "" | rofi -dmenu -config "$rofi_config" -p "Search:" | xargs -I{} xdg-open "https://cn.bing.com/search?q={}"

