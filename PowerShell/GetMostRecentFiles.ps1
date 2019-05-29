
<#
.SYNOPSIS   
	Script that return $numItems most recently modified files.
    
.DESCRIPTION 
	This script calls Get-ChildItem -Recurse, sorts by LastWriteTime, and takes the last $numItems for display.
 
.PARAMETER numItems
    The number of filenames to display.
    Optional - The default is 5.
#>

function Get-MostRecentFiles {
     Param (
             [int]$numItems = 8,
             [bool]$descending = $false
           )
          $sortOption = [string]::Empty;
          if ($descending -eq $true) {
              $sortOption = "Descending";
          }
         $l = Get-ChildItem -Path $pwd -Recurse -Exclude ".git\*" | 
             where {$_.PsIsContainer -ne $true -and  $_.fullname -notmatch "\\.git\\?" }  ;

         if ($descending -eq $true) {
             Write-Host "Last $numItems most recent files, descending: " -Foreground Green
             $l = $l | sort LastWriteTime -Descending | select -first $numItems
         }
         else {
             Write-Host "Last $numItems most recent files: " -Foreground Green
             $l = $l | sort LastWriteTime | select -last $numItems
         }

         $l 
         # $l | Sort-Object DirectoryName

  #
  #  From:  http://stackoverflow.com/a/20332882
  #
  # $l | group PsParentPath | select Count,Name,@{e={$_.Group | sort LastWriteTime | select -l 1 -exp LastWriteTime }} | ft -AutoSize
 }
 Set-Alias mrf Get-MostRecentFiles
