# Check if Active Directory Domain Services feature is installed
if ((Get-WindowsFeature -Name AD-Domain-Services -ErrorAction SilentlyContinue).Installed -eq $false) {
    # If not installed, install the feature
    Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
}
