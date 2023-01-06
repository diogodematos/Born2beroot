#!/bin/bash

# ARCHITECTURE
arch=$(uname -a)

# CPU PHYSICAL
cpuf=$(grep "physical id" /proc/cpuinfo | wc -l)

# CPU VIRTUAL
cpuv=$(grep "processor" /proc/cpuinfo | wc -l)

# MEM RAM
memu=$(free --mega | awk '{t+=$2} {u=$3} $1 == "Mem:" {printf("%d/%dMB (%.2f%%)\n", u, t, u/t*100)}')

# MEM DISK
disku=$(df -m | grep "/dev/" | grep -v "/boot" | awk '{t+=$2} {u+=$3} $6 == "/var/log" {printf("%d/%dGb (%d%%)\n", u, t/1024, u/t*100)}')

# CPU LOAD
cpul=$(top -ibn1 | tr ',' ' ' | awk '$1 == "%Cpu(s):" {print 100 - $8"%"}')

# LAST BOOT
lb=$(who -b | awk '$1 == "system" {printf("%s %s\n", $3, $4)}')

# LVM USE
lvmu=$(if [ $(lsblk | grep "lvm" | wc -l) -gt 0 ]; then echo yes; else echo no; fi)

# TCP CONNEXIONS
tcpc=$(netstat -ant | grep ESTAB | wc -l)

# USER LOG
ulog=$(who | cut -d " " -f 1 | sort -u | wc -l)

# NETWORK
ip=$(ip route list | awk '$2 == "dev" {print($9)}')
mac=$(ip link show | awk '$1 == "link/ether" {print($2)}')

# SUDO
cmnd=$(journalctl _COMM=sudo| grep COMMAND | wc -l)

wall "	Architecture: $arch
	CPU physical: $cpuf
	vCPU: $cpuv
	Memory Usage: $memu
	Disk Usage: $disku
	CPU load: $cpul
	Last boot: $lb
	LVM use: $lvmu
	Connections TCP: $tcpc ESTABLISHED
	User log: $ulog
	Network: $net
	Sudo: $cmnd cmd"
