#Requires -version 2.0
Register-WmiEvent -Class win32_VolumeChangeEvent -SourceIdentifier volumeChange
write-host (get-date -format s) " Beginning script..."
do{
	$newEvent = Wait-Event -SourceIdentifier volumeChange
	$eventType = $newEvent.SourceEventArgs.NewEvent.EventType
	$eventTypeName = switch($eventType)
	{
		1 {"Configuration changed"}
		2 {"Device arrival"}
		3 {"Device removal"}
		4 {"docking"}
	}
	write-host (get-date -format s) " Event detected = " $eventTypeName
	$wslprocesses = Get-Process bash | measure
	write-host (get-date -format s) " WSL Running = " $wslprocesses.Count

	if ($wslprocesses.Count -gt 0) {
		if ($eventType -eq 2)
		{
			$driveLetter = $newEvent.SourceEventArgs.NewEvent.DriveName
			$driveLabel = ([wmi]"Win32_LogicalDisk='$driveLetter'").VolumeName
			write-host (get-date -format s) " Drive name = " $driveLetter
			write-host (get-date -format s) " Drive label = " $driveLabel
			bash.exe -c "./wsl_automount.sh mount $driveLetter"
		}
		if ($eventType -eq 3) {
			$driveLetter = $newEvent.SourceEventArgs.NewEvent.DriveName
			write-host (get-date -format s) " Drive name = " $driveLetter
			bash.exe -c "./wsl_automount.sh unmount $driveLetter"
		}
	}
	Remove-Event -SourceIdentifier volumeChange
} while (1-eq1) #Loop until next event
Unregister-Event -SourceIdentifier volumeChange
