#!/bin/bash
#

# packages to install to get shit working (on archlinux)
#
# acpi

battery() {
	acpi >/dev/null 2>&1
	if [ $? != 0 ]; then
		echo "NO BATTERY";
		return 0;
	fi

	battery_acpi=$(acpi | sed 's/\,//g');
	battery_state=$(echo $battery_acpi | awk '{print $3}');
	battery=$(echo $battery_acpi | awk '{print $4}');

	if [ $battery_state == "Discharging" ]; then
		echo -n "-- ";
	fi
	if [ $battery_state == "Charging" ]; then
		echo -n "++ ";
	fi

	test -f /sys/class/power_supply/BAT0/power_now || return 0;
	battery_wattage=$(awk '{print $1*10^-6}' /sys/class/power_supply/BAT0/power_now);

	if [ $battery_wattage == 0 ]; then
		echo "BATTERY FULL";
	else
		echo "${battery} ${battery_wattage}W";
	fi
}

current_uptime() {
	uptime -p;
}

caps_lock() {
	xset -q | grep Caps | awk '{print "CapsLock " $4}';
}

time_date() {
	current_date=$(date +"%a %B %d, %Y %H:%M:%S %Z");
	echo " ${current_date}"
}

free_disk() {
	disk_usage=$(df / -h | tail -n 1 | awk '{print $4}');
	echo "${disk_usage} free"
}

ram_usage() {
	free | awk '/Mem/ {printf "RAM %dMiB/%dMiB\n", $3 / 1024.0, $2 / 1024.0 }';
}

cpu_usage() {
	test -f /proc/stat || return 0;

	read cpu a b c previdle rest < /proc/stat;
	prevtotal=$((a+b+c+previdle));
	sleep 0.25;
	read cpu a b c idle rest < /proc/stat;
	total=$((a+b+c+idle));
	cpu=$((100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ));
	cpu=$(printf %02d $cpu);
	echo "${cpu}%"
}

cpu_load() {
	test -f /proc/loadavg || return 0;
	awk '{print $1}' /proc/loadavg
}

cpu_temp() {
	test -f /sys/class/thermal/thermal_zone0/temp || return 0;
	echo " $(head -c 2 /sys/class/thermal/thermal_zone0/temp)°";
}

cpu() {
	echo "CPU $(cpu_usage) $(cpu_load)$(cpu_temp)"
}

while true
do
	xsetroot -name "$(current_uptime) | $(free_disk) | $(battery) | $(ram_usage) | $(cpu) | $(caps_lock) | $(time_date)";
	echo "$(current_uptime) | $(free_disk) | $(battery) | $(ram_usage) | $(cpu) | $(caps_lock) | $(time_date)";
done
