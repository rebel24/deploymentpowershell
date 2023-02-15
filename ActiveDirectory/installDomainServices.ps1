#This script is to install the minimum requirements to prep a domain server ready to be deployed in a AD forest.
# This will install the following: 
# - ADDS
# - DNS
# - All latest windows updates

# Check if Active Directory Domain Services is installed
$ADDS = Get-WindowsFeature -Name AD-Domain-Services
if ($ADDS.Installed -ne $true) {
    # Install Active Directory Domain Services
    Install-WindowsFeature -Name AD-Domain-Services
}

# Check if DNS Server is installed
$DNS = Get-WindowsFeature -Name DNS
if ($DNS.Installed -ne $true) {
    # Install DNS Server
    Install-WindowsFeature -Name DNS
}

# Check for available updates
$UpdateSession = New-Object -ComObject Microsoft.Update.Session
$UpdateSearcher = $UpdateSession.CreateUpdateSearcher()
$SearchResult = $UpdateSearcher.Search("IsInstalled=0")

if ($SearchResult.Updates.Count -gt 0) {
    # Install available updates
    $Installer = New-Object -ComObject Microsoft.Update.Installer
    $Installer.Install($SearchResult.Updates)

    # Check for installation completion
    $UpdateInstallationResult = $SearchResult.Updates | Foreach-Object { $_.InstallationResult.ResultCode }
    if ($UpdateInstallationResult -notcontains '2') {
        Write-Output "Installation of updates failed, cannot proceed with the restart"
        Exit
    }
}



# Schedule a restart
$Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(5)
$Action = New-ScheduledTaskAction -Execute "shutdown.exe" -Argument "/r /t 0"
$Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Description "Restart after installing updates"
Register-ScheduledTask -TaskName "Restart After Updates" -InputObject $Task -User "SYSTEM"
