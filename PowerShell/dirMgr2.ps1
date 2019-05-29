
# DirHistory using WPF via ShowUI
#

# Import-Module ShowUI -ErrorAction silentlycontinue

<#   
.SYNOPSIS   
	Show list from Get-History 
    
.DESCRIPTION 
	Provide GUI to select a previously-visited dir.
    This uses the ShowUI module to provide WPF functionality.
    Hote that the list can be scrolled with vim keys: h, j, k, l.
    Enter or double-clicking to select a directory; Esc to exit.
	

.NOTES   
    Module Name: DirMgr2
    Author: Charles Bates
    DateUpdated: 2013-03-07
    Version: 1.0
    
#>

function Get-DirHistory() {

    $temp = Get-Location -Stack
    $temp = $temp | Select -Unique
    $temp = $temp | Select -First 24

    if($temp -eq $null) {
        Write-host "No dir history." -Foreground Yellow
        return;
    }
    $cleaned = @()
    foreach($i in $temp) {
        $cleaned += $i.ProviderPath
    }

#New-Window -WindowStyle ToolWindow -Width 300 -Height 200 -MaxHeight 400  {
    New-StackPanel -ControlName 'DirHIstory' -Name 'DirHist' -Width 400 -MaxHeight 420 -On_Loaded {
            $DirHist.Focus()
        }  { 
            New-ListBox -Name 'LB' -SelectedIndex 0 -ItemsSource { ,$cleaned } -On_Loaded {
                        # Answer for how to get to the scrollviewer came from here:
                        # https://showui.codeplex.com/discussions/532815
                        # root node
                        $Border = [System.Windows.Media.VisualTreeHelper]::GetChild($this, 0)
                        if($Border -eq $null) {
                            Write-Error "Border is null"
                            Write-Host "Border is null"
                        }
                        $ScrollViewer = [System.Windows.Media.VisualTreeHelper]::GetChild($Border, 0)
                        if($ScrollViewer -eq $null) {
                            Write-Error "ScrollViewer is null"
                            Write-Host "ScrollViewer is null"
                        }

                        $this | Add-Member -MemberType NoteProperty SV $ScrollViewer 

                        $LB.Focus()
                    } -On_KeyUp {
                        if($_.Key -eq "Enter") { 
                            Set-Location -Path $LB.SelectedItem;
                            Get-ParentControl | Close-Control 
                        }
                        if($_.Key -eq "Escape") { 
                            Get-ParentControl | Close-Control 
                        }
                    } -On_KeyDown {
                        if($_.Key -eq "j") { 
                            $LB.SelectedIndex += 1
                        }
                        if($_.Key -eq "k") { 
                            $c = $LB.SelectedIndex
                            if ($c -gt 0) {
                                $LB.SelectedIndex -= 1
                            }
                        }
                        if($_.Key -eq "l") { 
                            # scroll, pushing text to left
                            if($this.SV -eq $null) {
                                Write-Error "this.SV is null"
                            }
                            else {
                                $this.SV.LineRight()
                            }
                        }
                        if($_.Key -eq "h") { 
                            # scroll, pushing text to right
                            if($this.SV -eq $null) {
                                Write-Error "this.SV is null"
                            }
                            else {
                                $this.SV.LineLeft()
                            }
                        }
                    } -On_MouseDoubleClick {
                        $sel = $LB.SelectedItem
                        Push-Location
                        Set-Location -Path $sel
                        Close-Control
                    }
            
            New-Button "Select" -On_Click { 
                # Write-Host "CLICKED"
                $zz = [string]::Format("Selected item: {0}", $LB.SelectedItem)
                Write-Host $zz
                $sel = $LB.SelectedItem
                Push-Location
                Set-Location -Path $sel
                Close-Control
            } 
#   }  # for the Window
    } -show
}
Set-Alias dh Get-DirHistory
