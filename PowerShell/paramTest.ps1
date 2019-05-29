
#
#   Elementary program to test use of named params and defaults
#
#   Order doesn't matter, and specify (by name) 0 - 3 params.
#
param(
    ## The project or solution to build
    [string] $One = "One",
    [string] $Two = "Two",
    [string] $Three = "Three"
)

Write-Host '$One : ' $One
Write-Host '$Two : ' $Two
Write-Host '$Three : ' $Three
