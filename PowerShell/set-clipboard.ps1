# From: http://stackoverflow.com/questions/1567112/convert-keith-hills-powershell-get-clipboard-and-set-clipboard-to-a-psm1-script

function Set-ClipBoard {
    Param(
      [Parameter(ValueFromPipeline=$true)]
      [string] $text
    )
    Add-Type -AssemblyName System.Windows.Forms
    $tb = New-Object System.Windows.Forms.TextBox
    $tb.Multiline = $true
    $tb.Text = $text
    $tb.SelectAll()
    $tb.Copy()
}
