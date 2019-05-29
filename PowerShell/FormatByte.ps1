function Format-Byte
{
<#    
    .SYNOPSIS
    Formats a number into the appropriate byte display format.

    .DESCRIPTION
    Uses the powers of 2 to determine what the appropriate byte descriptor
    should be and reduces the number to that appropriate descriptor.
    
    The LongDescriptor switch will switch from the generic "KB, MB, etc."
    to "KiloBytes, MegaBytes, etc."
    
    Returns valid values from byte (2^0) through YottaByte (2^80).
    
    .PARAMETER ByteValue        
    Required double value that represents the number of bytes to convert.
    
    This value must be greater than or equal to zero or the function will error.

    This value can be passed as a positional, named, or pipeline parameter.    
    
    .PARAMETER LongDescriptor
    Optional switch parameter that can be used to specify long names for 
    byte descriptors (KiloBytes, MegaBytes, etc.) as compared to the default
    (KB, MB, etc.) Changes no other functionality.
    
    .PARAMETER Scale
    Optional parameter that specifies how many numbers to display after 
    the decimal place.
    
    The default value for this parameter is 2. 
    
    .EXAMPLE
    Format-Byte 123456789.123
    
    Uses the positional parameter and returns returns "117.74 MB"
    
    .EXAMPLE
    Format-Byte -ByteValue 123456789123 -Scale 0
    
    Uses the named parameter and specifies a Scale of 0 (whole numbers). 
    
    Returns "115 GB"
    
    .EXAMPLE
    Format-Byte -ByteValue 123456789123 -LongDescriptor -Scale 4
    
    Uses the named parameter and specifies a scale of 4 (4 numbers after the
    decimal) 
    
    Returns "114.9781 GigaBytes"
    
    .EXAMPLE
    (Get-ChildItem "E:\KyleScripts")|ForEach-Object{$_.Length}|Format-Byte
    
    Passes an array of the sizes of all the files in the E:\KyleScripts folder
    through the pipeline.
    
    .NOTES
    Author:    Kyle Neier
    Blog: http://sqldbamusings.blogspot.com
    Twitter: Kyle_Neier
    
    Because of the 14 significant digit issue, anything nearing 2^90
    will be marked as WYGTMSB aka WheredYouGetThatMuchStorageBytes. If you
    have that much storage, feel free to find a different function and or
    travel back in time a hundred years years or so and slap me...

#>    
#
# http://sqldbamusings.blogspot.com/2012/04/powershell-using-exponents-and-logs-to.html
#

    [CmdletBinding()]
    
    param(
        [parameter(
                Mandatory=$true, 
                Position=0,
                ValueFromPipeline= $true
                
            )]
             #make certain value won't break script
             [ValidateScript({$_ -ge 0 -and 
                 $_ -le ([Math]::Pow(2, 90))})] 
        [double[]]$ByteValue,
        
        [parameter(
                Mandatory=$false, 
                Position=1,
                ValueFromPipeline= $false
                
            )]
        [switch]$LongDescriptor,
        
        [parameter(
                Mandatory=$false, 
                Position=2,
                ValueFromPipeline= $false
                
            )]
            [ValidateRange(0,10)]
             [int]$Scale = 2
        
    )
    
    #2^10 = KB, 2^20 = MB, 2^30=GB...
    begin
    {
        if($LongDescriptor)
        {
            Write-Verbose "LongDescriptor specified, using longer names."
            $ByteDescriptors = ("Bytes", "KiloBytes", "MegaBytes", "GigaBytes", 
                "TeraBytes", "PetaBytes", "ExaBytes", "ZettaBytes", 
                "YottaBytes", "WheredYouGetThatMuchStorageBytes")
        }
        else
        {
            Write-Verbose "LongDescriptor not specified, using short names."
            $ByteDescriptors = ("B", "KB", "MB", "GB", "TB", "PB", 
                "EB", "ZB", "YB", "WYGTMSB")
        }
    }
    
    process
    {
        foreach($byte in $ByteValue)
        {
            #Determine which power of 2 this value is based from
            Write-Verbose "Determine which power of 2 the byte is based from."
            $PowerOfTwo = [Math]::Floor([Math]::Log($byte)/[Math]::Log(2))
            
            #Determine position in descriptor array for the text value
            Write-Verbose "Determine position in descriptor array."
            $DescriptorID = [Math]::Floor($PowerOfTwo/10)

            #Determine appropriate number by rolling back up through powers of 2
            #format number with appropriate descriptor
            Write-Verbose ("Return the appropriate number with appropriate "+
                "scale and appropriate desciptor back to caller.")
                
            Write-Output ("{0:N$Scale} $($ByteDescriptors[$DescriptorID])" -f (
                $byte / [Math]::Pow(2, ($DescriptorID*10))))
            
        }
    }
}
