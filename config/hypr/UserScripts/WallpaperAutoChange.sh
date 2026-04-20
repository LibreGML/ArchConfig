#!/bin/bash


focused_monitor=$(hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}')

if [[ $# -lt 1 ]] || [[ ! -d $1   ]]; then
	echo "Usage:
	$0 <dir containing images>"
	exit 1
fi

export SWWW_TRANSITION_FPS=60
export SWWW_TRANSITION_TYPE=simple

INTERVAL=3600

while true; do
	find "$1" \
		| while read -r img; do
			echo "$((RANDOM % 1000)):$img"
		done \
		| sort -n | cut -d':' -f2- \
		| while read -r img; do
			awww img -o $focused_monitor "$img" 
			sleep $INTERVAL
			
		done
done
