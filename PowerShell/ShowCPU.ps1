Import-Module ShowUI

New-Grid -Name ShowCPU -ControlName Show-CPU -DataContext {            
    Get-PowerShellDataSource -Script {             
        Get-Counter '\Processor(_total)\% Processor Time' -Continuous            
    }            
}  {            
    New-Grid -DataBinding @{            
        DataContext = New-Binding -Path LastOutput -NotifyOnSourceUpdated -Mode OneWay -UpdateSourceTrigger PropertyChanged            
    } -On_DataContextChanged {            
        $percentage = $this.DataContext.CounterSamples[0].CookedValue            
            if ($percentage) {            
                $cpuLabel.Content = "$([Math]::Round($percentage, 2)) %"            
                    $lastUpdatedLabel.Content = $this.DataContext.Timestamp.ToLongTimeString()                    
                    if ($percentage -le 50) {            
                        $performanceColorCode.Fill = 'DarkGreen'            
                            $cpuLabel.Foreground = 'AliceBlue'            
                            $LastUpdatedLabel.Foreground = 'AliceBlue'            
                    } elseif ($percentage -le 75) {            
                        $performanceColorCode.Fill = 'Orange'            
                            $cpuLabel.Foreground = 'Black'            
                            $LastUpdatedLabel.Foreground = 'Black'            
                    } else {            
                        $performanceColorCode.Fill = 'Red'            
                            $cpuLabel.Foreground = 'Black'            
                            $LastUpdatedLabel.Foreground = 'Black'                            
                    }            
            }               

    } -rows 3 -columns 3 -Name InnerGrid  {                
        $CenterControl = @{HorizontalAlignment='Center';VerticalAlignment='Center'}            
        $bottomRightControl =@{HorizontalAlignment='Right';VerticalAlignment='Bottom'}            
        New-Rectangle -RowSpan 3 -ColumnSpan 3 -Name PerformanceColorCode            
            New-Label -Row 1 -ColumnSpan 3 @CenteredControl -Name CPULabel -VisualStyle LargeText             
            New-Label -Column 2 -Row 2 @bottomRightControl -Name LastUpdatedLabel -VisualStyle SmallText -DataBinding @{            
                'Content' = New-Binding -Path Timestamp                   
            }            
    }            
} -show       
