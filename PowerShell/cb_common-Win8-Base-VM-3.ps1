#
# add vim to the path
#
$env:Path += ";C:\Program Files (x86)\vim\vim73" 


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


