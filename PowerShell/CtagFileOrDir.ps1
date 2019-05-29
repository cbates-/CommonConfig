<#
    .SYNOPSIS
    Function Ctag-FileOrDir
    Use Exuberant CTags with specified files or dir.

    .DESCRIPTION
    Specify a filespec or dir name to run Exuberant Ctags against.  
    Optional: Specify the tags file, whether to append to the tag file, 
    and a value for the CTags tagRelative parameter.

    .PARAMETER fileSpec
    A filename, wild card filespec, or dir name.

    .PARAMETER tagFile
    Optional.
    Default:  $env:LOCALAPPDATA\tags

    .PARAMETER append
    Optional.  Permissible values: "yes" "no"
    Default: yes
    
    .PARAMETER tagRelative
    Optional.  Permissible values: "yes" "no"
    Default: yes

    .EXAMPLE
    Ctag-FileOrDir -fileSpec .\cbProfile.ps1 -tagFile p:\tags

    .NOTES
#>
function Ctag-FileOrDir {
    param (
        [Parameter(Mandatory=$true)]
        [string] $fileSpec,
        [Parameter(Mandatory=$false)]
        [string] $tagFile="$env:LOCALAPPDATA\tags",
        [Parameter(Mandatory=$false)]
        [string] $append="yes",
        [Parameter(Mandatory=$false)]
        [string] $tagRelative="yes"
    )

    # if((Test-Path $fileSpec) -eq $false) {
        # Write-Host "$fileSpec not found" -Foreground Red;
    # }

    ctags.exe --append=$append --verbose -o $tagFile --tag-relative=$tagRelative $fileSpec
    # ctags.exe --append --verbose -o C:\Users\Charles\Documents\WindowsPowerShell\tags --tag-relative=no $fileSpec
    <#
    N. B.: --tag-relative refers to the relationship between the tag file and the source file.
    It appears that the only way to get absolute paths is to run the command from a different drive letter ?!
    #>
}
