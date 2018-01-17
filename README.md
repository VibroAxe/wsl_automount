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
1) Clone the repo somewhere on your windows hdd (eg: c:\git\)
2) Create a task in Task Scheduler to have your script run in background. Mine looks like this:
    * Trigger: At log on
	* Action: Start a program
	* Program/script: powershell
	* Add arguments: -ExecutionPolicy Unrestricted -File "c:\git\wsl_automount\wsl_automount.ps1"

3) Configure your system to allow the bash automount script sudo permission by either
	* Runing `./wsl_automount.sh install` from within wsl bash (this will prompt for sudo rights)
	* Adding the following line to the end of /etc/sudoers in wsl
		`%sudo   ALL = (root) NOPASSWD: /mnt/c/<path to repo>/wsl_automount.sh`
4) Test (either login/logout or click `Run Task` in Task Scheduler)
5) To hide the powershell window add `-WindowStyle Hidden` to the arguments

# Known bugs
If you try to use ./wsl_automount.sh install in a filepath with spaces you will need to edit the file in /etc/sudoers.d/wsl_automount to correctly escape the path
