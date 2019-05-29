<#
.SYNOPSIS

.DESCRIPTION
    Build the specified VisualStudio project or solution file.
    Sets necessary env. variables with vsvars32.bat, if not already set.

.PARAMETER Proj
    The project or solution to build (required)

.PARAMETER Config
    The configuration -- Debug, Release, etc.  Default = DEBUG.

.PARAMETER Target
    The target -- CLEAN, REBUILD, etc.  Default = BUILD.
 
.EXAMPLE
    PS C:\ > msbld12.ps1 floogle.sln

.EXAMPLE
    PS C:\ > msbld12.ps1 blargle.sln -Target="CLEAN"

.REMARKS
    Config options: Debug, Release, etc. Default: DEBUG
    Target options: CLEAN, BUILD, REBUILD, etc.  Default: BUILD
 
#>

#
# Adaptation of my msbld12.bat
#
# 22 July 2014
# Added another place to look for MSBuild.exe if VSINSTALLDIR is not set.
#
#

# $DebugPreference = "Continue";
$DebugPreference = "SilentlyContinue";

function findMsBuildExe {

    $DebugPreference = "Continue";
    # $DebugPreference = "SilentlyContinue";

    # 
    # Add strings to this array as we learn of more locations that MSBuild.exe might be installed
    #
    $msBuildLocations = @($env:VSINSTALLDIR,
                        "C:\Program Files\MSBuild",
                        "C:\Program Files (x86)\MSBuild" );

    $msBuildExe = [string]::Empty;
    foreach ($d in $msBuildLocations) {
        Write-Debug "`$d: $d";
        if ($d -ne $null) {
            $msb = get-childitem -file -filter "msbuild.exe" -recurse -Path $d;
            if ($msb -ne $null) {
                if($msb -is [System.IO.FileInfo]) {
                    Write-Host "FILEINFO, yo'"
                        $msBuildExe = $msb;
                }
                else {
                    if ($msb.Count -gt 1) {
                        $msBuildExe = $msb[0];
                    }
                    else {
                        $msBuildExe = $msb;
                    }
                }
                break;
            }
        }
    }
    $msBuildExe;

    $DebugPreference = "SilentlyContinue";
}

function Build-Solution {
    param(
            ## The project or solution to build
            [Parameter(Mandatory = $true)]
            [string] $Proj,
            [string] $Config="DEBUG",
            [string] $Target="BUILD"
         )

    # Set the VS envronment
    # Write-Host "MSVARS__12"  $env:MSVARS__12

    $set = $env:MSVARS__12 -ne "" ;

    # Write-Host "Set: " $set
    Write-Host "Config: " $Config;
    Write-Host "Target: " $Target;

    # Read-Host -prompt "Press Enter"

    if ($set -eq $false) {
        if (Test-Path "C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\Tools\vsvars32.bat" ) {
            Write-Host "x86 version";
            # Invoke-CmdScript  "C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\Tools\vsvars32.bat"
            Invoke-BatchFile  "C:\Program Files (x86)\Microsoft Visual Studio 12.0\Common7\Tools\vsvars32.bat"
        } 
        ELSE {
            Write-Host "non-x86 version";
            Invoke-BatchFile  "C:\Program Files\Microsoft Visual Studio 12.0\Common7\Tools\vsvars32.bat"
        }
    }  
    else {
        Write-Host "Env vars already set"
        Write-Host "--------------------"
    }

    $env:MSVARS__12="Ms12VarsSet";

    # Add VS executables dir to path
    $msBuildExe = findMsBuildExe;
    if ([string]::IsNullOrWhiteSpace($msBuildExe) -eq $true) {
        Write-Host "Could not find MSBuild.exe" -Foreground Yellow
        return ;
    }

    Write-Debug "cmd: $msBuildExe.FullName $Proj  /p:Configuration=$Config /property:WarningLevel=1 /t:$Target"

    & $msBuildExe.FullName $Proj  /p:Configuration=$Config /property:WarningLevel=1 /t:$Target 
}
Set-Alias bld12 Build-Solution
