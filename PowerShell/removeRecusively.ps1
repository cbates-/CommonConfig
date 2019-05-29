
Function Remove-Dirs {
    param (
            [Parameter(Mandatory=$true)]
            [string] $rootDir = $pwd, 
            [Parameter(Mandatory=$true)]
            [string] $target
          )

    cd $pwd;
    $l = ls -Recurse -Directory $target;
    if ($l -ne $null) {
        foreach ($a in $l) { 
            rmdir -force -Recurse $a.FullName; 
        }
    }

}

