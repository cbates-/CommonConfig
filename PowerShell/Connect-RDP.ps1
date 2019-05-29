<#   
.SYNOPSIS   
	Function to connect an RDP session without the password prompt
    
.DESCRIPTION 
	This function provides the functionality to start an RDP session without having to type in the password.
	
.PARAMETER ComputerName
    This is a single computername

.PARAMETER User
    The user name that will be used to authenticate

.PARAMETER Password
    The user name that will be used to authenticate

.NOTES   
    Name: Connect-RDP


.EXAMPLE   
	. .\Connect-RDP.ps1
    
Description 
-----------     
This command dot sources the script to ensure the Connect-RDP function is available in your current PowerShell session

.EXAMPLE   
	Connect-RDP -ComputerName server01 -User contoso\jaapbrasser -Password supersecretpw

Description 
-----------     
A remote desktop session to server01 will be created using the credentials of contoso\jaapbrasser.
A semaphore file named "server01.jaapbrasser" will be created.  It will be removed in the Action block created for the Exited evetnt handler.

#>

# This module is derived from Connect-Mstsc.ps1.
# It only accepts one computer name to connect to.
#
# 20140307 C. Bates
#       Added a semaphore file to try to prevent a user connecting to a server
#       with another user already connected.
#       This function writes a temporary .ps1 file that connects a Process.Exited 
#       event handler to the Process created in this function.
#       The Action block in the event handler deletes the semaphore file, 
#       and deletes the temp script file.
#       Of course, this only works when everyone uses this module to connect...
#

$lockFileName = ""
$varName = ""

function Connect-RDP {
    param (
        [Parameter(Mandatory=$true,Position=0)]
        [Alias("CN")]
            [string]$ComputerName,
        [Parameter(Mandatory=$true,Position=1)]
        [Alias("U")] 
            [string]$User,
        [Parameter(Mandatory=$true,Position=2)]
        [Alias("P")] 
            [string]$Password
    )

    process {
        $rdpPath = "\\corp\hdq\data2\Keane CMM\2 WPDB\2.03 Application Material\NBA_NB_2014\Support\PowerShell\Modules\NBA.Support.RDP"
        $localUser = $env:USERNAME;
        $varName = [string]::Format("{0}.{1}", $ComputerName, $localUser);
        $lockFileName = [string]::Format("{0}\{1}", $rdpPath, $varName);

        $pattern = [string]::Format("{0}\{1}*", $rdpPath, $ComputerName);
        $cc = Get-ChildItem $pattern


        # Check to see if there are any semaphore/lock files for this computer
        #
        if ($cc -ne $null) {
            foreach  ($a in $cc) {
                $parts = $a.Name.Split(".");
                $msg = [string]::Format("{0} in use by {1}", $parts[0], $parts[1]);
                $msg;
                return ;
            }
        }

        $tempFile = [io.path]::GetTempFileName() 
        # get what will be the module name from the temp filename
        $fields = $tempFile.Split("\")
        $parts = $fields[$fields.Length - 1].Split(".")
        # This is used in call to Remove-Module
        $tempModule = [string]::Format("{0}.{1}", $parts[0], $parts[1])
        # Add exetension so PowerShell won't mind executing it
        $tempFile += ".ps1"
        # ----  Diagnostics
        # $tempFile
        # $tempModule
        # -----------------
        $eventName = [string]::Format("{0}.{1}", $ComputerName, $env:USERNAME)
        $msgBoxMsg = [string]::Format("{0} disconnected", $ComputerName)

        $ProcessInfo = New-Object System.Diagnostics.ProcessStartInfo
        $Process = New-Object System.Diagnostics.Process

        $ProcessInfo.FileName = "$($env:SystemRoot)\system32\cmdkey.exe"
        $ProcessInfo.Arguments = "/generic:TERMSRV/$ComputerName /user:$User /pass:$Password"
        $Process.StartInfo = $ProcessInfo
        $Process.Start()

        $ProcessInfo.FileName = "$($env:SystemRoot)\system32\mstsc.exe"
        $ProcessInfo.Arguments = "/v $ComputerName"
        $Process.StartInfo = $ProcessInfo
        $Process.EnableRaisingEvents = $true
        Unregister-Event -SourceIdentifier $eventName -ErrorAction SilentlyContinue

        # COULD THIS BE DONE WITH A SCRIPT BLOCK AND THE EXECUTE OPERATOR ('&') ??
        # -------- Write the temp file to exevute
        $s = 'function runProcZed { '
        $s += "`n"
        $s += 'param ( [Parameter(Mandatory=$true,Position=0)] [Alias("PN")] [System.Diagnostics.Process]$Proc)'
        $s += "`n"
        $s += ' $ExitAction = {'
        $s += "`n"
        $s += "[System.Windows.Forms.MessageBox]::Show("; $s += '"'; $s += "$msgBoxMsg" ; $s += '")'
        $s += "`n"
        $s += "Remove-Item -Force -Path "; $s += '"'; $s += "$lockFileName"; $s += '"';
        $s += "`n"
        $s += "Remove-Item -Force -Path "; $s += '"'; $s += "$tempFile"; $s += '"';
        $s += "`n"
        $s += "}"
        $s += "`n"

        $s += 'Register-ObjectEvent -InputObject $Proc -SourceIdentifier '; $s += "$eventName -EventName Exited -Action "; $s += '$ExitAction'
        $s += "`n"
        $s += '$Proc.Start()'
        $s += "`n"
        $s += '$id = [string]::Format("{0}", $Process.ID)'
        $s += "`n"
        $s += '$id | Out-File -Force -FilePath '; $s += "'"; $s += "$lockFileName"; $s += "'"
        $s += "`n"
        $s += "}"
        $s += "`n"

        $s | Out-File  $tempFile

        # ------------ end writing


        # ------------ Import, Execute, Remove

        Import-Module $tempFile
        . runProcZed -Proc $Process
        Remove-Module $tempModule

    }
}

function RDP-InUse {
<#
$fs = Get-ChildItem nlg*
$fs
foreach ($f in $fs) {
$parts = $f.Name.Split(".")
$s = [string]::Format("{0} in use by {1}", $parts[0], $parts[1])
$s
}
#>
}
