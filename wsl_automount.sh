#!/bin/bash


if [ $# -eq 2 ]; then
	if [ $UID -ne 0 ]; then
		echo "This command must be run as root"
		echo "Attempting to elevate $0"
		sudo $0 $@
		exit
	
	fi
	drive=`echo "${2:0:1}" | tr '[:upper:]' '[:lower:]'`
	if [[ "$1" == "mount" ]]; then
		if [ ! -d /mnt/$drive ]; then
			echo "Creating dir"
			mkdir /mnt/$drive
		fi
		echo "Mounting drive"
		mount -t drvfs $drive: /mnt/$drive
	else
		if [[ "$1" == "unmount" ]]; then
			echo "Umounting drive"
			umount -l /mnt/$drive
			rmdir /mnt/$drive
		else
			echo "Command was invalid, check usage"
		fi
	fi

else
	if [[ "$1" == "install" ]]; then 
		file=`readlink -f $0 | sed 's/ /\\ /g'`
		user=`whoami`
		echo "Attempting to install wsl_automount.sh"
		sudo sh -c "echo '$user	ALL = (root) NOPASSWD:${file}'	> /etc/sudoers.d/wsl_automount"
	else
		echo "usage: wsl_automount.sh comand path"
		echo ""
			echo "Commands"
		echo "-----------------------------------"
		echo "mount: mount the path"
		echo "unmount: unmount the path"
	fi
fi


