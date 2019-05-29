
#
# From:  http://blogs.technet.com/b/heyscriptingguy/archive/2014/04/06/powertip-use-powershell-to-display-known-colors.aspx
#

Add-Type –assemblyName PresentationFramework

[windows.media.colors] | Get-Member -static -Type Property |

Select -Expand Name| ForEach {

    [pscustomobject] @{

        ARGB = "$([windows.media.colors]::$_)"

        Color = $_

    }

}
