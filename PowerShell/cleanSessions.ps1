
try {
    set-Location $env:USERPROFILE\vimfiles\sessions

    $files = Get-ChildItem *.vim;
    Remove-Item *.out;
    foreach ($f in $files) {
        $out = [string]::Format("{0}.out", $f.Name);
        Write-Host "Cleaning $f"
        Get-content $f | where-object {$_ -notmatch "^args " } | set-content $out;
    }

    Remove-Item *.vim
    foreach ($f in (Get-ChildItem *.out)) { rename-item  $f $f.BaseName }
}
catch {
    $_
}
