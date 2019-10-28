# LS.MSH  
# Colorized LS function replacement  
# /\/\o\/\/ 2006  
# http://mow001.blogspot.com  
#
# CB: 20140617:  Added indication of Junction

function LL { param ($dir = ".")  
  $origFg = $host.ui.rawui.foregroundColor  
  foreach ($Item in (LS $dir))   
  {  
    Switch ($Item.Extension)   
    {  
      ".Exe" {$host.ui.rawui.foregroundColor = "Red"}  
      ".cmd" {$host.ui.rawui.foregroundColor = "Green"}  
      ".msh" {$host.ui.rawui.foregroundColor = "Cyan"}  
      ".ps1" {$host.ui.rawui.foregroundColor = "Cyan"}  
      ".vbs" {$host.ui.rawui.foregroundColor = "Cyan"}  
      Default {$host.ui.rawui.foregroundColor = $origFg}  
    }  
    if ($item.PSIsContainer) {$host.ui.rawui.foregroundColor = "Yellow"}
    $item  
  }   
  $host.ui.rawui.foregroundColor = $origFg  
}

# List Directories
function LD { param ($dir = ".")  
  $origFg = $host.ui.rawui.foregroundColor  
  foreach ($Item in (LS $dir))   
  {  
    if ($item.PSIsContainer) {
#       [void]$host.ui.rawui.foregroundColor = "Yellow"
        $item  
    }
  }   
  $host.ui.rawui.foregroundColor = $origFg  
}

# tuned up colors to more closely match TakeCommand.
#
# Sort by last write time
function LWD { param ($dir = ".")  
  Set-StrictMode -Off
    "`t`t`tSorted by LastWriteTime"
    "`t`t`t-----------------------"
  $dirs = get-childitem -Path $dir | sort LastWriteTime

  $origFg = $host.ui.rawui.foregroundColor  

    foreach ($Item in ($dirs))   
    {  
      Switch ($Item.Extension)   
      {  
        ".Exe" {$host.ui.rawui.foregroundColor = "Red"}  
        ".cmd" {$host.ui.rawui.foregroundColor = "Green"}  
        ".msh" {$host.ui.rawui.foregroundColor = "Cyan"}  
        ".ps1" {$host.ui.rawui.foregroundColor = "Cyan"}  
        ".vbs" {$host.ui.rawui.foregroundColor = "Cyan"}  
        Default {$host.ui.rawui.foregroundColor = $origFg}  
      }  
      if ($item.PSIsContainer) {$host.ui.rawui.foregroundColor = "Yellow"}

#      "{0:d} {1} {2, 12} {3, 48}" -f $Item.CreationTime, $Item.Mode, $Item.length, $Item.name
        $j = $Item.Attributes | Select-String -SimpleMatch "ReparsePoint"
        if ($j -ne $null) { $j = "J" } else { $j="" }
        [String]::Format("{0,10}  {1,8}  {2,12} {3,2}  {4,18} {5}", $Item.LastWriteTime.ToString("d"), $Item.LastWriteTime.ToString("t"), $Item.Mode, $j, $Item.length, $Item.name)
     }   
  $host.ui.rawui.foregroundColor = $origFg  
}

function LWZ { param ($dir = ".")  
  Set-StrictMode -Off
    "`t`t`tSorted by Length"
    "`t`t`t-----------------------"
  $dirs = get-childitem -Path $dir | sort Length

  $origFg = $host.ui.rawui.foregroundColor  

    foreach ($Item in ($dirs))   
    {  
      Switch ($Item.Extension)   
      {  
        ".Exe" {$host.ui.rawui.foregroundColor = "Red"}  
        ".cmd" {$host.ui.rawui.foregroundColor = "Green"}  
        ".msh" {$host.ui.rawui.foregroundColor = "Cyan"}  
        ".ps1" {$host.ui.rawui.foregroundColor = "Cyan"}  
        ".vbs" {$host.ui.rawui.foregroundColor = "Cyan"}  
        Default {$host.ui.rawui.foregroundColor = $origFg}  
      }  
      if ($item.PSIsContainer) {$host.ui.rawui.foregroundColor = "Yellow"}

#      "{0:d} {1} {2, 12} {3, 48}" -f $Item.CreationTime, $Item.Mode, $Item.length, $Item.name
        $j = $Item.Attributes | Select-String -SimpleMatch "ReparsePoint"
        if ($j -ne $null) { $j = "J" } else { $j="" }
        [String]::Format("{0,10}  {1,8}  {2,12} {3,2}  {4,18} {5}", $Item.LastWriteTime.ToString("d"), $Item.LastWriteTime.ToString("t"), $Item.Mode, $j, $Item.length, $Item.name)
     }   
  $host.ui.rawui.foregroundColor = $origFg  
}

# Sort by creation time
function LSD { param ($dir = ".")  
# Barks when trying to proces DirInfo, 'cuz DirInfo doesn't have a Length property.
    Set-StrictMode -Off
    "`t`t`tSorted by CreationTime"
    "`t`t`t----------------------"
        $dirs = get-childitem -Path $dir | sort CreationTime

        $origFg = $host.ui.rawui.foregroundColor  

# [String]::Format("{0,10}  {1,8}  {2,12}  {3,18} {4}", " ", "CreationTime", "Mode", "Length", "Name")
        foreach ($Item in ($dirs))   
        {  
            Switch ($Item.Extension)   
            {  
                ".Exe" {$host.ui.rawui.foregroundColor = "Red"}  
                ".cmd" {$host.ui.rawui.foregroundColor = "Green"}  
                ".msh" {$host.ui.rawui.foregroundColor = "Cyan"}  
                ".ps1" {$host.ui.rawui.foregroundColor = "Cyan"}  
                ".vbs" {$host.ui.rawui.foregroundColor = "Cyan"}  
                Default {$host.ui.rawui.foregroundColor = $origFg}  
            }  
            if ($item.PSIsContainer) {$host.ui.rawui.foregroundColor = "Yellow"}

            [String]::Format("{0,10}  {1,8}  {2,12}  {3,18} {4}", $Item.CreationTime.ToString("d"), $Item.CreationTime.ToString("t"), $Item.Mode, $Item.Length, $Item.Name)
        }   
    $host.ui.rawui.foregroundColor = $origFg  
}

# sort by size
function LSZ { param ($dir = ".")  
  # Barks when trying to proces DirInfo, 'cuz DirInfo doesn't have a Length property.
  Set-StrictMode -Off
  "`t`t`tSorted by Length"
  "`t`t`t----------------"
  $dirs = get-childitem -File -Path $dir | sort-object Length

  $origFg = $host.ui.rawui.foregroundColor  

    foreach ($Item in ($dirs))   
    {  
      Switch ($Item.Extension)   
      {  
        ".Exe" {$host.ui.rawui.foregroundColor = "Red"}  
        ".cmd" {$host.ui.rawui.foregroundColor = "Green"}  
        ".msh" {$host.ui.rawui.foregroundColor = "Cyan"}  
        ".ps1" {$host.ui.rawui.foregroundColor = "Cyan"}  
        ".vbs" {$host.ui.rawui.foregroundColor = "Cyan"}  
        Default {$host.ui.rawui.foregroundColor = $origFg}  
      }  
      if ($item.PSIsContainer) {$host.ui.rawui.foregroundColor = "Yellow"}

#      "{0:d} {1:t} {2,12} {3, 12} {4, 40}" -f $Item.CreationTime, $Item.CreationTime, $Item.Mode, $Item.length, $Item.name
        [String]::Format("{0,10}  {1,8}  {2,12}  {3,18} {4}", $Item.CreationTime.ToString("d"), $Item.CreationTime.ToString("t"), $Item.Mode, $Item.length, $Item.name)
     }   
  $host.ui.rawui.foregroundColor = $origFg  
}

# sort by name
function LSZ { param ($dir = ".")  
  # Barks when trying to proces DirInfo, 'cuz DirInfo doesn't have a Length property.
  Set-StrictMode -Off
  "`t`t`tSorted by Name"
  "`t`t`t----------------"
  $dirs = get-childitem -File -Path $dir | sort-object Name

  $origFg = $host.ui.rawui.foregroundColor  

    foreach ($Item in ($dirs))   
    {  
      Switch ($Item.Extension)   
      {  
        ".Exe" {$host.ui.rawui.foregroundColor = "Red"}  
        ".cmd" {$host.ui.rawui.foregroundColor = "Green"}  
        ".msh" {$host.ui.rawui.foregroundColor = "Cyan"}  
        ".ps1" {$host.ui.rawui.foregroundColor = "Cyan"}  
        ".vbs" {$host.ui.rawui.foregroundColor = "Cyan"}  
        Default {$host.ui.rawui.foregroundColor = $origFg}  
      }  
      if ($item.PSIsContainer) {$host.ui.rawui.foregroundColor = "Yellow"}

#      "{0:d} {1:t} {2,12} {3, 12} {4, 40}" -f $Item.CreationTime, $Item.CreationTime, $Item.Mode, $Item.length, $Item.name
        [String]::Format("{0,10}  {1,8}  {2,12}  {3,18} {4}", $Item.CreationTime.ToString("d"), $Item.CreationTime.ToString("t"), $Item.Mode, $Item.length, $Item.name)
     }   
  $host.ui.rawui.foregroundColor = $origFg  
}

#
# This can work recursively
# Order of params does not matter.
#
# A Bool param will be interpreted as the value for the -Recurse option.
# A String Param will be interpreted as the starting dir.
#
function Get-DirSize3( $p1, $p2 ) 
{
<#
    .SYNOPSIS 
      Displays total file size for specified dir (and, optionally, all subdirectories).
      Note: parameter order does not matter

    .EXAMPLE
     Get-DirSize3 $true c:\temp
     Gets the total file size for C:\temp and subdirectories.

    .PARAMETER Recurse
     Indicates whether to recurse through all subdirs

    .PARAMETER RootDir
     Directory to start scan in.

#>
     $recurse = $false
     $path = $(resolve-path .)

     if ($p1 | isBoolean) {
         $recurse = $p1
     }
     else {
         if ($p1 | isString) {
             $path = $p1
         }
     }
    if ($p2 | isBoolean) {
        $recurse = $p2
    }
    else {
        if ($p2 | isString) {
            $path = $p2
        }
    }

    if($recurse) {
        gci -re $path |
            ?{ -not $_.PSIsContainer } | 
            measure-object -sum -property Length
    }
    else {
        gci $path |
            ?{ -not $_.PSIsContainer } | 
            measure-object -sum -property Length
    }
}
