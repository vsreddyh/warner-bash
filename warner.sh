#!/bin/bash
CONFIG_FILE="$HOME/.config/warner/.warner_config"

# Default values
MAX_CPU=90
MIN_BATTERY=20
MAX_BATTERY=85
MAX_RAM=90
MAX_TEMP=60

# Ensure config directory exists
mkdir -p "$HOME/.config/warner"

# Create config file if it does not exist
if [[ ! -f "$CONFIG_FILE" ]]; then
	echo "MIN_BATTERY=$MIN_BATTERY" >"$CONFIG_FILE" || (echo "Error accessing .config folder" && exit)
	echo "MAX_BATTERY=$MAX_BATTERY" >>"$CONFIG_FILE" || (echo "Error accessing .config folder" && exit)
	echo "MAX_CPU=$MAX_CPU" >>"$CONFIG_FILE" || (echo "Error accessing .config folder" && exit)
	echo "MAX_RAM=$MAX_RAM" >>"$CONFIG_FILE" || (echo "Error accessing .config folder" && exit)
	echo "MAX_TEMP=$MAX_TEMP" >>"$CONFIG_FILE" || (echo "Error accessing .config folder" && exit)
fi
# Load config values
source "$CONFIG_FILE"

# Function to start monitoring
do_monitor() {
	while true; do
		checkCpu &
		checkRam &
		checkBattery &
		checkTemp
		sleep 180
	done
}

# Function to stop monitoring
stop_monitor() {
	if pgrep -f "warner" | grep -v "$$" >/dev/null; then
		pkill -f warner
		echo "Warner stopped."
	else
		echo "Warner is not running."
	fi
}

# Functions for resource checks
checkCpu() {
	local x=$(top -bn1 | grep "Cpu(s)" | awk '{print int($2 + $4)}')
	if [ $x -ge $MAX_CPU ]; then
		notify-send -t 10000 "Warning: CPU usage ($x%) exceeded $MAX_CPU%"
	fi
}

checkRam() {
	local used=$(free -m | awk '/Mem:/ {print $3}')
	local total=$(free -m | awk '/Mem:/ {print $2}')
	local percent=$((used * 100 / total))
	if [ $percent -ge $MAX_RAM ]; then
		notify-send -t 10000 "Warning: RAM usage ($percent%) exceeded $MAX_RAM%"
	fi
}

checkBattery() {
	local x=$(cat /sys/class/power_supply/BAT0/capacity)
	local status=$(cat /sys/class/power_supply/BAT0/status)
	if [ "$x" -ge "$MAX_BATTERY" ] && [ "$status" = "Charging" ]; then
		notify-send -t 10000 "Warning: Battery high ($x%) exceeded $MAX_BATTERY%"
	elif [ "$x" -le "$MIN_BATTERY" ] && [ "$status" = "Discharging" ]; then
		notify-send -t 10000 "Warning: Battery low ($x%) below $MIN_BATTERY%"
	fi
}

checkTemp() {
	local x=$(sensors | grep "Package id" | awk '{print int($4)}')
	if [ $x -ge $MAX_TEMP ]; then
		notify-send -t 10000 "Warning: CPU temperature ($x°C) exceeded $MAX_TEMP°C"
	fi
}

#Updates .warner_config
update_config() {
	local key="$1"
	local value="$2"
	sed -i "s/^$key=.*/$key=$value/" "$CONFIG_FILE"
	echo "$key updated to $value"
}

# Handle arguments
if [ $# -eq 0 ]; then
	if pgrep -f "warner" | grep -v "$$" >/dev/null; then
		stop_monitor
	else
		echo "Starting Warner..."
		do_monitor &
	fi
fi
while [[ $# -gt 0 ]]; do
	case "$1" in
	-maxTemp)
		update_config "MAX_TEMP" "$2"
		shift 2
		;;
	-maxCpu)
		update_config "MAX_CPU" "$2"
		shift 2
		;;
	-maxRam)
		update_config "MAX_RAM" "$2"
		shift 2
		;;
	-minBat)
		update_config "MIN_BATTERY" "$2"
		shift 2
		;;
	-maxBat)
		update_config "MAX_BATTERY" "$2"
		shift 2
		;;
	-show)
		cat $CONFIG_FILE
		shift 1
		;;

	start)
		if pgrep -f "warner" | grep -v "$$" >/dev/null; then
			echo "Warner is already running."
		else
			echo "Starting Warner..."
			do_monitor &
		fi
		shift 1
		;;
	stop)
		stop_monitor
		shift 1
		;;
	*)
		echo "Usage: $0 {start|stop|-show|-maxTemp value|-maxCpu value|-maxRam value|-minBat value|-maxBat value}"
		exit 1
		;;
	esac
done
