


#
# Directory History
#
function dh1() {
    $temp = Get-Location -Stack
    $temp = $temp | Select -Unique

    if(([string]$temp).Length -lt 1) {
        return
    }
    $truncd = @()

    foreach($i in $temp) {
        $truncd += $i.ProviderPath
    }

    # $selected = selectFromListBox ( $temp )
    # Ugly syntax.  
    $selected = selectFromListBox -arr: $truncd -title:"Select a dir"

    if(([string]$selected).Length -gt 2) {
        pushd;
        Set-Location $selected
    }
}


# From: http://technet.microsoft.com/en-us/library/ff730949.aspx

function selectFromListBox {
    param( [string[]] $arr, [string] $Title = "Select")

    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 

    $selection=""

    $objForm = New-Object System.Windows.Forms.Form 
    # $objForm.Text = "Select "
    $objForm.Text = $Title
    $objForm.Size = New-Object System.Drawing.Size(360,200) 
    $objForm.StartPosition = "CenterScreen"
    # $objForm.AutoSize = $true
    # $objForm.AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink

    $objForm.KeyPreview = $True
    $objForm.Add_KeyDown(
        {
            if ($_.KeyCode -eq "Enter") {
                $selection=$objListBox.SelectedItem;
                $objForm.Close()
#                Write-Host [string]::Format("Selection: {0}", $selection )
            }
        }
    )

    $objForm.Add_KeyDown({if ($_.KeyCode -eq "Escape") 
            {$objForm.Close()}})

    $OKButton = New-Object System.Windows.Forms.Button

    $OKButton.Location = New-Object System.Drawing.Size(75,120)
    $OKButton.Size = New-Object System.Drawing.Size(75,23)
    $OKButton.Text = "OK"
    $OKButton.Add_Click({$selection=$objListBox.SelectedItem;$objForm.Close()})
    # $OKButton.Dock = [System.Windows.Forms.DockStyle]::Bottom
    $objForm.Controls.Add($OKButton)

    $CancelButton = New-Object System.Windows.Forms.Button
    $CancelButton.Location = New-Object System.Drawing.Size(150,120)
    $CancelButton.Size = New-Object System.Drawing.Size(75,23)
    $CancelButton.Text = "Cancel"
    $CancelButton.Add_Click({$objForm.Close()})
    # $CancelButton.Dock = [System.Windows.Forms.DockStyle]::Bottom
    $objForm.Controls.Add($CancelButton)

#    $objLabel = New-Object System.Windows.Forms.Label
#    $objLabel.Location = New-Object System.Drawing.Size(10,20) 
#    $objLabel.Size = New-Object System.Drawing.Size(280,20) 
#    $objLabel.Text = $title
#    $objForm.Controls.Add($objLabel) 

    $objListBox = New-Object System.Windows.Forms.ListBox 
    $objListBox.Location = New-Object System.Drawing.Size(10,40) 
    $objListBox.Size = New-Object System.Drawing.Size(340,20) 
    $objListBox.Height = 80
    $objListBox.Add_GotFocus({$objListBox.SelectedIndex = 0})
    $objListBox.HorizontalScrollBar = $true
    # $objListBox.AutoSize= $true
    # $objListBox.Dock = [System.Windows.Forms.DockStyle]::Fill
    # $prop = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right -bor [System.Windows.Forms.AnchorStyles]::Bottom
    # $objListBox.Anchor = $prop

#        [void] $objListBox.Items.Add("atl-dc-001")
#        [void] $objListBox.Items.Add("atl-dc-002")
#        [void] $objListBox.Items.Add("atl-dc-003")
#        [void] $objListBox.Items.Add("atl-dc-004")
#        [void] $objListBox.Items.Add("atl-dc-005")
#        [void] $objListBox.Items.Add("atl-dc-006")
#        [void] $objListBox.Items.Add("atl-dc-007")

        foreach ($item in $arr) {
            [void] $objListBox.Items.Add($item)
        }

        $objForm.Controls.Add($objListBox) 

        $objForm.Topmost = $True

        # This doesn't work: $objListBox.SelectedIndex(0);
        $objForm.Add_Shown({$objForm.Activate(); $objListBox.focus();  })
        [void] $objForm.ShowDialog()

         $msg = [string]::Format("You selected: {0}", $selection)
#         write-host $msg

        return $selection
}
