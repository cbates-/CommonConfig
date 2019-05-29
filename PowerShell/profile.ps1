
$fullPathIncFileName = $MyInvocation.MyCommand.Definition
Write-Host "Reading $fullPathIncFileName" -Foreground Cyan

<#
if((($env:PSModulePath | Select-String "SkyDrive\\PowerShell\\Modules") -eq $null) -and 
    (($env:PSModulePath | Select-String "OneDrive\\PowerShell\\Modules") -eq $nul) ) {
    $env:PSModulePath += ";$env:_skydrive\PowerShell\Modules"
}

Write-Host "Reading c:\Users\hxchba\OneDrive\PowerShell\profile.ps1"

switch ($host.Name) {
    'ConsoleHost' 
    { 
        Import-Module PSReadline;
        . $env:_skydrive\PowerShell\Microsoft.PowerShell_profile.ps1       
    }
    'Windows PowerShell ISE Host' 
    { 
        Import-Module FunctionExplorer 
        # Import-Module VariableExplorer 
        . $env:_skydrive\PowerShell\Microsoft.PowerShellISE_profile.ps1       
    }
}


$env:Editor="C:\Program Files\Vim\vim81\gvim.exe"
$env:EdParam="--remote-silent"
$env:CompareTool="C:\Program Files\Devart\Code Compare\codecompare.exe"
# $env:CompareTool="C:\Program Files\Araxis\Araxis Merge\Compare.exe"

#>
