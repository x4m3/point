#!/bin/sh
#
# dwm-status.sh
# by x4m3 (https://philippeloctaux.com)
# and the help of kind redditors! (http://redd.it/bw2dbu)

# packages required to get shit working (on archlinux)
#
# acpi (for battery status)
# xsetroot (to display in status bar)

set -efu

get_battery() {
	acpi >/dev/null 2>&1
	if [ $? != 0 ]; then
		get_battery="NO BATTERY";
		return 0;
	fi

	battery_acpi=$(acpi | sed 's/\,//g');
	battery_state=$(echo $battery_acpi | awk '{print $3}');
	battery=$(echo $battery_acpi | awk '{print $4}');

	if [ $battery_state == "Discharging" ]; then
		final_battery_state="-- ";
	fi
	if [ $battery_state == "Charging" ]; then
		final_battery_state="++ ";
	fi

	test -f /sys/class/power_supply/BAT0/power_now || return 0;
	battery_wattage=$(awk '{print $1*10^-6}' /sys/class/power_supply/BAT0/power_now);

	if [ $battery_wattage == 0 ]; then
		get_battery="BATTERY FULL";
	else
		get_battery="${final_battery_state}${battery} ${battery_wattage}W";
	fi
}

current_uptime() { current_uptime=$(uptime -p); }

caps_lock() { caps_lock=$(xset -q | awk '/Caps/{print "CapsLock " $4}'); }

time_date() { time_date=$(date +"%a %B %d, %Y %H:%M:%S %Z"); }

free_disk() { free_disk=$(df / -h | tail -n 1 | awk '{print $4}'); }

ram_usage() { ram_usage=$(free | awk '/Mem/ {printf "%dMiB/%dMiB\n", $3 / 1024.0, $2 / 1024.0 }'); }

cpu_usage() {
	vars="user nice system idle iowait irq softirq steal"

	# Store previous values
	for var in $vars; do
		eval "prev${var}=\${$var:-0}"
	done

	# Read new values
	while read -r name $vars null </proc/stat; do
		[ "$name" = "cpu" ] && break
	done

	# Based on https://stackoverflow.com/a/23376195
	PrevIdle=$((previdle + previowait))
	Idle=$((idle + iowait))

	PrevNonIdle=$((prevuser + prevnice + prevsystem
		+ previrq + prevsoftirq + prevsteal))
	NonIdle=$((user + nice + system + irq + softirq + steal))

	PrevTotal=$((PrevIdle + PrevNonIdle))
	Total=$((Idle + NonIdle))

	# differentiate: actual value minus the previous one
	totald=$((Total - PrevTotal))
	idled=$((Idle - PrevIdle))

	cpu_pct=$((100 * (totald - idled) / totald))
	cpu_usage=$(printf %02d $cpu_pct);
}

cpu_load() { read -r cpu_load cpu_load5 cpu_load15 x </proc/loadavg; }

cpu_temp() {
	read -r raw_cpu_temp </sys/class/thermal/thermal_zone0/temp;
	cpu_temp=" $(printf ${raw_cpu_temp%???}°)";
}

main() {
	every() { [ $((${round:=0} % ${1:-1})) -eq 0 ]; }

	while :; do
		every 1 && {
			time_date
			caps_lock
		}
		every 4 && {
			ram_usage
			cpu_usage
			cpu_load
			cpu_temp
			get_battery
		}
		every 60 && {
			current_uptime
			free_disk
		}

		to_print="$current_uptime | $free_disk free | $get_battery | RAM $ram_usage | CPU $cpu_usage% $cpu_load$cpu_temp | $caps_lock | $time_date";

		echo "$to_print";
		xsetroot -name "$to_print";

		round=$((round + 1))
		sleep 1
	done
}; main
