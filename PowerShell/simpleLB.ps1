 $temp = Get-Location -Stack
 $temp = $temp | Select -Unique
 $temp
 New-StackPanel -ControlName 'Dir HIstory' -Width 300 -Height 400 { 
        New-ListBox -ControlName 'LB' -SelectedIndex 0 -ItemsSource { ,$temp }
 } -show