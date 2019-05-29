########################################################## 
#Script        :    Graphical User Interface using PowerShell 
#Resource    :    ShowUI (http://showui.codeplex.com/) 
#Developer    :    Chendrayan Venkatesan 
#Compacy    :    Tata Consultancy Services 
########################################################## 
 
#Import Show UI Module 
Import-Module ShowUI -ErrorAction SilentlyContinue 
 
#Create a Stack Panel to add required Controls 
New-StackPanel -ControlName 'Windows Management' -Width 700 -Height 400 { 
 
#Input Text Box (Machine Name) 
New-Label "Enter Server Name:" -FontWeight Bold -Row 1 -Column 1 
New-TextBox -Name MachineName 
 
#Output Text Box (Computer Name) 
New-Label "Name" -FontWeight Bold -Row 2 -Column 2 
New-TextBox -Name ComputerName 
 
#Serial Number 
New-Label "Serial Number" -FontWeight Bold 
New-TextBox -Name SerialNumber  
 
#Operating System 
New-Label "Operating System" -FontWeight Bold 
New-TextBox -Name OperatingSystem 
 
#Service Pack 
New-Label "Service Pack" -FontWeight Bold 
New-TextBox -Name ServicePack 
 
New-Button Click -On_Click { 
 
$CN = Get-WmiObject -Class Win32_BIOS -ComputerName $MachineName.Text 
$Comp = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $MachineName.Text 
$ComputerName.Text = $CN.PSComputerName 
$SerialNumber.Text = $CN.SerialNumber 
$OperatingSystem.Text = $Comp.Caption 
$ServicePack.Text = $Comp.CSDVersion 
} 
} -Show
