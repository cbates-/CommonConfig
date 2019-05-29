###############################################################################
#
# Original: http://scriptingblog.com/2014/06/10/synchronize-folderdirectory-contents/
#
# Modified by C. Bates:  
#   Very specific for syncing folders in ~\DropBox\Skydrive with folders in  ~\SkyDrive.
#
# Last Modified:  2015 May 21 11:33:41 AM
# 
###############################################################################

. SyncDirs.ps1

# 
# May 2015 OneDrive stopped working on my NGL VM.
# DropBox does work.
# ~\DropBox\SkyDrive\ is a 'mirror' of ~\SkyDrive.
# On the NLG VM, $env:_skydrive = ~\DropBox\SkyDrive.
#
# This function is very spefic in syncing ~\SkyDrive and ~\DropBox\SkyDrive 
# on computers with access to both.
# Since the NLG computer has only a subset of the full ~\SkyDrive, 
# we only want to sync dirs that exist in ~\DropBox\SkyDrive.
#
#

function Sync-DBox_SkyDirsWithSkydrive {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]        [string] $skyDriveName = "SkyDrive",
        [Parameter(Mandatory=$false)]        [bool] $doCopy = $false,
        [Parameter(Mandatory=$false)]        [string[]] $dirExcludes = @("z6z6z"),
        [Parameter(Mandatory=$false)]        [string] $dbgPref = "SilentlyContinue"
    )
    
    $userHome = $env:USERPROFILE
    
    $DebugPreference = $dbgPref;

    #
    # Get list of skydrive replicas under Dropbox
    #
    $src = "";
    $dst = ""
    $filt = [string]::Format("{0}\DropBox\SkyDrive", $userHome)
    $dirList = Get-ChildItem -Directory -path $filt -Exclude $dirExcludes
    foreach ($d in $dirList) { 
        Write-Debug $d;

        $src = [string]::Format("{0}\DropBox\SkyDrive\{1}", $userHome, $d.Name);
        $dst = [string]::Format("{0}\{1}\{2}", $userHome, $skyDriveName, $d.Name);
        
        Write-Debug "src: $src"
        Write-Debug "dst: $dst"

        if((Test-Path $src) -eq $true) {
            if((Test-Path $dst) -eq $false) {
                New-Item -Itemtype Directory -Path $dst
            }
            Sync-Dirs $src $dst -doCopy $doCopy
        }
     }
}
