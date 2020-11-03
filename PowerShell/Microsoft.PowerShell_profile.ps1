
#
# This file should be copied to the location specified by $profile.
# This file should contain computer- or location-specific items.
#
# It calls
#    . $env:_CommonConfig\PowerShell\cbprofile[ISE].ps1
# for the shared config.
#

$fullPathIncFileName = $MyInvocation.MyCommand.Definition
Write-Host "**** Reading $fullPathIncFileName ****" -Foreground Cyan

# For tags files - p:\tags
# New-PSDrive -name P -psprovider FileSystem -root C:\Users\Charles\Documents\WindowsPowerShell\



$env:Path += ";C:\Program Files (x86)\MSBuild\14.0\Bin;"

if((Test-Path $env:_CommonConfig\PowerShell\Which.ps1) -eq $true) {
	. $env:_CommonConfig\PowerShell\Which.ps1
}

#
#

# Used by CB mods in posh-git
$env:PromptLength = 48;


#  -------------- Local-specific stuff ------------------
#



# Env vars for CBUtil module
$env:Editor="C:\Program Files (x86)\Vim\vim81\gvim.exe"
$env:EdParam="--remote-silent"
# $env:CompareTool="C:\Program Files\Devart\Code Compare\codecompare.exe"
$env:CompareTool="C:\Program Files\Beyond Compare 4\BCompare.exe"
#
# $env:OneCommanderPath = "C:\bin\OneCommander\OneCommander.exe";
$env:OneCommanderPathV2 = "C:\Users\Charles\AppData\Local\Apps\2.0\535ZG6L3.E92\E931E3BN.7HW\onec..tion_0000000000000000_0000.0005_bbddb2e9b3bc77fa\OneCommanderV2.exe"

# Call the shared config.
# When should the shared profile be loaded?
switch ($host.Name) {
    'ConsoleHost'
    {
        # Write-Host "env:_CommonConfig: $env:_CommonConfig"
        # . $env:_CommonConfig\PowerShell\Microsoft.PowerShell_profile.ps1
      if((Test-Path $env:_CommonConfig\PowerShell\cbprofile.ps1) -eq $true) {
        . $env:_CommonConfig\PowerShell\cbprofile.ps1
      }
    }
    'Windows PowerShell ISE Host'
    {
        Import-Module FunctionExplorer
        # Import-Module VariableExplorer
        # . $env:_CommonConfig\PowerShell\Microsoft.PowerShellISE_profile.ps1
      if((Test-Path $env:_CommonConfig\PowerShell\cbprofileISE.ps1) -eq $true) {
        . $env:_CommonConfig\PowerShell\cbprofileISE.ps1
      }
    }
}

# Updated from Slingshot 200109
Set-Alias "Code" "C:\Users\cbate\AppData\Local\Programs\Microsoft VS Code\Code.exe"
# Set-Alias "Code" "C:\Users\CB\AppData\Local\Programs\Microsoft VS Code\code.exe"

#[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
#

# Remind me about aliases/functions
#[System.Windows.Forms.MessageBox]::Show("Remember 'rds' and 'nbs' as dir shortcuts." , "PowerShell Reminder")


# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

Set-Location $env:_CommonConfig
