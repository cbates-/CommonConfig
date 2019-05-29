#
# add vim to the path
#
$env:Path += ";C:\Program Files\vim\vim80" 
#$env:Path += ";c:\bin" 
# Put things that would go in c:\bin here?  Like gitdiff.bat?
$env:Path += ";c:\users\charles\skydrive\bin"

#
#  Save/restore command history
#  From: http://blogs.msdn.com/b/powershell/archive/2006/07/01/perserving-command-history-across-sessions.aspx 

$MaximumHistoryCount = 1KB

if (!(Test-Path ~\PowerShell -PathType Container))
{   New-Item ~\PowerShell -ItemType Directory
}

function bye 
{   Get-History -Count 50 |Export-CSV ~\PowerShell\history.csv
    exit
}

if (Test-path ~\PowerShell\History.csv)
{   Import-CSV ~\PowerShell\History.csv |Add-History
}

# 
# New aliases -------------------
#

# use this with popd
new-alias cdd pushd;Set-Location

new-alias view Get-Content

#function exp 
#  { explorer.exe  (Convert-Path (Get-Location -PSProvider FileSystem)) }
#
function exp { param ($dir = ".")  
        explorer.exe $dir
}

# function docmd { cmd /c $args there }
#
function findCmd([string]$a) { get-history | where-object {$_.commandLine -like "*$a*"} }

function Test-ReparsePoint([string]$path) {
  $file = Get-Item $path -Force -ea 0
  return [bool]($file.Attributes -band [IO.FileAttributes]::ReparsePoint)
}


##
#
# Apropos - search help Synopsis header for keywords
#
function apropos {
$descr = Get-Help *
foreach ($ag in $args) {
$descr = $descr | Where {$_.Synopsis -like "*${ag}*"}
}
$descr | Format-Table -Auto
}


#
# Remind me about using 'bye'
#
# [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 
# 
# [System.Windows.Forms.MessageBox]::Show("Use 'Bye' instead of 'Exit' to save command history." , "PowerShell Reminder") 


