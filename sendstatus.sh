#!/bin/bash

source /root/settings.ini

CPU=$(top -b -n1 | awk '/^%Cpu/{$1="";print $0}')
echo "CPU: $CPU"

CPU_load=$(echo "$CPU" | awk -F, '{print $4}')

# remove decimal point
CPU_load=$(echo "$CPU_load" | awk -F. '{print $1}')

CPU_load=$((100-CPU_load))
echo "CPU_load: $CPU_load"

CPU_temp=$(sensors | awk '/Package/ {print $4}')
echo "CPU_temp: $CPU_temp"

Memory_load=$(free -t | awk 'NR==2 {print $3/$2*100}')
echo "Memory_load: $Memory_load"

SSD1_load=$(df -h | awk '$SSD1 {print $5}')
echo "SSD1_load: $SSD1_load"

SSD1_temp=$(smartctl -A --device=sat $SSD1 | awk '/^190/{print $10}')
echo "SSD1_temp: $SSD1_temp"

SSD2_load=$(df -h | awk '$SSD2 {print $5}')
echo "SSD2_load: $SSD2_load"

SSD2_temp=$(smartctl -A --device=sat $SSD2 | awk '/^190/{print $10}')
echo "SSD2_temp: $SSD2_temp"

UPS=$(upsc ups)

UPS_model=$(echo "$UPS" | awk '/ups.model:/{$1="";print $0}')
echo "UPS_model: $UPS_model"

UPS_battery_date=$(echo "$UPS" | awk '/battery.mfr.date:/{$1="";print $0}')
echo "UPS_battery_date: $UPS_battery_date"

UPS_battery_charge=$(echo "$UPS" | awk '/battery.charge:/{$1="";print $0}')
echo "UPS_battery_charge: $UPS_battery_charge"

UPS_battery_time=$(echo "$UPS" | awk '/battery.runtime:/{$1="";print $0}')
echo "UPS_battery_time: $UPS_battery_time"

UPS_battery_voltage=$(echo "$UPS" | awk '/battery.voltage:/{$1="";print $0}')
echo "UPS_battery_voltage: $UPS_battery_voltage"

UPS_load=$(echo "$UPS" | awk '/ups.load:/{$1="";print $0}')
echo "UPS_load: $UPS_load"

UPS_voltage=$(echo "$UPS" | awk '/input.voltage:/{$1="";print $0}')
echo "UPS_voltage: $UPS_voltage"

UPS_status=$(echo "$UPS" | awk '/ups.status:/{$1="";print $0}')
echo "UPS_status: $UPS_status"

UPS_date=$(echo "$UPS" | awk '/ups.mfr.date:/{$1="";print $0}')
echo "UPS_date: $UPS_date"

Uptime=$(awk '/^btime/{print $2}' /proc/stat)
echo "Uptime: $Uptime"

TIME=$(date +%s)

curl --get \
  --data-urlencode "set=lserver" \
  --data-urlencode "name=$NAME" \
  --data-urlencode "CPU=$CPU" \
  --data-urlencode "CPU_load=$CPU_load" \
  --data-urlencode "CPU_temp=$CPU_temp" \
  --data-urlencode "Storage_load=$Storage_load" \
  --data-urlencode "SSD1_temp=$SSD1_temp" \
  --data-urlencode "SSD1_load=" \
  --data-urlencode "SSD2_temp=" \
  --data-urlencode "SSD2_load=" \
  --data-urlencode "Memory_load=$Memory_load" \
  --data-urlencode "Uptime=$Uptime" \
  --data-urlencode "time=$TIME" \
  --data-urlencode "UPS_model=$UPS_model" \
  --data-urlencode "UPS_battery_date=$UPS_battery_date" \
  --data-urlencode "UPS_battery_charge=$UPS_battery_charge" \
  --data-urlencode "UPS_battery_time=$UPS_battery_time" \
  --data-urlencode "UPS_battery_voltage=$UPS_battery_voltage" \
  --data-urlencode "UPS_load=$UPS_load" \
  --data-urlencode "UPS_voltage=$UPS_voltage" \
  --data-urlencode "UPS_status=$UPS_status" \
  --data-urlencode "UPS_date=$UPS_date" \
"$STATUS_URL"
