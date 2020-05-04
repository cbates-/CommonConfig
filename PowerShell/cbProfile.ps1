#
# Last Modified:  2020 Jan 09 9:01:05 AM
#
Set-StrictMode -Version Latest
#
$fullPathIncFileName = $MyInvocation.MyCommand.Definition
Write-Host "Reading $fullPathIncFileName" -Foreground Cyan
#
# Put things that would go in c:\bin here?  Like gitdiff.bat?
#
$env:Path += ";$env:_CommonConfig\bin"
$env:Path += ";$env:_CommonConfig\powershell"
$pp = select-string -pattern "vim81" -InputObject $env:Path
if($null -eq ($env:Path | Select-String "vim81") ) {
	$env:Path += ";C:\Program Files\Vim\vim81"
}

#
# Reference
#
# Get-ChildItem -recurse | Select-String -pattern "lwd" | group path | select name


# can be turned off in individual scripts.
Set-StrictMode -Version 2.0

<#
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
    Finally { $ErrorActionPreference=$oldPreference }

    $cmdExists

} #end function test-CommandExists
#>

# Add my shared PowerShell Modules dir to PSModulePath
if(($null -eq ($env:PSModulePath | Select-String "CommonConfig\\PowerShell\\Modules") ) -and
    ($null -eq ($env:PSModulePath | Select-String "OneDrive\\PowerShell\\Modules")) ) {
    Write-Host "Adding $env:_CommonConfig\PowerShell\Modules to PSModulePath"
    if (($null -eq $env:PSModulePath) -and ($env:PSModulePath[$env:PSModulePath.Length - 1] -ne "")) {
        $env:PSModulePath += ";"
        Write-Host "; to PSModulePath"
    }
    $env:PSModulePath += "$env:_CommonConfig\PowerShell\Modules"
    Write-Host "$env:PSModulePath     +*+*+*+*+*+*+"
}

Write-Host "Trying to load PSFolderSize"
Write-Host "CWD: " + $PWD.ProviderPath
# Import-Module "..\PSFolderSize\PSFolderSize\PSFolderSize.psd1"
Import-Module "$env:_CommonConfig\PowerShell\Modules\PSFolderSize\PSFolderSize"


# ShowUI provides access to WPF things.  Used by my DirMgr.
# Import-Module ShowUI -ErrorAction SilentlyContinue

$prof = [string]::Format("{0}\{1}", $env:USERPROFILE, "OneDrive");

if (($null -ne $env:PSScriptRoot) -and ($env:PSScriptRoot[$env:PSScriptRoot.Length-1] -ne ";" ) ) {
    $env:PSScriptRoot += ";"
}
$env:PSScriptRoot += "$prof\PowerShell\Modules"



# Problems with something in cbFilters with PowerShell Core 6.
$verMajor = $PsVersionTable.PSVersion.Major
Write-Host "Version: " $PsVersionTable.PSVersion
if ($verMajor -lt 6) {
	. $env:_CommonConfig\PowerShell\cbFilters.ps1
}

. $env:_CommonConfig\PowerShell\ShortenPath.ps1
. $env:_CommonConfig\PowerShell\colorDir.ps1
# . $env:_CommonConfig\PowerShell\dirMgr2.ps1
. $env:_CommonConfig\PowerShell\set-clipboard.ps1
# . $env:_CommonConfig\PowerShell\Connect-Mstsc.ps1
# Moved to CBUtil
# . $env:_CommonConfig\PowerShell\Find-Text.ps1
. $env:_CommonConfig\PowerShell\GetMostRecentFiles.ps1
. $env:_CommonConfig\PowerShell\msbld12.ps1
#
# Customization for PSReadLine
# . $env:_CommonConfig\PowerShell\psreadline_cb.ps1

if((Test-Path $env:_CommonConfig\PowerShell\Which.ps1) -eq $true) {
	. $env:_CommonConfig\PowerShell\Which.ps1
}
if((Test-Path $env:_CommonConfig\PowerShell\diskspace.ps1) -eq $true) {
	. $env:_CommonConfig\PowerShell\diskspace.ps1
}


function dsm_ {
    param(
        [Parameter(Mandatory=$true)]
        [string]$mod
    )
    if (Test-Path $mod) {
        . $mod
    }
    else {
        Write-Warning "$mod not found"
    }
}

# This is an alternative dir stack management approach.
# . $env:_CommonConfig\PowerShell\dirs.ps1

if ($host.name -eq 'ConsoleHost')
{
    switch($env:COMPUTERNAME)
    {
       "Blargle" { "Blargle" }

        "V-7-32-HXCHBA" {
            # Write-Host "V-7-32-HXCHBA!"
            $procs = get-process | Where-Object { $_.ProcessName -like "PowerShell" };
            # If this is the only instance of PS, start the clock.
            if( $procs -is [System.Diagnostics.Process] ) {
                # . $env:_CommonConfig\PowerShell\ClockWidget3.ps1
            }
        }
    }
         <#
        PS> [enum]::GetValues([System.ConsoleColor])
        Black
        DarkBlue
        DarkGreen
        DarkCyan
        DarkRed
        DarkMagenta
        DarkYellow
        Gray
        DarkGray
        Blue
        Green
        Cyan
        Red
        Magenta
        Yellow
        White
        #>
    # Would like to do this only when PS is contained in TakeCommand, but not sure how to detect that
    #
    $c = [enum]::GetValues([System.ConsoleColor])
    (Get-Host).UI.RawUI.BackgroundColor=$c[0]

}
#
# Loaded from NBA Support location in local profile
# . $env:_CommonConfig\PowerShell\pollTail.ps1
#
. $env:_CommonConfig\PowerShell\ShortenPath.ps1

# Load posh-git example profile
if( $env:COMPUTERNAME -ne "V-7-32-HXCHBA") {
    Write-Host "Loading posh-git"
    . $env:_CommonConfig\posh-git\profile.example.ps1
}
else {
    # Re-enable posh-git for work VM, for now.  Isolating it like this makes it easy to disable.
	Write-Host "Loading posh-git"
	. $env:_CommonConfig\posh-git\profile.example.ps1
}

<#
switch -wildcard ($env:COMPUTERNAME) {
    "V-7-32-HXCHBA" { . $env:_CommonConfig\posh-git\profile.example.ps1 }

    "*" { . $env:_CommonConfig\posh-git\profile.example.ps1  }
}
#>


#
# This has to be last -- it adds to functionality set by others
# (posh-git, for example)
#
# . $env:_CommonConfig\PowerShell\cbPrompt.ps1

# Shared location for modules.
# Put machine-specific modules in:
# TODO:  This should be in machine-specific profile.
#$env:PSModulePath += ";C:\Users\Charles\CommonConfig\PowerShell\Modules"
#$env:PSScriptRoot += ";C:\Users\Charles\CommonConfig\PowerShell\Modules"

#
#  Save/restore command history
#  From: http://blogs.msdn.com/b/powershell/archive/2006/07/01/perserving-command-history-across-sessions.aspx
#
$MaximumHistoryCount = 48
$MaximumDirectoryCount = 16
$PoshHistoryPath = "~\Powershell\_posh_history.xml"
$PoshDirectoryPath = "~\Powershell\_posh_directory.xml"

# Reworked history stuff based on this: http://blog.joonro.net/en/2013/12/20/persistent_history_and_history_search_with_arrow_keys_in_powershell.html
if (!(Test-Path ~\PowerShell -PathType Container))
{
    New-Item ~\PowerShell -ItemType Directory
}

Import-Module $env:_CommonConfig\PowerShell\Modules\CBUtil\CBUtil.psd1


if (Test-path $PoshHistoryPath)
{
    Import-CliXml $PoshHistoryPath | Add-History
}

# if (Test-path $PoshDirectoryPath)
# {
#     $cur = $pwd
#     Write-Host "Importing dirs..."
#     $dirs = Import-CliXml -Path $PoshDirectoryPath;
#     # $dirs
#     foreach($d in $dirs) {
#        Push-Location -Path $d;
#     }
#     Set-Location $cur
# }

function Clear-DirectoryStack {
    param ($stackName = $null)
    $cur = $pwd
    $last = ""
    $p = Pop-Location -StackName $stackName -PassThru
    if ($null -eq $p) {
        return;
    }
    else {
        $last = $p
    }
    $p = Pop-Location -StackName $stackName -PassThru
    while($p.Path -ne $last.Path) {
        $last = $p
        $p = Pop-Location -StackName $stackName -PassThru
        $s = [string]::Format("Last: {0}  Now: {1}", $last, $p)
        $s
    }
    Set-Location $cur
}

function Export-CmdHistory {

    # [System.Windows.Forms.MessageBox]::Show("exportCmdHistory" , "PowerShell Reminder")
    if (Test-Path $PoshHistoryPath) {
        # [System.Windows.Forms.MessageBox]::Show("Found PoshHistoryPath" , "PowerShell Reminder")
        remove-item -Force $PoshHistoryPath
    }
    Write-Host "exporting Cmd history"
    $d = Get-History
    $d = $d | Select-Object -Unique
    $d = $d | Select-Object -Last $MaximumHistoryCount
    $d
    $d | Export-CliXml -Path $PoshHistoryPath
    # Get-History -Count $MaximumHistoryCount | Group CommandLine |
    # Foreach {$_.Group[0]} | Export-CliXml $PoshHistoryPath -Encoding UTF8
}
Set-Alias exportCmdHistory Export-CmdHistory

function Export-DirHistory{
    Write-Host "exporting dir history"
    $d = Get-Location -stack
    $d = $d | Select-Object-Unique
    $d = $d | Select-Object -Last $MaximumDirectoryCount
    $d
    $d | Export-CliXml -Path $PoshDirectoryPath
}
Set-Alias exportDirHistory Export-DirHistory

# Save history on exit
Register-EngineEvent PowerShell.Exiting {
    if ((Test-Path "~\msg.lck") -eq $true) {
        Remove-Item -force "~\msg.lck" -ErrorAction "SilentlyContinue"
        <#
        $p = get-process | where { $_.Name -Like "Powershell" }
        if ($p -ne $null) {
            Write-Host (,$p).Count
            if ((,$p).Count -lt 1) {
                Remove-Item -force "~\msg.lck"
            }
        }
        else {
            Remove-Item -force "~\msg.lck"
        }
        #>
    }
    Export-CmdHistory
    # exportCmdHistory($null)
    Export-DirHistory
    # exportDirHistory($null)


#    Read-Host "Press the Any key..."
} -SupportEvent

# hg function to search history
function hg($arg) {
    Get-History -c $MaximumHistoryCount | out-string -stream | select-string $arg
}

#
# ----------------- New aliases -------------------
#

# Replaced by functionality in dirs.ps1
# use this with popd
new-alias cdd Push-Location; Set-Location

new-alias view Get-Content

# gvimr invokes gvim, using an existing instance if available
new-alias gvr gvimr

#
# dedit invokes VisStudio, using an existing instance if available
#

if ((test-path Env:VS140COMNTOOLS) -eq $true) {

	function dedit {
#		VS2015
#		. "$Env:VS140COMNTOOLS\..\Ide\devenv.exe" /edit $args[0]
#		VS2017
		. "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\IDE\devenv.exe" /edit $args[0]
	}
}

#
# ----------------- New functions -------------------
#
<#
# . $env:_CommonConfig\PowerShell\cdd.ps1
#>


function Copy-Pwd() {
    $pwd.ProviderPath | set-clipboard
}
Set-Alias cpPwd Copy-Pwd


# for git
function psh() {
    Write-Output "Pushing..."
        git push
}


#
# This works.  Allows for adding things like '+34' to the cmd line.
#
function gvimr {
    $arr = $args;
    $s = ". gvim.exe ";
    # $s = [string]::Format("{0}", $env:Editor)
    $running = Get-Process | Where-Object { $_.Name -Like "gvim*" };
    if ([string]::IsNullOrEmpty($running) -eq $false) {
    }

    # Write-Host $s -Foreground Magenta

    if($arr.Count -ge 1) {
        $s += " --remote-silent ";
        for($i=0; $i -lt $arr.count; $i++){
            $a = $arr[$i];
            $s += $a;
            $s += " ";
        }
    }

    $script = [ScriptBlock]::Create($s);
    Invoke-Command -ScriptBlock $script;
}

Set-Alias npp "C:\Program Files\Notepad++\notepad++.exe"
Set-Alias code "C:\Users\cbate\AppData\Local\Programs\Microsoft VS Code"


# This is used by my mods to Posh-git
#   Can be overridden in local profile.  (Do it after this module is loaded!)
$env:PromptLength = 40


# # Load Jump-Location profile
# # Import-Module 'C:\Users\Charles\Documents\WindowsPowerShell\Jump-Location\Jump.Location.psd1'
# # Problems with something in Jump-Location with PowerShell Core 6.
# if ($verMajor -lt 6) {
# 	Import-Module "$env:_CommonConfig\PowerShell\Modules\Jump-Location\Jump.Location.psd1"
# }
# else {
#     Write-Host(" ")
#     Write-Host("Can not load Jump-Location; appears System.Management.Automation.PSSnapIn is not supported in version $verMajor")
# }


# ---------- Functions ------------------------------

# Search recursively
function Find-File { param ($fn = "*")
    Get-ChildItem -Path . -Recurse | Where-Object { $_.Name -Like "*$fn*" }
}
Set-Alias ffind Find-File



# Launch Windows explorer in specified dir, default is PS's current dir
function Start-Explorer{ param ($dir = ".")
    explorer.exe $dir
}
Set-Alias exp Start-Explorer

function getOneCmdrV2Path {
    [bool]$success = $true;
    try {
        $ed = $env:OneCommanderPathV2
        # Is the env var set?
        if ($null -eq $ed) {
            Write-Host "OneCommanderPathV2 environment variable not set.";
            $ed = Read-Host "Enter OneCommanderV2 path (enter to quit)";
            if ([string]::IsNullOrEmpty($ed) -eq $true) {
                # Write-Host "No editor specified." -Foreground Yellow ;
                $success = $false;
            }
            else {
                $env:OneCommanderPathV2 = $ed
                $success = $true
            }
        }
    }
    catch {
        $_
    }
    $success;
}


function Start-OneCommanderV2{ param ($dir = ".")
    $gotOneCmdr = getOneCmdrV2Path;

    if($gotOneCmdr -eq $false) {
        "OneCommanderV2 env var not set."
        return;
    }

    # write-host '$dir: '$dir
    $exe = $env:OneCommanderPathV2;
    $p = resolve-path $dir

    # write-host $p.ProviderPath
    $arg1 = [string]::Format("-{0}{0}{1}{0}{0}", '"', $p.ProviderPath)

    Write-Host $exe $arg1
    & $exe $arg1
}
Set-Alias bc2 Launch-OneCommanderV2

# Seach command history for a fuzzy of $a
function Find-CmdInHistory([string]$a) {
    Get-History | Where-Object { $_.commandLine -like "*$a*" }
}
Set-Alias findCmd Find-CmdInHistory

function Test-ReparsePoint([string]$path) {
    $file = Get-Item $path -Force -ea 0
        return [bool]($file.Attributes -band [IO.FileAttributes]::ReparsePoint)
}

function import-Pscx {
     # PowerShell Community Extensions
	 Write-Host "Importing Pscx  community extensions module..."
     Import-Module Pscx
     $Pscx:Preferences['TextEditor'] = "gvim.exe"
}

# See: viewJunctions.txt
Update-FormatData -PrependPath $env:_CommonConfig\Powershell\myFilesystem.format.ps1xml


##
#
# Apropos - search help Synopsis header for keywords
#
function apropos {
    $descr = Get-Help *
        foreach ($ag in $args) {
            $descr = $descr | Where-Object {$_.Synopsis -like "*${ag}*"}
        }
    $descr | Format-Table -Auto
}

#
# From:  http://www.howtogeek.com/tips/how-to-extract-zip-files-using-powershell/
#
function Expand-ZIPFile($file, $destination)
{
    $shell = new-object -com shell.application
        $zip = $shell.NameSpace($file)
        foreach($item in $zip.items())
        {
            $shell.Namespace($destination).copyhere($item)
        }
}

function pushCurDir {
    $p = Get-Location
    $s = [string]::Format("Pushing {0}", $p.ProviderPath)
    Write-Host $s
    Push-Location $p.ProviderPath
}

#
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
# Remind me about using 'bye'
# [System.Windows.Forms.MessageBox]::Show("Use 'Bye' instead of 'Exit' to save command history." , "PowerShell Reminder")
#
#
function bye {
   Get-History -Count 50 |Export-CSV ~\PowerShell\history.csv
   exit
}

if (Test-path ~\PowerShell\History.csv) {
    Import-CSV ~\PowerShell\History.csv |Add-History
}

<#
#
$f = Get-ChildItem -file "~\msg.lck" -ErrorAction "SilentlyContinue"
if (($f -eq $null) -or ((Test-Path $f -ea SilentlyContinue) -eq $false)) {
    "lck" | out-file "~\msg.lck" -ErrorAction "SilentlyContinue";

    [System.Windows.Forms.MessageBox]::Show([string]::Format("{1}{0}{2}{0}{3}",
            [Environment]::Newline ,
            "PSReadLine",
            "- Up-arrow matches on partially-entered command.",
            "- Ctrl+R is i-search for commands.") , "PSReadLine Reminder")
}
#>
