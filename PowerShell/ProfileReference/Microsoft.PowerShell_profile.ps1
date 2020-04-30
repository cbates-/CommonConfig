
#
# This file should be copied to the location specified by $profile.
# This file should contain computer- or location-specific items.
#
# It calls
#    . $env:_skydrive\PowerShell\cbprofile[ISE].ps1
# for the shared config.
#

$fullPathIncFileName = $MyInvocation.MyCommand.Definition
Write-Host "Reading $fullPathIncFileName" -Foreground Cyan

# For tags files - p:\tags
# New-PSDrive -name P -psprovider FileSystem -root C:\Users\Charles\Documents\WindowsPowerShell\

#  -------------- Surface Pro3-specific stuff ------------------
#
. $env:_skydrive\PowerShell\Which.ps1

$env:Path += ";C:\Program Files (x86)\MSBuild\12.0\Bin;"

# Env vars for Promote-Folder/NBAUtil/CBUtil module
$env:Editor="C:\Program Files\Vim\vim81\gvim.exe"
$env:EdParam="--remote-silent"
# $env:CompareTool="C:\Program Files\Devart\Code Compare\codecompare.exe"
$env:CompareTool="C:\Program Files\Araxis\Araxis Merge\Compare.exe"
$env:OneCommanderPath = "C:\bin\OneCommander\OneCommander.exe";

# Call the shared config.
# When should the shared profile be loaded?
switch ($host.Name) {
    'ConsoleHost'
    {
        # Write-Host "env:_skdrive: $env:_skydrive"
        # . $env:_skydrive\PowerShell\Microsoft.PowerShell_profile.ps1
        . $env:_skydrive\PowerShell\cbprofile.ps1
    }
    'Windows PowerShell ISE Host'
    {
        Import-Module FunctionExplorer
        # Import-Module VariableExplorer
        # . $env:_skydrive\PowerShell\Microsoft.PowerShellISE_profile.ps1
        . $env:_skydrive\PowerShell\cbProfileISE.ps1
    }
}

# Used by CB mods in posh-git
$env:PromptLength = 48;


Set-Alias npp -Value "C:\Program Files\Notepad++\notepad++.exe" -Scope "Global"

#[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
#

# Remind me about aliases/functions
#[System.Windows.Forms.MessageBox]::Show("Remember 'rds' and 'nbs' as dir shortcuts." , "PowerShell Reminder")

