
$interval = -30;
$now = [datetime]::Now
$tenMinEarlier = $now.AddMinutes($interval);

$files = gci * |? { ($_.CreationTime.Date -eq [datetime]::Today.Date) } `
    | where { ($_.CreationTime.Hour -eq [datetime]::Now.Hour) } `
    | where { $_.CreationTime.Minute -gt  $tenMinEarlier.Minute } `
    | sort LastWriteTime -Descending

$interval
# $files.Count
$files
