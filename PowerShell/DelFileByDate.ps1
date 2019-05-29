# set Folder Path
    $dump_path = "C:\temp"
    # set min age of files
    $min_days = "-2"
    # get the current date
    $curr_date = Get-Date
    # determine how far back we go based on current date
    $del_date = $curr_date.AddDays($min_days)
    # delete the files
    # Get-ChildItem $dump_path -Recurse | Where-Object { $_.LastWriteTime -lt $del_date -and !$_.PSIsContainer} | Remove-Item -WhatIf
    Get-ChildItem $dump_path | Where-Object { $_.LastWriteTime -lt $del_date -and !$_.PSIsContainer} | Remove-Item -WhatIf
