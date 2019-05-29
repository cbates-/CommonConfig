#
# From http://stackoverflow.com/questions/24038472/how-to-check-drive-is-it-virtual-powershell
#
$substdrives = @{};
(subst) |% { $part = $_ -split '\\: => '; $substdrives[$part[0]] = $part[1] } ;
$substdrives | ft
