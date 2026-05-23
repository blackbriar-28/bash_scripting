#!/bin/bash
# system_report.sh - Quick Hardware & Performance Report for AlmaLinux

echo "==============================="
echo " 🖥️  System Information Report"
echo "==============================="
echo

# Hostname and OS
echo "▶️ Hostname and OS:"
hostnamectl
echo

# CPU
echo "▶️ CPU Info:"
lscpu | grep -E 'Model name|Socket|Thread|Core|CPU\(s\)'
echo

# Memory
echo "▶️ Memory Info:"
free -h
echo

# Disk layout
echo "▶️ Disk Layout:"
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT
echo

# Top 5 processes by memory
echo "▶️ Top 5 Memory-Consuming Processes:"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6
echo

# Top 5 processes by CPU
echo "▶️ Top 5 CPU-Consuming Processes:"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6
echo

# Uptime and load averages
echo "▶️ Uptime & Load:"
uptime
echo

# Disk usage
echo "▶️ Disk Usage:"
df -hT | grep -E '^/dev'
echo

# I/O stats (requires sysstat)
if command -v iostat &> /dev/null
then
    echo "▶️ Disk I/O (last 1s sample):"
    iostat -xz 1 2 | tail -n 20
else
    echo "▶️ Disk I/O: (install sysstat to see details)"
fi
echo

# Network usage
echo "▶️ Network Interfaces:"
ip -brief addr
echo

echo "==============================="
echo " ✅ Report Finished"
echo "==============================="
