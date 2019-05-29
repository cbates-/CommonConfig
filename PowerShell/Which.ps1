
#
# From:  http://msmvps.com/blogs/richardsiddaway/archive/2011/05/13/powershell-module-construction.aspx
#

function Which-Exe { 
    [CmdletBinding()] 
        param ( 
          [Parameter(Mandatory=$true)]
          [string]$exeName
        ) 
        BEGIN
        {
            $path = $env:Path;
            $found = [string]::Empty;
        }#begin 

        PROCESS
        {
            $pathArray = $path -Split ";";
            foreach($p in $pathArray) {
                # $p
                if([string]::IsNullOrEmpty($p) -eq $false) {
                    $fn = Join-Path $p $exeName -resolve -ErrorAction SilentlyContinue;
                    if(($fn -ne $null) -and ((Test-Path $fn) -eq $true)) {
                        $found = $p;
                        break;
                    }
                }
            }

            if([string]::IsNullOrEmpty($found) -eq $false) {
                Write-Host "Found $exeName in $found";
            }
            else {
                Write-Host "$exeName not found in path";
            }
        }#process 

        END
        {}#end

<# 
        .SYNOPSIS
        Determine whether the filename passed in exists in a dir in the system path.


        .DESCRIPTION


        .PARAMETER exeName
        Name of a file (usually, an executable).


        .EXAMPLE
        Which-Exe ctags.exe


        .INPUTS


        .OUTPUTS


        .NOTES


        .LINK

#>

}
