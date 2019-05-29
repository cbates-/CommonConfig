
try {
    set-Location $env:USERPROFILE\vimfiles\sessions

    $files = gci *.vim;
    del *.out;
    foreach ($f in $files) { 
        $out = [string]::Format("{0}.out", $f.Name);
        Write-Host "Cleaning $f"
        Get-content $f | where-object {$_ -notmatch "^args " } | set-content $out; 
    }

    del *.vim
    foreach ($f in (gci *.out)) { rename-item  $f $f.BaseName }
}
catch {
    $_
}
