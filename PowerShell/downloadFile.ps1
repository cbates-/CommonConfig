
try {
    $url = 'http://www.rugby-coach.com/downloads/TRQ/RugbyCoachW409V.pdf'
    $object = New-Object Net.WebClient
    $localPath = '~\RugbyCoachW409V.pdf'
    $object.DownloadFile($url, $localPath)
    explorer.exe '/SELECT,$localPath'
    Invoke-Item -Path $localPath 
}
catch {
    $_
    $error[0]
}


