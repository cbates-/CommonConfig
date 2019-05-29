

# 
# Last Modified:  2015 May 22 11:52:42 AM
#

. CtagFileOrDir.ps1


function TagRecursively {
    param (
        [Parameter(Mandatory=$true)] [string] $RootDir,
        [Parameter(Mandatory=$false)] [string] $tagFile="$env:LOCALAPPDATA\tags",
        [Parameter(Mandatory=$false)] [string] $append="yes",
        [Parameter(Mandatory=$false)] [string] $tagRelative="yes"
    )

    if((Test-Path $tagFile) -eq $false) {
        New-Item -path $tagFile -ItemType "File"
    }

    $tagFileResolved = Resolve-Path $tagFile

    if((Test-Path $RootDir) -eq $true) {
        $resolved = Resolve-Path $RootDir
        $dirList = gci -directory $resolved

        foreach($d in $dirList) {
            $srcs = [string]::Format("{0}\*.ps*1", $d.FullName)
            Ctag-FileOrDir $srcs $tagFileResolved $append $tagRelative
        }
    }
    else {
        Write-Host "Invalid path: $RootDir" -foreground Red
    }
}

