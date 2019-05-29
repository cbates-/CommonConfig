


# For example:
# ctags.exe -o p:\tags --tag-relative=yes --verbose --append=yes .\NBAUtil\*
#
# N. B.:  UNC paths don't work!
#
# On the NLG setup, P: is mapped.
$p = Get-PSDrive P -ea SilentlyContinue
$tagDir = ""
$moduleDir = ""
if($p -eq $null) {
    $tagDir = "$env:_CommonConfig\PowerShell"
    $moduleDir = "$env:_CommonConfig\PowerShell\Modules"
}
else {
    $tagDir = 'P:'
    $moduleDir = "p:\Modules"
}

$tagDir
$moduleDir

if ((Test-Path "$tagDir\tags") -eq $true) {
    Remove-Item -Force "$tagDir\tags"
}
$dirs = get-childitem  -directory -path $moduleDir

if($dirs -ne $null) {
    $exe = "ctags.exe"
    $arg1 = "--append=yes"
    $arg2 = "-o $tagDir\tags"
    $arg3 = "--tag-relative=yes"
    $arg4 = "--verbose"

    foreach($d in $dirs) {
        $arg5 = [string]::Format("{0}\{1}\{2}", $moduleDir, $d.Name, "*.ps*1")
        $arg1
        $arg2
        $arg3
        $arg4
        $arg5
         
        & $exe $arg1 $arg2 $arg3 $arg4 $arg5
        # break;
    }
}

