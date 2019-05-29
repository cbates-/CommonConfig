
$fullPathIncFileName = $MyInvocation.MyCommand.Definition
Write-Host "Reading $fullPathIncFileName" -Foreground Cyan

# can be turned off in individual scripts.
Set-StrictMode -Version 2.0

. $env:_CommonConfig\PowerShell\cbProfile.ps1

# Let's check the Errors to see if Set-StrictMode caused anything to choke:
$error[0] | fl * -force


# Import-Module Pscx
Import-Module FunctionExplorer
# Import-Module VariableExplorer

#
# Remind me about aliases/functions
#
#[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 
#
#[System.Windows.Forms.MessageBox]::Show("Remember 'rds' and 'nbs' as dir shortcuts, 'gvimr'." , "PowerShell Reminder") 


#Script Browser Begin
#Version: 1.2.0
# Add-Type -Path 'C:\Program Files\Microsoft Corporation\Microsoft Script Browser\System.Windows.Interactivity.dll'
# Add-Type -Path 'C:\Program Files\Microsoft Corporation\Microsoft Script Browser\ScriptBrowser.dll'
# Add-Type -Path 'C:\Program Files\Microsoft Corporation\Microsoft Script Browser\BestPractices.dll'
# $scriptBrowser = $psISE.CurrentPowerShellTab.VerticalAddOnTools.Add('Script Browser', [ScriptExplorer.Views.MainView], $true)
# $scriptAnalyzer = $psISE.CurrentPowerShellTab.VerticalAddOnTools.Add('Script Analyzer', [BestPractices.Views.BestPracticesView], $true)
# $psISE.CurrentPowerShellTab.VisibleVerticalAddOnTools.SelectedAddOnTool = $scriptBrowser

#Script Browser End
