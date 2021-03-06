

# http://lifeofageekadmin.com/map-network-drive-encrypted-password-powershell/

# $cred2 = Get-Credential
# $cred2.Password | ConvertFrom-SecureString | Set-Content c:\temp\password.txt
# $encrypted = Get-Content c:\temp\password.txt | ConvertTo-SecureString
# $cred2 = New-Object System.Management.Automation.PsCredential("DOMAIN\username", $encrypted)
# New-PSDrive -name "G" -PSProvider FileSystem -Root \\SERVER\share -Persist -Credential $cred2

$pathToTest = "L:\"
$pathToMap = "L"

# ........................................
if ($false -eq (Test-Path -Path $pathToTest)) {
    # $encrypted = Get-Content C:\users\Charles.Bates\pwd.txt | ConvertTo-SecureString
    # $cred2 = New-Object System.Management.Automation.PSCredential("wcs@lmp.local", $encrypted)

    $cred2 = Get-Credential

    New-PSDrive -Name $pathToMap -PSProvider FileSystem -Root \\LMPData01.lmp.local\LMP_DEV_Share -Credential $cred2 -Persist
}
else {
    Write-Host "$pathToMap is already mapped."
}
