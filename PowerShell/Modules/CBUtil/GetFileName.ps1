

# 
# From:  http://blogs.technet.com/b/heyscriptingguy/archive/2009/09/01/hey-scripting-guy-september-1.aspx

Function Get-FileName {   
    param (
        [parameter(Mandatory=$true)]  [string]   $initDir
    )
     [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") |
     Out-Null

     $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
     $OpenFileDialog.initialDirectory = $initDir
     $OpenFileDialog.filter = "All files (*.*)| *.*"
     $OpenFileDialog.ShowDialog() | Out-Null
     
     $OpenFileDialog.filename

} #end function Get-FileName

# 
# From a comment in the same article as above
#
Function Get-FolderName {  
    param (
        [parameter(Mandatory=$true)]  [string]   $initDir
    )

    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null

    [System.Reflection.Assembly]::LoadWithPartialName("System") | Out-Null

    $OpenFolderDialog = New-Object System.Windows.Forms.FolderBrowserDialog

    $OpenFolderDialog.SelectedPath = $initDir

    # must be true for OpenFileDialog, otherwise it hangs
    # $OpenFolderDialog.ShowHelp = $true;

    # $OpenFolderDialog.ShowDialog() | Out-Null
    $r = $OpenFolderDialog.ShowDialog()
    if($r -eq "Cancel") {
        [string]::Empty
    }
    else {
        $OpenFolderDialog.SelectedPath
    }


} #end function Get-FolderName
