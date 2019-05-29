Param(
  [string]$localOrRemoteOrBoth="both"
)
# 
# Last Modified:  2015 Mar 31 2:10:11 PM
#

function getGitStatus {
    param($d, $fn)

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
            if($ss -ne $null) {
                $s = [string]::Format("`t{0} has staged files{1}", $pwd, "`r`n")
                Set-Variable -Name 'msg' -Value $s
                Write-Host $msg -Foregroundcolor Green
            }
            $ss = Select-String -Path $fn -SimpleMatch "Changes not staged for commit";
            if($ss -ne $null) {
                # $s = [string]::Format("`t{0} has modified files{1}", $pwd, "`r`n")
                # Set-Variable -Name 'msg' -Value $s
                Set-Variable -Name 'msg' -Value ([string]::Format("`t{0} has modified files{1}", $pwd, "`r`n")) | out-null
                Write-Host $msg -Foregroundcolor Yellow
            }
            $ss = Select-String -Path $fn -SimpleMatch "Untracked files";
            if($ss -ne $null) {
                $s = [string]::Format("`t{0} has untracked files{1}", $pwd, "`r`n")
                Set-Variable -Name 'msg' -Value $s
                Write-Host $msg -Foregroundcolor White
            }

            if($msg -eq "") {
                $msg = "`tNo modified files";
            }

            # Write-Host $msg;
        }
    }
    catch {
        $_
        $Error[0]
    }
}

function getGitFetchDryRun {
    param($d, $fn)

    $ss = $null;
    cd $d;
    if(Test-Path $fn) {
        Remove-Item $fn;
    }
    # Write-Host $d -Foregroundcolor Yellow;
    try {
        # "*>" is a redirection symbol --  "Sends all output types to the specified file."
        & git fetch --all --dry-run *> $fn;
        if($LastExitCode -lt 1)
        {
            $msg = ""
            Write-Host $d -Foregroundcolor Yellow;
            $ss = Select-String -Path $fn -SimpleMatch "From";
            if($ss -ne $null) {
                # Write-Host "`t" -nonewline;
                $msg += [string]::Format("`t{0} has updates available ", $pwd);
                $msg += "`r`n";
                # Write-Host $msg
            }

            Write-Host $msg;
        }
    }
    catch {
        Write-Host "Error in getGitFetchDryRun" -Foreground Red
        $error[0];
    }
}

# 
# This where the work gets done by dot-sourcing this file.
#

    $dir = dir $pwd | ?{$_.PSISContainer}
    $start = $pwd
    $fn = $env:temp
    $fn += '\gitStat'

    $fetchFn = $env:temp
    $fetchFn += '\gitFetch'

   if(($localOrRemoteOrBoth.ToLower() -eq "local") -or ($localOrRemoteOrBoth.ToLower() -eq "both"))
   {
       # Write-Host $start
       Write-Host "---------------------------------------"
       Write-Host "Checking for local changes"
       Write-Host "---------------------------------------"
       getGitStatus $start $fn 

       foreach ($d in $dir) {
           # Write-Host $d
           getGitStatus $d $fn 
           cd $start
       }
   }


   if(($localOrRemoteOrBoth.ToLower() -eq "remote") -or ($localOrRemoteOrBoth.ToLower() -eq "both"))
   {
       Write-Host "---------------------------------------"
       Write-Host "Checking for remote changes"
       Write-Host "---------------------------------------"
       getGitFetchDryRun $start $fetchFn

       foreach ($d in $dir) {
           # Write-Host $d
           getGitFetchDryRun $d $fetchFn 
           cd $start
       }
   }

