
<#
    .SYNOPSIS 
    Shorten string passed in to $len.
    If charaters are removed, they are replaced by '...'

    .EXAMPLE
     $s = ShortenPath -Len 12
     Return the $pwd as string, max length 12.

		C:\users\hxchba\dropbox\skydrive\PowerShell> ShortenPath -Len 24
		C:\users\h...PowerShell

    .PARAMETER Len
     Max length of returned string (Default = 64)

    .PARAMETER Path
     String to shorten (Default = $pwd.ProviderPath)


     .NOTES
     Note 

#>

function ShortenPath { 
    param (
        [string]$Path = $pwd.ProviderPath, 
        $Len = 64
    )
    try {

        # Write-Host "trimmedPath : $trimmedPath"
        $trimmedPath = $path;
        # Write-Host "trimmedPath : $trimmedPath"
        $max = $len;
        # Write-Host $max
        $pad = ($max / 2) - 2;
        # Write-Host $pad
        if ($trimmedPath.Length -gt $max)
        {
            $x = $trimmedPath.Substring(0, $pad);
            $x += "...";
            $x += $trimmedPath.Substring($trimmedPath.Length - $pad);
            $trimmedPath = $x;
        }
    }
    catch {
        Write-Host "EXCEPTION CAUGHT";
        # $_ | fl * -force
        # $Error[0] | fl * -force;
        Write-Host $_
        Write-Host $Error[0]
    }
    return $trimmedPath
}

