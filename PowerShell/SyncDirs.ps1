###############################################################################
##script:           Sync-Folders.ps1
##
##Description:      Syncs/copies contents of one dir to another. Uses MD5
#+                  checksums to verify the version of the files and if they
#+                  need to be synced.
##Created by:       Noam Wajnman
##Creation Date:    June 9, 2014
#
# Original: http://scriptingblog.com/2014/06/10/synchronize-folderdirectory-contents/
#
# Modified by C. Bates for 2-way syncing, newest file wins.
# Last Modified:  2015 May 21 11:33:43 AM
# 
###############################################################################
#FUNCTIONS
#
# Can fail when somehting like a .dll is in use
#
function Get-FileMD5 {
    Param([string]$file)
    $hash = 1;
    $md5 = [System.Security.Cryptography.HashAlgorithm]::Create("MD5")
    try {
        $IO = New-Object System.IO.FileStream($file, [System.IO.FileMode]::Open)
        $StringBuilder = New-Object System.Text.StringBuilder
        $md5.ComputeHash($IO) | % { [void] $StringBuilder.Append($_.ToString("x2")) }
        $hash = $StringBuilder.ToString() 
        $IO.Dispose()
    }
    catch {
        $_;
    }
    return $hash
}
#VARIABLES
# $DebugPreference = "continue"
#parameters
# $SRC_DIR = 'c:\temp\sync1\'
# $DST_DIR = 'C:\temp\sync2\'
# $doCopy = $true
#SCRIPT MAIN
function Sync-Dirs {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]        [string] $SRC_DIR,
        [Parameter(Mandatory=$true)]        [string] $DST_DIR,
        [Parameter(Mandatory=$false)]       [string] $Excludes = "*.dll",
        [Parameter(Mandatory=$false)]       [bool] $doCopy = $false
    )
    # $DebugPreference = "continue"
    # clear
    if(((Test-Path $SRC_DIR) -eq $true)) {
        $SourceFiles = GCI -Exclude "*.dll" -Recurse $SRC_DIR | ? { $_.PSIsContainer -eq $false} #get the files in the source dir.
        $SourceFiles | % { # loop through the source dir files
            $cpy = $false;
            $src = $_.FullName #current source dir file
            Write-Debug $src
            $src_resolved = Resolve-Path $SRC_DIR;
            $dst_resolved = Resolve-Path $DST_DIR
            $dest = $src -replace $src_resolved.Path.Replace('\','\\'),$dst_resolved.Path #current destination dir file
            if (test-path $dest) { 
                # if file exists in destination folder check MD5 hash
                $srcMD5 = Get-FileMD5 -file $src
                Write-Debug "Source file hash: $srcMD5"
                $destMD5 = Get-FileMD5 -file $dest
                Write-Debug "Destination file hash: $destMD5"
                if ($srcMD5 -eq $destMD5) { 
                    # if the MD5 hashes match then the files are the same
                    Write-Debug "File hashes match. File already exists in destination folder and will be skipped."
                    $cpy = $false
                }
                else { 
                    # if the MD5 hashes are different then copy the file and overwrite the older version in the destination dir
                    $cpy = $true
                    Write-Debug "File hashes don't match. File will be copied to destination folder." 
                }
            }
            else { 
                # if the file doesn't in the destination dir it will be copied.
                Write-Debug "File doesn't exist in destination folder and will be copied."
                $cpy = $true
            }
            # Write-Debug "Copy is $cpy   doCopy is $doCopy" 
            if ($cpy -eq $true) { 
                # copy the file if file version is newer or if it doesn't exist in the destination dir.
                if (!(test-path $dest)) {
                    if($doCopy -eq $true) {
                        Write-Host "Copying $src to $dest" -foreground Green
                        New-Item -ItemType "File" -Path $dest -Force   
                        Copy-Item -Path $src -Destination $dest -Force
                    }
                    else {
                        Write-Host "Would copy $src to $dest" -foreground Cyan
                    }

                }
                else {  # copy newer over older
                    if ((gci $src).LastWriteTime -gt (gci $dest).LastWriteTime) {
                        if($doCopy -eq $true) {
                            Write-Host "Copying $src to $dest" -foreground Green
                            Copy-Item -Path $src -Destination $dest -Force
                        }
                        else {
                            Write-Host "Would copy $src to $dest" -foreground Cyan
                        }
                    }
                    else {
                        if($doCopy -eq $true) {
                            Write-Host "Copying $dest to $src" -foreground Green
                            Copy-Item -Path $dest -Destination $src -Force
                        }
                        else {
                            Write-Host "Would copy $dest to $src" -foreground Cyan
                        }
                    }
                }
            }
        }
    }
}
