# https://github.com/gngrninja/PSFolderSize

"{0} MB" -f ((Get-ChildItem "C:\Virtual Machines\" -Recurse | Measure-Object -Property Length -Sum -ErrorAction Stop).Sum / 1MB)
