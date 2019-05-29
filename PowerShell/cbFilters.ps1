

#
# ----------------- New Types ---------------------
#
# From:  http://stackoverflow.com/a/10928171/107037
add-type -Language CSharpVersion3 @'
    public class Helpers {
        public static bool IsNumeric(object o) {
            return o is byte  || o is short  || o is int  || o is long
                || o is sbyte || o is ushort || o is uint || o is ulong
                || o is float || o is double || o is decimal
                ;
        }
        public static bool IsString(object o) {
            return o is string
                ;
        }
        public static bool IsBoolean(object o) {
            return o is bool
                ;
        }
    }
'@

#
# ----------------- New Filters ---------------------
#
Filter Get-TypeName {if ($_ -eq $null) {'<null>'} else {$_.GetType().Fullname }}

Filter IsNumeric {
    [Helpers]::IsNumeric($_)
}

Filter IsBoolean {
    [Helpers]::IsBoolean($_)
}

Filter IsString {
    [Helpers]::IsString($_)
}

Function IsObjectArray {
    # [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline=$true)] $thing
    )
    # $name = $thing.GetType().FullName;
    # return ($name -eq "System.Object[]")
    return ($thing.GetType().IsArray)
    <#
    .EXAMPLE
    $ds = gci -Directory
    (,$ds) | IsObjectArray

    .EXAMPLE
    $ds = gci -Directory
    IsObjectArray $ds

    .NOTES
    When passing an object via the pipeline, make sure to use array syntax:
    (,$var) | IsObjectArray

    #>
}


#
# ----------------- Misc. ---------------------
#
function CheckLastExitCode { 
    param ([int[]]$SuccessCodes = @(0), [scriptblock]$CleanupScript=$null)
    if ($SuccessCodes -notcontains $LastExitCode) {
        if ($CleanupScript) {
            "Executing cleanup script: $CleanupScript" 
            &$CleanupScript 
        } 
        $msg = @" 
        EXE RETURNED EXIT CODE $LastExitCode
        CALLSTACK:$(Get-PSCallStack | Out-String)
"@ 
        throw $msg 
    } 
}
