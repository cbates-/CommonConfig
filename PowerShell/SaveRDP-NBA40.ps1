
# From: http://irisclasson.com/2015/12/03/saving-rdp-sessions-with-posh/

# $target = "111.111.11.11"
$target = "10.12.8.59"    #NBA40
$target = "NLGPHQVNBA40"

$user = "nbaprc40"
$computerNameOrDomain = "corp"
$pwd = '8uc(vCopmdCC'
 
$logon = "$computerNameOrDomain\$user"
 
cmdkey /generic:$target /user:$logon /pass:$pwd
 
cmdkey /list
 
mstsc /v:$target


 
[Environment]::SetEnvironmentVariable("nba40", "mstsc /v:$target",  "User")
#Restart after this

return;
 
# Run RDP session:
iex (gc Env:nba40)