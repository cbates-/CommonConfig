
# 
# This file should be copied to the location specified by $profile.
# This file should contain computer- or location-specific items.
#
# It calls  
#    . $env:_skydrive\PowerShell\cbprofile[ISE].ps1       
# for the shared config.
#

Write-Host "Reading C:\Users\Charles\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" -Foreground Yellow

#
#  -------------- Surface Pro3-specific stuff ------------------
#
. $env:_skydrive\PowerShell\Which.ps1

$env:Path += ";C:\Program Files (x86)\MSBuild\12.0\Bin;"

# Env vars for Promote-Folder/NBAUtil/CBUtil module
$env:Editor="C:\Program Files (x86)\Vim\vim81\gvim.exe"
$env:EdParam="--remote-silent"
$env:CompareTool="C:\Program Files\Devart\Code Compare\codecompare.exe"
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


#[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 
#

# Remind me about aliases/functions
#[System.Windows.Forms.MessageBox]::Show("Remember 'rds' and 'nbs' as dir shortcuts." , "PowerShell Reminder") 

