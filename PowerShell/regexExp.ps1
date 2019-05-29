
    $t = (get-date).TimeOfDay | select Hours, Minutes, Seconds
    $regex = "\b\d{1,2}\.\d{1,2}\.\d{1,2}\b"
    # $time = (Get-Date).ToLongTimeString()
    # $time = $time -split { $_ -eq " " -or $_ -eq ":" }
    $s = [string]::Format("{0}.{1}.{2}", $t.Hours, $t.Minutes, $t.Seconds )
    $s
    $s -match $regex
    $s = "111.3.4"
    $s
    $s -match $regex
    $s = "111.a.4"
    $s
    $s -match $regex
    $s = "1.1.1"
    $s
    $s -match $regex
    $s = "1.1.1000"
    $s
    $s -match $regex
    
    $regex2 = "\b\d{1,2}\.\d{1,2}\.\d{1,2}\b"
    $s = "1.1.1000"
    $s
    $s -match $regex2
    
    $regex3 = "\b\d{1,2}\.\d{1,2}\.\d{1,2}\b"
    $s = "1000.1.10"
    $s
    $s -match $regex3
    