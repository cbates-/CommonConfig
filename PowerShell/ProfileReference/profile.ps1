
Write-Host "Reading  H:\WindowsPowerShell\profile.ps1";

if((($env:PSModulePath | Select-String "SkyDrive\\PowerShell\\Modules") -eq $null) -and 
    (($env:PSModulePath | Select-String "OneDrive\\PowerShell\\Modules") -eq $nul) ) {
    $env:PSModulePath += ";$env:_skydrive\PowerShell\Modules"
}



switch ($host.Name) {
    'ConsoleHost' 
    { 
        # Write-Host "env:_skdrive: $env:_skydrive"
        Import-Module PSReadline;
        # . $env:_skydrive\PowerShell\Microsoft.PowerShell_profile.ps1       
        . $env:_skydrive\PowerShell\cbprofile.ps1       
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
$env:OneCommanderPath = "C:\bin\OneCommander\OneCommander.exe";



