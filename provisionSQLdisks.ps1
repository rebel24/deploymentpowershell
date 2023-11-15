# Disk initialization and formatting script
# Modify as needed to suit your environment

# Initialize and format data disk
$DataDisk = Get-Disk | Where-Object { $_.Number -eq 1 }
if ($DataDisk -and $DataDisk.PartitionStyle -eq 'RAW') {
    Initialize-Disk -Number $DataDisk.Number -PartitionStyle MBR
    $DataPartition = New-Partition -DiskNumber $DataDisk.Number -UseMaximumSize -AssignDriveLetter
    Format-Volume -DriveLetter F -Partition $DataPartition -FileSystem NTFS -NewFileSystemLabel 'Data' -Confirm:$false
}

# Initialize and format log disk
$LogDisk = Get-Disk | Where-Object { $_.Number -eq 2 }
if ($LogDisk -and $LogDisk.PartitionStyle -eq 'RAW') {
    Initialize-Disk -Number $LogDisk.Number -PartitionStyle MBR
    $LogPartition = New-Partition -DiskNumber $LogDisk.Number -UseMaximumSize -AssignDriveLetter
    Format-Volume -DriveLetter G -Partition $LogPartition -FileSystem NTFS -NewFileSystemLabel 'Log' -Confirm:$false
}

# Initialize and format tempDb disk
$TempDbDisk = Get-Disk | Where-Object { $_.Number -eq 3 }
if ($TempDbDisk -and $TempDbDisk.PartitionStyle -eq 'RAW') {
    Initialize-Disk -Number $TempDbDisk.Number -PartitionStyle MBR
    # Specify the drive letter directly in the New-Partition cmdlet
    $TempDbPartition = New-Partition -DiskNumber $TempDbDisk.Number -UseMaximumSize -AssignDriveLetter
    Format-Volume -DriveLetter E -Partition $TempDbPartition -FileSystem NTFS -NewFileSystemLabel 'TempDb' -Confirm:$false
}
