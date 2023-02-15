#This script is to download Microsoft AAD Connect to be used for syncing AD to 365. This will not install it, it will only download and leave a shortcut for the admin to install it.
#This is due to the nature of the installer not been able to accept silent install as it requires user input.

$msiUrl = 'https://download.microsoft.com/download/B/0/0/B00291D0-5A83-4DE7-86F5-980BC00DE05A/AzureADConnect.msi'
$msiPath = 'C:\Software\AzureADConnect.msi'
$shortcutPath = 'C:\Users\Public\Desktop\Azure AD Connect.lnk'

# Create the Software directory if it does not already exist
if (!(Test-Path -Path 'C:\Software' -PathType Container)) {
    New-Item -ItemType Directory -Path 'C:\Software'
}

# Download the MSI file if it does not already exist in the Software directory
if (!(Test-Path -Path $msiPath -PathType Leaf)) {
    Invoke-WebRequest -Uri $msiUrl -OutFile $msiPath
}

# Create a shortcut to the MSI file in the Public directory
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($shortcutPath)
$Shortcut.TargetPath = $msiPath
$Shortcut.Save()