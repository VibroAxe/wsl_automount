# wsl_automount
A set of scripts to automount any removable drives in wsl

# Components
## wsl_automount.ps1
This is a powershell script which starts on your user login and watches for a drive being added/removed. Once a drive change has been detected it will signal wsl to [un]mount the drive

## wsl_autmount.sh
This is a bash script which handles actually mounting / umounting the drive within wsl

## Notes
If the drive is removed with any file handles still open WSL will use lazy umounting. Whilst this removes the drive from the file structure you may still find processes with open handles may fail

# Installation
	* Clone the repo somewhere on your harddrive
	* Setup a task trigger for the ps1 script
	* Add the following line to the end of /etc/sudoers in wsl
		`%sudo   ALL = (root) NOPASSWD: /mnt/c/<path to repo>/wsl_automount/wsl_autmount.sh`
	* Enjoy
