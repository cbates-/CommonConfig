
function flangle {
$Username = "nbaprc31"
$Password = "iQ^I7G*oRN2G"
$ComputerName = "nlgtptvnba31"
$Script = {start-process "\\corp\hdq\nba\nba_uat\ServerApplications\NBARequester\NBARequester.exe" }

#Create credential object
$SecurePassWord = ConvertTo-SecureString -AsPlainText $Password -Force
$Cred = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $Username, $SecurePassWord

#Create session object with this
$Session = New-PSSession -ComputerName $ComputerName -credential $Cred

#Invoke-Command
$Job = Invoke-Command -Session $Session -Scriptblock $Script -AsJob
$Null = Wait-Job -Job $Job

#Close Session
Remove-PSSession -Session $Session
}


$Username = "nbaprc31"
$Password = "iQ^I7G*oRN2G"
$ComputerName = "nlgtptvnba31"
$SecurePassWord = ConvertTo-SecureString -AsPlainText $Password -Force
$Cred = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $Username, $SecurePassWord

$FullExecutable = "Y:\NBARequester\NBARequester.exe"
Invoke-WmiMethod -ComputerName "NLGTPTNBA31" -Credential $cred -Class win32_process -name create -ArgumentList $FullExecutable