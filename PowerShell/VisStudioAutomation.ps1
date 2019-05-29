# From: 
# https://stackoverflow.com/questions/21055444/visualstudio-dte-solution-is-null-using-activatorcreateinstance/24157816#24157816
#
$dteObj = New-Object -ComObject "VisualStudio.DTE.12.0"
$scriptDirectory = "C:\Test"
# $dteObj = [System.Activator]::CreateInstance([System.Type]::GetTypeFromProgId("VisualStudio.DTE.10.0"))
$slnName = "All"
$dteObj.Solution.Create($scriptDirectory, $slnName)
