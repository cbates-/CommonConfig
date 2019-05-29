

$deleteTime = -12;
$limit = (Get-Date).AddDays($deleteTime)

$t = Get-ChildItem -Path $pwd -filter "p*.txt" | Where-Object {$_.LastWriteTime -lt $limit} | Select -Expand Name
$t

foreach ($a in $t) { Write-Host "Name : $a" }

for($i=$t.GetLowerBound(0); $i -le $t.GetUpperBound(0); $i+=2) {

   $s = $t[$i]
   Write-Host "removing $s"  #this is listing the entire array with a [0] for first one and the third [2] element also, whether I cast to an array or not

}