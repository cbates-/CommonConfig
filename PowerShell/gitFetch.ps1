function getGitStatus {
    param($d, $fn, $reallyFetch)

    $ss = $null;
    cd $d;
    if(Test-Path $fn) {
        Remove-Item $fn;
    }
    # Write-Host $d -Foregroundcolor Yellow;
    try {
        # "*>" is a redirection symbol --  "Sends all output types to the specified file."
        & git status *> $fn;
        if($LastExitCode -lt 1)
        {
            $msg = ""
            Write-Host $d -Foregroundcolor Yellow;
            $ss = Select-String -Path $fn -SimpleMatch "Changes to be committed";
            if($null -eq $ss) {
                # Write-Host "`t" -nonewline;
                $msg += [string]::Format("`t{0} has staged files", $pwd);
                $msg += "`r`n";
                # Write-Host $msg
            }
            $ss = Select-String -Path $fn -SimpleMatch "Changes not staged for commit";
            if($null -eq $ss) {
                # Write-Host "`t" -nonewline;
                $msg += [string]::Format("`t{0} has modified files", $pwd);
                $msg += "`r`n";
                # Write-Host $msg
            }
            $ss = Select-String -Path $fn -SimpleMatch "Untracked files";
            if($null -eq $ss) {
                # Write-Host "`t" -nonewline;
                $msg += [string]::Format("`t{0} has untracked files", $pwd);
                $msg += "`r`n";
                # Write-Host $msg
            }

            if($msg -eq "") {
                $msg = "`tNo modified files";
            }

            Write-Host $msg;
        }
    }
    catch {}
}

    $dirs = dir $pwd | ?{$_.PSISContainer}
    $start = $pwd
    $fn = $env:temp
    $fn += '\gitStat'

    # Write-Host $start
    getGitStatus $start $fn

    foreach ($d in $dirs) {
        # Write-Host $d
        getGitStatus $d $fn
        cd $start
    }



