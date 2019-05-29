$h = @{A=666;B="zing";C=3.1615}
$h
foreach ($entry in $h) { 
    $k = $entry.Keys
    $v = $entry.Values
    write-host "$k : $v" 
}
$h.Count

$cntr = 0
foreach ($entry in $h) { 
    write-host $cntr
    $cntr++
    write-host $entry.Keys
}

foreach ($e in $h.GetEnumerator()) {
    Write-Host "$($e.Name): $($e.Value)"
}

$hh = @{ 
   "key1" = @{
       "Entry 1" = "one"
       "Entry 2" = "two"
   }
   "key 2" = @{
       "Entry 1" = "three"
       "Entry 2" = "four"
   }
}

$hh.GetEnumerator() | % {         
    Write-Host "Current hashtable is: $($_.key)"
    Write-Host "Value of Entry 1 is: $($_.value["Entry 1"])" 
}

