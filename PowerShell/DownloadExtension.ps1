# From http://www.thewindowsclub.com/download-file-using-windows-powershell
$client = new-object System.Net.WebClient

# Dictionary of things to download.
# Key is name of file to save to
# Value is URI
$dict = @{}
$dict.Add('VsVim.vsix','https://marketplace.visualstudio.com/items?itemName=JaredParMSFT.VsVim')
$dict.Add('SuperCharger.vsix','https://marketplace.visualstudio.com/items?itemName=MichaelKissBG8.Supercharger')
$dict.Add('RelativeNumber.vsix','https://marketplace.visualstudio.com/items?itemName=BrianSchmitt.RelativeNumber')
$dict.Add('TrailingWhitespaceVisualizer.vsix','https://marketplace.visualstudio.com/items?itemName=MadsKristensen.TrailingWhitespaceVisualizer')
$dict.Add('VSColorOutput.vsix','https://marketplace.visualstudio.com/items?itemName=MikeWard-AnnArbor.VSColorOutput')



# Target dir
# $env:_CommonConfig\Downloads


if((Test-Path "$env:_CommonConfig\Downloads") -eq $false) {
	mkdir "$env:_CommonConfig\Downloads"
}


$dict.Keys | % { "key = $_ , value = " + $dict.Item($_) }

# $client.DownloadFile("http://thewindowsclub.thewindowsclub.netdna-cdn.com/wp-content/upload/2016/Windows-Explorer-Process-Task-Manager-600x405.png",
# "C:\Users\Digdarshan\Pictures\TWC\Task-Manager.png")


