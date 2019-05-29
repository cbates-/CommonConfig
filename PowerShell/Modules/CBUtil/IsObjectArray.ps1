

Function IsObjectArray2 {
    # [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline=$true)] $thing
    )
    $name = $thing.GetType().FullName;

    # return ($name -eq "System.Object[]")
    return ($thing.GetType().IsArray)
}

