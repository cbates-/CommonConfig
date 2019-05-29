$path = "C:\temp\mylogfile.log"

$init = "C:\temp\mylogfileInit.txt"

[int]$numberLines = 25

if(Test-path $init)

 {$initLine = Get-Content $init}

Else {$initline = 0} 

For ([int]$i=$initline;$i -le ($numberLines + $initLine);$i++)

{

 $SampleString = "Added sample {0} at {1}" -f $i,(Get-Date).ToString("h:m:s")

 add-content -Path $path -Value $SampleString -Force

 Start-Sleep -Milliseconds 1000

 }

$i | Out-File -FilePath $init -Force
