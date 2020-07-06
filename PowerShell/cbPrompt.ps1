
# Get the crrent prompt.
# Write a new ps1 file to set the prompt again, adding new functionality in front of the existing prompt script.
#
#
$curPrompt = cat function:\prompt

Write-Host "In cbPrompt" -Foreground Red

$s = "function global:prompt {"
$s += "`n"

# $s += "try {"
$s += '$s = Get-Location -stack'
$s += "`n"
$s += '$s = $s | Select -Unique'
$s += "`n"

$s += '$p = $s | Select-String -SimpleMatch $pwd'
$s += "`n"
$s += 'if($p -eq $null) {'
$s += "`n"
$s += '    Write-Host "pushing: " -nonewline'
$s += "`n"
$s += "    Write-Host $pwd"
$s += "`n"
$s += "    pushd"
$s += "`n"
$s += "}"
$s += "`n"
# $s += "`n"
# $s += "}"
# $s += "`n"
#
# $s += "catch {"
# $s += "`n"
# $s += 'Write-Host "CAUGHT"'
# $s += "`n"
# $s += '$Error[0] | fl * -force'
# $s += "`n"
# $s += "}"
# $s += "`n"
#
# $s += "finally {"
$s += "`n"
$s += '$host.ui.RawUI.WindowTitle = ShortenPath 32'
$s += "`n"
$s += $curPrompt
$s += "`n"
# $s += '}'
$s += "`n"
$s += '}'
if (Test-Path $env:temp\temp.ps1) {
   Remove-Item -Force $env:temp\temp.ps1
}


$s | Out-File $env:temp\temp.ps1

. $env:temp\temp.ps1

if (Test-Path $pwd\temp.ps1) {
    Remove-Item -Force $pwd\temp.ps1
}


