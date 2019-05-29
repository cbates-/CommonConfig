<#
    .SYSNOPSIS
        Displays a clock on the screen with date.

    .DESCRIPTION
        Displays a clock on the screen with date.

    .PARAMETER TimeColor
        Specify the color of the time display.

    .PARAMETER DateColor
        Specify the color of the date display.

        Default is White

    .NOTES
        Author: Boe Prox
        Created: 27 March 2014
        Version History:
            Version 1.0 -- 27 March 2014
                -Initial build

			CB -- 30 May 2014
				- Reduced size of most components to create clockWidgetSmall.ps1
    .EXAMPLE
        .\ClockWidgetSmallSmall.ps1

        Description
        -----------
        Clock is displayed on screen

    .EXAMPLE
        .\ClockWidgetSmallSmall.ps1 -TimeColor DarkRed -DateColor Gold

        Description
        -----------
        Clock is displayed on screen with alternate colors

    .EXAMPLE
        .\ClockWidgetSmallSmall.ps1 –TimeColor "#669999" –DateColor "#334C4C"

        Description
        -----------
        Clock is displayed on screen with alternate colors as hex values

#>

# Last Modified:  2015 Jan 07 9:25:53 AM
#
Param (
    [parameter()]
    [string]$TimeColor = "White",
    [parameter()]
    [string]$DateColor = "White"
)
$Clockhash = [hashtable]::Synchronized(@{})
$Runspacehash = [hashtable]::Synchronized(@{})
$Runspacehash.host = $Host
$Clockhash.TimeColor = $TimeColor
$Clockhash.DateColor = $DateColor
$Runspacehash.runspace = [RunspaceFactory]::CreateRunspace()
$Runspacehash.runspace.ApartmentState = "STA"
$Runspacehash.runspace.ThreadOptions = "ReuseThread"
$Runspacehash.runspace.Open()
$Runspacehash.psCmd = {Add-Type -AssemblyName PresentationCore,PresentationFramework,WindowsBase}.GetPowerShell()
$Runspacehash.runspace.SessionStateProxy.SetVariable("Clockhash",$Clockhash)
$Runspacehash.runspace.SessionStateProxy.SetVariable("Runspacehash",$Runspacehash)
$Runspacehash.runspace.SessionStateProxy.SetVariable("TimeColor",$TimeColor)
$Runspacehash.runspace.SessionStateProxy.SetVariable("DateColor",$DateColor)
$Runspacehash.psCmd.Runspace = $Runspacehash.runspace
$Runspacehash.Handle = $Runspacehash.psCmd.AddScript({

 $Script:Update = {
    $abbrev = Get-Date -f "dddd"
    $abbrev = $abbrev.Substring(0,3)
    $day,$Month, $Day_n, $Year, $Time, $AMPM = (Get-Date -f "dddd,MMMM,dd,yyyy,hh:mm,tt") -Split ','
	$day = $abbrev

    $Clockhash.time_txtbox.text = $Time.TrimStart("0")
    $Clockhash.day_txtbx.Text = $day
    $Clockhash.ampm_txtbx.text = $AMPM
    $Clockhash.day_n_txtbx.text = $Day_n
    $Clockhash.month_txtbx.text = $Month
    $Clockhash.year_txtbx.text = $year
}

[xml]$xaml = @"
<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        WindowStyle="None" WindowStartupLocation="CenterScreen" SizeToContent="WidthAndHeight" ShowInTaskbar="False"
        ResizeMode="NoResize" Title="Clock" AllowsTransparency="True" Background="Transparent" Opacity="1" Topmost="True">
    <Grid x:Name="Grid" Background="Transparent">
        <TextBlock x:Name="time_txtbox" FontSize="24" Foreground="$($Clockhash.TimeColor)" VerticalAlignment="Top"
            HorizontalAlignment="Left" Margin="8,-8,0,0">
                <TextBlock.Effect>
                    <DropShadowEffect Color="DarkGray" ShadowDepth="1" BlurRadius="5" />
                </TextBlock.Effect>
        </TextBlock>
        <TextBlock x:Name="ampm_txtbx" FontSize="12" Foreground="$($Clockhash.TimeColor)" Margin ="-68, 60,0,0"
        >
                <TextBlock.Effect>
                    <DropShadowEffect Color="Black" ShadowDepth="1" BlurRadius="2" />
                </TextBlock.Effect>
        </TextBlock>
        <TextBlock x:Name="day_n_txtbx" FontSize="18" Foreground="$($Clockhash.DateColor)" Margin="5,37,0,0"
        HorizontalAlignment="Left">
                <TextBlock.Effect>
                    <DropShadowEffect Color="Black" ShadowDepth="1" BlurRadius="2" />
                </TextBlock.Effect>
        </TextBlock>
        <TextBlock x:Name="month_txtbx" FontSize=  "14" Foreground="$($Clockhash.DateColor)" Margin="43,27,0,0"
        HorizontalAlignment="Left">
                <TextBlock.Effect>
                    <DropShadowEffect Color="Black" ShadowDepth="1" BlurRadius="2" />
                </TextBlock.Effect>
        </TextBlock>
        <TextBlock x:Name="day_txtbx" FontSize=  "14" Foreground="$($Clockhash.DateColor)" Margin="43,47,0,0"
        HorizontalAlignment="Left">
                <TextBlock.Effect>
                    <DropShadowEffect Color="Black" ShadowDepth="1" BlurRadius="2" />
                </TextBlock.Effect>
        </TextBlock>
        <TextBlock x:Name="year_txtbx" FontSize=  "14" Foreground="$($Clockhash.DateColor)" Margin="0,37,0,0"
        HorizontalAlignment="Left">
                <TextBlock.Effect>
                    <DropShadowEffect Color="Black" ShadowDepth="1" BlurRadius="2" />
                </TextBlock.Effect>
        </TextBlock>
    </Grid>
</Window>
"@

$reader=(New-Object System.Xml.XmlNodeReader $xaml)
$Clockhash.Window=[Windows.Markup.XamlReader]::Load( $reader )

$Clockhash.time_txtbox = $Clockhash.window.FindName("time_txtbox")
$Clockhash.ampm_txtbx = $Clockhash.Window.FindName("ampm_txtbx")
$Clockhash.day_n_txtbx = $Clockhash.Window.FindName("day_n_txtbx")
$Clockhash.month_txtbx = $Clockhash.Window.FindName("month_txtbx")
$Clockhash.year_txtbx = $Clockhash.Window.FindName("year_txtbx")
$Clockhash.day_txtbx = $Clockhash.Window.FindName("day_txtbx")

#Timer Event
$Clockhash.Window.Add_SourceInitialized({
    #Create Timer object
    Write-Verbose "Creating timer object"
    $Script:timer = new-object System.Windows.Threading.DispatcherTimer
    #Fire off every 1 minutes
    Write-Verbose "Adding 1 minute interval to timer object"
    $timer.Interval = [TimeSpan]"0:0:1.00"
    #Add event per tick
    Write-Verbose "Adding Tick Event to timer object"
    $timer.Add_Tick({
    $Update.Invoke()
    [Windows.Input.InputEventHandler]{ $Clockhash.Window.UpdateLayout() }

})
    #Start timer
    Write-Verbose "Starting Timer"
    $timer.Start()
    If (-NOT $timer.IsEnabled) {
        $Clockhash.Window.Close()
    }
})

$Clockhash.Window.Add_Closed({
    $timer.Stop()
    $Runspacehash.PowerShell.Dispose()

    [gc]::Collect()
    [gc]::WaitForPendingFinalizers()
})
$Clockhash.month_txtbx.Add_SizeChanged({
    [int]$clockhash.length = [math]::Round(($Clockhash.day_txtbx.ActualWidth,$Clockhash.month_txtbx.ActualWidth |
        Sort -Descending)[0])
    # [int]$Adjustment = $clockhash.length + 52 + 4 #Hard coded margin plus white space
    [int]$Adjustment = $clockhash.length + 48 + 4 #Hard coded margin plus white space

    $YearMargin = $Clockhash.year_txtbx.Margin
    $Clockhash.year_txtbx.Margin = ("{0},{1},{2},{3}" -f ($Adjustment),
        $YearMargin.Top,$YearMargin.Right,$YearMargin.Bottom)

})
$Clockhash.time_txtbox.Add_SizeChanged({
    If ($Clockhash.time_txtbox.text.length -eq 4) {
        $Clockhash.ampm_txtbx.Margin  = "58,1,86,0"
    } Else {
        $Clockhash.ampm_txtbx.Margin  = "83,1,48,0"
    }
})
$Clockhash.Window.Add_MouseRightButtonUp({
    $This.close()
})
$Clockhash.Window.Add_MouseLeftButtonDown({
    $This.DragMove()
})
$Update.Invoke()
$Clockhash.Window.ShowDialog() | Out-Null
}).BeginInvoke()

