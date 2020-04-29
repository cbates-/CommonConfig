
#
# $dirs =  Get-Location -Stack
#  $a = $dirs | where {$_.ProviderPath -eq "C:\temp\Gak" }
#
#

function cdd {
    param(
        [Parameter(Mandatory=$true)]
        $dirName
    )
    $resolved = $(resolve-path $dirName)
    $s = [string]::Format("resolved: {0}", $resolved)
    Write-Host $s

    Set-Location $resolved

    $dirs = Get-Location -Stack
    $found = $dirs | Where-Object { $_.Name -Like $resolved }

    if($null -eq $found) {
        Write-Host "pushing " -NoNewline
        Write-Host $found.ProviderPath
        push-location -LiteralPath $found.ProviderPath
    }
}

