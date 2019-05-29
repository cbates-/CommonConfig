
$getEventInput = StackPanel -ControlName 'Get-EventLogsSinceDate' {            
        New-Label -VisualStyle 'MediumText' "Log Name"            
        New-ComboBox -IsEditable:$false -SelectedIndex 0 -Name LogName @("Application", "Security", "System", "Setup")            
        New-Label -VisualStyle 'MediumText' "Get Event Logs Since..."            
        Select-Date -Name After            
        New-Button "Get Events" -On_Click {            
            Get-ParentControl |            
                Set-UIValue -passThru |             
                Close-Control            
        }            
    } -show 
    Get-EventLog @getEventInput
