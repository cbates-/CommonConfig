
#
#
# C. Bates, July 2014
# Last Modified:  2015 Mar 26 11:18:18 AM
#
# Revisions:
# - 26 Mar 2015 : Re-sync with NBAUtil
# - 25 Feb 2015 : Re-sync with NBAUtil.
# - 13 Jan 2015 : Some scriptcop cleanup 
# - 5 Dec 2014  : Escape '{' and '}' characters for SendKeys() in Edit-CmdFromHistory.
# - 17 Nov      : Added Edit-CmdFromHistory, alias 'ech'
#                 Added Run-CmdFromHistory, alias 'rch'
# - 15 July     : Made Edit-TempCopy use env vars for editors, params.
#              Allowed Edit-TempCopy to be used in pipeline.
#              Prompt user to specify editor if the env var is not set.
#

$fullpathincfilename = $myinvocation.mycommand.definition
write-host "reading $fullpathincfilename" -foreground green

# 
# Check for existence of $env:Editor
# If not set, prompt for exe
# Return:
#   $true if $env:Editor gets set
#   $false if user cancels
#
function getEditor {
    [bool]$success = $true;
    try {
        $ed = $env:Editor
        # Is the env var set?
        if ($ed -eq $null) {
            Write-Host "`$env:Editor environment variable not set.";
            $ed = Read-Host "Enter editor command to use (enter to quit)";
            if ([string]::IsNullOrEmpty($ed) -eq $true) {
                # Write-Host "No editor specified." -Foreground Yellow ;
                $success = $false;
            }
            else {
                $env:Editor = $ed
                $success = $true
            }
        }
    }
    catch {
        $_
    }
    $success;
}


# 
# Check for existence of $env:CompareTool
# If not set, prompt for exe
# Return:
#   $true if $env:CompareTool gets set
#   $false if user cancels
#
function getCompareTool {
    [bool]$success = $true;
    try {
        $ed = $env:CompareTool
        # Is the env var set?
        if ($ed -eq $null) {
            Write-Host "`$env:CompareTool environment variable not set.";
            $ed = Read-Host "Enter compare command to use (enter to quit)";
            if ([string]::IsNullOrEmpty($ed) -eq $true) {
                # Write-Host "No editor specified." -Foreground Yellow ;
                $success = $false;
            }
            else {
                $env:CompareTool = $ed
                $success = $true
            }
        }
    }
    catch {
        $_
    }
    $success;
}


<#
    .SYNOPSIS 
    Use the compare utility specified by $env:CompareTool to compare two files or folders.

    .EXAMPLE
     Compare-Files ..\uat\NBARequester ..\Prod\NBARequester

    .PARAMETER path1
     Path of file/folder for left pane

    .PARAMETER path2
     Path of file/folder for right pane

     .NOTES
     Note If $env:CompareTool is not set, the user will be prompted.

#>
function Compare-Files { 
    param (
        [Parameter(Mandatory=$true)]
        $Path1, 
        [Parameter(Mandatory=$true)]
        $Path2
    )

        $gotCompareTool = getCompareTool;
        if($gotCompareTool -eq $false) {
            Write-Host "No compare tool specified." -Foreground Yellow;
            return;
        }

        if((Test-Path $Path1) -eq $false) {
            Write-Host "Path $Path1 is not valid" -Foreground Red;
            return;
        }
        if((Test-Path $Path2) -eq $false) {
            Write-Host "Path $Path2 is not valid" -Foreground Red;
            return;
        }

       & $env:CompareTool $Path1 $Path2;

    # & "C:\Program Files\Devart\Code Compare\codecompare.exe" $Path1 $Path2
}
Set-Alias cmpr Compare-Files





#
# N. B.:  Relies on $env:Editor and (optional) $env:EdParam
# For example:
#   $env:Editor = "C:\Program Files\vim\vim74\gvim.exe"
#   $env:EdParam = "--remote-silent"
#   Tested w/ and w/o EdParam being set.
#
#   !! N. B.: Don't put " or ' around editor when setting env var in Windows UI!
#
function Edit-TempCopy {
    [CmdletBinding()]
    param (
            [Parameter(ValueFromPipeline=$true, Mandatory=$true)]
            [string] $Filename
          )
    process {
        try {
            $gotEditor = getEditor;
            if($gotEditor -eq $false) {
                Write-Host "No editor specified." -Foreground Yellow;
                return;
            }

            # Is the filename passed in valid?
            if (Test-Path $Filename) {
                # Use the TEMP dir specified in the environment
                $tempDir = $env:Temp;
                copy-item -Path $Filename -Destination  $tempDir;
                $item = Get-ITem $Filename;
                $tempFile = [string]::Format("{0}\{1}", $tempDir, $item.Name);
                $tempFile;
                if ($env:EdParam -ne $null) {
                    $params = $env:EdParam, $tempFile;
                }
                else {
                    $params = $tempFile;
                }
                Write-Host "$env:Editor $params" -Foreground Magenta;
                & $env:Editor $params;
            }
            else {
                Write-Host "Can't find $Filename"
            }
        }
        catch {
            Write-Host "Error trying to copy $Filename : "
            $_
        }
    }
}

# 
# Helper function that uses $env:Editor variable
#
function Edit-InPlace {
    param (
            [Parameter(ValueFromPipeline=$true, Mandatory=$true)]
            [string] $Filename 
          )
    process {
        try {
            $gotEditor = getEditor;
            if($gotEditor -eq $false) {
                Write-Host "No editor specified." -Foreground Yellow;
                return;
            }

            # Is the filename passed in valid?
            if (Test-Path $Filename) {
                if ($env:EdParam -ne $null) {
                    $params = $env:EdParam, $Filename
                }
                else {
                    $params = $Filename
                }
                Write-Host "$env:Editor $params" -Foreground Magenta

               & $env:Editor $Filename;
            }
            else {
                Write-Host "Can't find $Filename"
            }
        }
        catch {
            Write-Host "Error trying to open $Filename : "
            $_
        }
    }
}

function pushCurDir {
    $p = Get-Location
    $s = [string]::Format("Pushing {0}", $p.ProviderPath)
    Write-Host $s
    Push-Location $p.ProviderPath
}

# 
# To handle output from something like Get-Process:
# (Get-Process | Out-String) | Edit-PipedInput
#
#
function Edit-PipedInput {
    param (
            [Parameter(ValueFromPipeline=$true, Mandatory=$true)]
            [string] $Txt 
          )
    process {
        try {
            $gotEditor = getEditor
            if ($gotEditor -eq $false) {
                Write-Host "No editor specified." -Foreground Yellow;
                return;
            }

            # Create a temp file to write to
            #
            $tempFile = [io.path]::GetTempFileName() ;
            $txt | Out-File -FilePath $tempFile;
            Write-Debug $tempFile;
            if ($env:EdParam -ne $null) {
                $params = $env:EdParam, $tempFile
            }
            else {
                $params = $tempFile
            }
           & $env:Editor $params;
        }
        catch {
            Write-Host "Error trying to use piped text : "
            $_
        }
    }
}

# 
# From:  http://blogs.technet.com/b/heyscriptingguy/archive/2013/02/19/use-a-powershell-function-to-see-if-a-command-exists.aspx
#
Function Test-CommandExists
{

    Param ($command)
    $cmdExists = $false;

    $oldPreference = $ErrorActionPreference;

    $ErrorActionPreference = 'stop';

    try {
        if(Get-Command $command) {
            Write-Host "Test-CommandExists: $command exists";
            $cmdExists = $true;
        }
    }
    Catch {
        Write-Host "Test-CommandExists: $command does not exist";
        $cmdExists = $false;
    }

    Finally {$ErrorActionPreference=$oldPreference}

    $cmdExists

} #end function test-CommandExists

#
# From:  http://msmvps.com/blogs/richardsiddaway/archive/2011/05/13/powershell-module-construction.aspx
#

function Which-Exe { 
    [CmdletBinding()] 
        param ( 
          [Parameter(Mandatory=$true)]
          [string]$ExeName
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
                    $fn = Join-Path $p $ExeName -resolve -ErrorAction SilentlyContinue;
                    if(($fn -ne $null) -and ((Test-Path $fn) -eq $true)) {
                        $found = $p;
                        break;
                    }
                }
            }

            if([string]::IsNullOrEmpty($found) -eq $false) {
                Write-Host "Found $ExeName in $found";
            }
            else {
                Write-Host "$ExeName not found in path";
            }
        }#process 

        END
        {}#end

<# 
        .SYNOPSIS
        Determine whether the filename passed in exists in a dir in the system path.


        .DESCRIPTION


        .PARAMETER ExeName
        Name of a file (usually, an executable).


        .EXAMPLE
        Which-Exe ctags.exe


        .INPUTS


        .OUTPUTS


        .NOTES


        .LINK

#>
}

function Poll-Tail { 
    [CmdletBinding()]
    param (
            [Parameter(Mandatory=$true,Position=0)]
            [string] $Filename, 
            [Parameter(Mandatory=$false,Position=1)]
            [Int32] $Cnt = 30,
            [Parameter(Mandatory=$false,Position=2)]
            [Int32] $Interval = 30
          )
    [DateTime]$startTime = Get-Date -Format g
    $prevLast = ""
    $msg =  "Last line of prev. poll in Yellow.  Log listing is rev. chron."
    $startMsg = [string]::Format("Polling started: {0}", $startTime.ToLongTimeString())
    $intMsg = [string]::Format("Polling interval: {0} secs", $interval);
    $ctrlC = "Ctrl-C to quit."
    $msg

    Set-Location $pwd.ProviderPath;
    $fn = Resolve-Path $Filename
    $fn = $fn.ProviderPath;
    # $fn

        do
        {
            clear-host;
            Write-Host $msg
            Write-Host $startMsg
            Write-Host $intMsg
            Write-Host $ctrlC
            Write-Host "."
            Write-Host $prevLast -Foreground Yellow
            Write-Host "."
            # -Tail is new in PS 3.0
            # $new = Get-Content $fn -Tail $cnt
            $new = [IO.File]::ReadAllText($fn);
            $new2 = @()
            $new2 = $new -split "`r`n"  
            # $new2 = Split-String -Separator "`r`n" -Input $new -RemoveEmptyStrings
            $new = $new2 | Select -Last $cnt
            $new = $new | Where { $_.Length -gt 0 }

            $prevLast = $new | Select-Object -Last 1
            # Write-Host "prevLast : $prevLast" -foreground magenta

            [array]::Reverse($new)
            $new
            Start-Sleep -Seconds $Interval
        } until ($false)
<#
    .SYNOPSIS 
      Displays last $Cnt lines of $Filename, every $Interval seconds
      Ctrl-C to stop polling.

    .EXAMPLE
     pollTail jnk.log 
     Get the last 30 lines of jnk.txt every 30 seconds (default count and interval)

    .EXAMPLE
     pollTail jnk.log -Cnt 12 -Interval 15
     Get the last 12 lines of jnk.txt every 15 seconds

    .PARAMETER Filename
     File to examine

    .PARAMETER Cnt
     Number of lines to take (default = 30)

    .PARAMETER Interval
     Number of seconds between polling (default = 30)

     .NOTES
     Note that the "Polling started" time is local, and may not align with the time on the monitored file.

#>
}


function Run-CmdFromHistory {
    param (
            [Parameter(Mandatory=$false)]
            [Int32] $CmdCnt = 20
    )
    $cmds=get-history | select -last $CmdCnt;
    $cmds;

    Write-Host "Enter a cmd id to run (empty to cancel)" -Foreground Yellow;
    $id = Read-Host " ";
    if([string]::IsNullOrEmpty($id) -eq $false) {
        invoke-history $id;
    }
    else {
        "Canceled.";
    }

<#
    .SYNOPSIS 
    A concatenation of Get-History/Invoke-History in one command.
    Display last CmdCnt number of commands.  Allow user to select by number and run.

    .EXAMPLE

    .PARAMETER CmdCnt
     (Optional)  Number of commands to display.  Default = 15.

     .NOTES
     Note See Edit-CmdFromHistory

#>
}
Set-Alias rch Run-CmdFromHistory -Scope "Global"


# 
# SendKeys interprets '{' and '}' as enclosing special names ("{Enter}", for example).
# Surround them in '{}' to make them literal again.
#
function Handle-BracesForSendKeys {
    param (
            [Parameter(Mandatory=$true)]
            [string] $Str
    )
    $new = $Str -replace '([{}])', '{$1}'
    # "    $new"
    $new

}


function Edit-CmdFromHistory {
    param (
            [Parameter(Mandatory=$false)]
            [Int32] $CmdCnt = 20
    )
    $cmds=get-history | select -last $CmdCnt;
    $cmds;

    Write-Host "Enter a cmd id to edit (empty to cancel)" -Foreground Yellow;
    $id = Read-Host " ";
    if([string]::IsNullOrEmpty($id) -eq $false) {
        $title = $Host.UI.RawUI.WindowTitle;
        $c = Get-History $id;
        $wshell = New-Object -ComObject wscript.shell;

        $result = $wshell.AppActivate($title)
        
        # if($result -eq $true) {
        # $keys = $c.CommandLine;
        $keys = Handle-BracesForSendKeys $c.CommandLine;

        Sleep .5
        $wshell.SendKeys($keys) 
        # }
    }
    else {
        "Canceled.";
    }
<#
    .SYNOPSIS 
    A concatenation of Get-History/Invoke-History in one command, but allows editing of command before executing.
    Display last CmdCnt number of commands.  Allows user to select by number and pastes the command on the command line for editing.  

    .EXAMPLE

    .PARAMETER CmdCnt
     (Optional)  Number of commands to display.  Default = 15.

     .NOTES
     Note See Run-CmdFromHistory

#>
}
Set-Alias ech Edit-CmdFromHistory -Scope "Global"



#
# Helper fn to return YYYYMMDD
#
function Get-CompactDate {
    $date = (Get-Date).ToShortDateString()
    $parts = $date -split "/"
    $month = $parts[0]
    $day = $parts[1]
    if ($month.Length -lt 2) {
        $month = [string]::Format("0{0}", $month)
    }
    if ($day.Length -lt 2) {
        $day = [string]::Format("0{0}", $day)
    }
    $date = [string]::Format("{0}{1}{2}", $parts[2],  $month,  $day)
    $date
}


# Helper fn to return HHMMSS
function Get-CompactTime {
    $t = (get-date).TimeOfDay | select Hours, Minutes, Seconds
    # $time = (Get-Date).ToLongTimeString()
    # $time = $time -split { $_ -eq " " -or $_ -eq ":" }
    $hrs = $t.Hours;
    $mins = $t.Minutes;
    $secs = $t.Seconds;

    $hrs= [string]::Format("{0}", $t.Hours);
    if($hrs.Length -lt 2) {
        $hrs= [string]::Format("0{0}", $hrs);
    }

    $mins= [string]::Format("{0}", $mins);
    if($mins.Length -lt 2) {
        $mins= [string]::Format("0{0}", $mins);
    }

    $secs= [string]::Format("{0}", $t.Seconds);
    if($secs.Length -lt 2) {
        $secs= [string]::Format("0{0}", $secs);
    }
    [string]::Format("{0}.{1}.{2}", $hrs, $mins, $secs )
}
# Import-Module NBA.Support.SQL


#
# Helper to make sure path has trailing '\'
#
function Verify-FinalSlash([string] $path) {
    [string] $fixedPath = $path
    if ($path[$path.Length -1] -ne "\") {
        $fixedPath = [string]::Format("{0}\", $path)
    }
    $fixedPath
}

#
# Helper to make sure path has trailing '*'
#
function Verify-FinalStar([string] $path) {
    [string] $fixedPath = $path
    if ($path[$path.Length -1] -ne "*") {
        $fixedPath = [string]::Format("{0}\*", $path)
    }
    $fixedPath
}

Function Prompt-TrueOrFalseResponse {
    param (
        [Parameter(Mandatory=$false)]
        [string] $Prompt = [string]::Empty,
        [Parameter(Mandatory=$false)]
        [bool] $Default= $false,
        [Parameter(Mandatory=$false)]
        [string] $Color = "Yellow"
    )
    $result = $Default;
    $msg=""
    if([string]::IsNullOrEmpty($Prompt) -eq $false) {
        $msg = $Prompt;
        $msg =[string]::Format("{0}{1}", $msg, "`r`n")
    }
    $msg =[string]::Format("{0}{1}", $msg, "True or False, enter for default: $Default")

    Write-Host $msg -Foreground $Color
    $res = Read-Host
    if($res -eq "true") {
        $result = $true;
    }
    elseif($res -eq "false") {
        $result = $false;
    }

    $result
}


Function Prompt-StringResponse {
    param (
        [Parameter(Mandatory=$false)]
        [string] $Prompt = [string]::Empty,
        [Parameter(Mandatory=$false)]
        [string] $Default= [string]::Empty,
        [Parameter(Mandatory=$false)]
        [string] $Color = "Yellow"
    )
    $result = $Default;
    $msg=""
    if([string]::IsNullOrEmpty($Prompt) -eq $false) {
        $msg = $Prompt;
        $msg =[string]::Format("{0}{1}", $msg, "`r`n")
    }
    $msg =[string]::Format("{0}{1}", $msg, "Enter a new value, or press enter for default: $Default")

    Write-Host $msg -Foreground $Color
    $res = Read-Host
    if([string]::IsNullOrEmpty($res) -eq $false)  {
        $result = $res;
    }

    $result
}

function Find-Text { 
    param( 
            [Parameter(Mandatory=$true)]
            $Text,

            [Parameter(Mandatory=$false)]
            $Filename="*",

            [Parameter(Mandatory=$false)]
            $Recurse=$false,
            [Parameter(Mandatory=$false)]
            $AllMatches=$True
<#           
            [Parameter(Mandatory=$false)]
            $FnOnly=$false,
#>
         )
        # $reply = read-host "Search recursively? (y/n)"
        # $Recurse = ($reply -eq "y")
        Write-Host "Recurse : $Recurse"

        $s =  [string]::Format("Text: {0}  Filename: {1}, recurse: {2}", $Text, $Filename, $Recurse)
        Write-Host $s -ForegroundColor Yellow

        # Select-String -Path E:\Data\PSExtras\*.ps1 -Pattern 'write-host' -List | select filename, line –Unique

        if($Recurse) {
            # Write-Host "Searching recursively"
            if($AllMatches) {
                Get-ChildItem -File -Recurse -Filter $Filename | Select-String $Text -AllMatches
            }
            else {
                Get-ChildItem -File -Recurse -Filter $Filename | Select-String $Text -List
            }
            # Select-String -Path $pwd -Include $Filename -Pattern $Text -List | select filename, line -Unique
            # $dirs = Get-ChildItem -Directory -Recurse 
            # foreach ($d in $dirs) {
                # $p = Join-Path $d.FullName $Filename;
                # $s = Select-String -Path $p -Pattern $Text -List | select filename, line -Unique

                # if([string]::IsNullOrEmpty($s) -eq $false) {
                    # $d.FullName;
                    # $s;
                # }
            # }
        }
        else {
            Write-Host "NOT searching recursively"
            # Get-ChildItem -Path $Filename | Select-String $Text
            if($AllMatches) {
                Select-String -Path $Filename -Pattern $Text -AllMatches
            }
            else {
                Select-String -Path $Filename -Pattern $Text -List | select filename, line -Unique
            }
        }
<#
    .SYSNOPSIS
        - Find specified Text in files
        - Choose to search recursively or not

    .DESCRIPTION
        - Find specified Text in files with date.

    .PARAMETER Text
        The text to search for

    .PARAMETER Filename
        filespec to search, wildcards ok

    .NOTES

    .EXAMPLE

#>
} # Find-Text

