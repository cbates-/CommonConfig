function FreeSpace {
	gwmi Win32_LogicalDisk -Filter "DeviceID='C:'" | select Name, FileSystem,FreeSpace,BlockSize,Size | % {$_.BlockSize=(($_.FreeSpace)/($_.Size))*100;$_.FreeSpace=($_.FreeSpace/1GB);$_.Size=($_.Size/1GB);$_}| Format-Table Name, @{n='FS';e={$_.FileSystem}},@{n='Free, Gb';e={'{0:N2}'-f
	$_.FreeSpace}}, @{n='Free,%';e={'{0:N2}'-f $_.BlockSize}} -AutoSize
}
