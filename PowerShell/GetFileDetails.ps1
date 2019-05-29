
# 
# See also: 
# http://blogs.technet.com/b/heyscriptingguy/archive/2014/02/06/use-powershell-to-find-metadata-from-photograph-files.aspx
#

function Add-FileDetails {
    param(
            [Parameter(ValueFromPipeline=$true)]
            $fileobject,
            $hash = @{Artists = 13; Album = 14; Year = 15; Genre = 16; Title = 21; Length = 27; Bitrate = 28}
         )
        begin { 
            $shell = New-Object -COMObject Shell.Application 
        }
        process {
            if ($_.PSIsContainer -eq $false) {
                $folder = Split-Path $fileobject.FullName
                    $file = Split-Path $fileobject.FullName -Leaf
                    $shellfolder = $shell.Namespace($folder)
                    $shellfile = $shellfolder.ParseName($file)
                    Write-Progress 'Adding Properties' $fileobject.FullName
                    $hash.Keys | 
                    ForEach-Object {
                        $property = $_
                            $value = $shellfolder.GetDetailsOf($shellfile, $hash.$property)
                            if ($value -as [Double]) { $value = [Double]$value }
                            if ($value -as [string]) { $value = [string]$value }
                        $fileobject | Add-Member NoteProperty "Extended_$property" $value -force
                    }
            }
            $fileobject
        }
}

# 
# DOES NOT WORK FOR UNC PATHS
#
function Get-FileDetails {
    param (
        [parameter(mandatory=$true)]
        [string]$fileName
    )
    # From
    # http://powershell.com/cs/blogs/tobias/archive/2011/01/07/organizing-videos-and-music.aspx
    $path = Resolve-Path $fileName
    $shell = New-Object -COMObject Shell.Application
    $folder = Split-Path $path
    $file = Split-Path $path -Leaf
    $shellfolder = $shell.Namespace($folder)
    $shellfile = $shellfolder.ParseName($file)

    # To get the extended file attributes, there is a method called GetDetailsOf() which gets you the name of extended file attributes as well as their values. The attributes you get depend on the file type, so for a video file they may be different than let's say for a word document. This gets you the list of (localized) attribute names for the file you used:

    0..287 | Foreach-Object { $shellfolder.GetDetailsOf($null, $_) } 

    # To get a list of index numbers and their meaning, use this:

    0..287 | Foreach-Object { '{0} = {1}' -f $_, $shellfolder.GetDetailsOf($null, $_) }

    # To get to the actual value of a property, use the index number and replace $null with $shellfile. So to get the Interpret (Artist), it turns out index number 216 is right:

    $shellfolder.GetDetailsOf($shellfile, 216)

    # To find out the right index numbers, it's easier to filter out all empty stuff. This line reads only file attributes that are not empty:

    0..287 | Where-Object { $shellfolder.GetDetailsOf($shellfile, $_) } | 
        Foreach-Object { 
        '{0} = {1} = {2}' -f $_, 
        $shellfolder.GetDetailsOf($null, $_), 
        $shellfolder.GetDetailsOf($shellfile, $_) 
    }
    # Comments : index 24
    $hash = @{ 24 = "Boy Howdy"}
    # $list = Dir c:\myvideos\ -recurse | Add-FileDetails -hash $hash
    # $path | Add-FileDetails -hash $hash
    $fileThing = Get-Item $path
    $fileThing | Add-FileDetails -hash $hash
    $shellfolder.GetDetailsOf($shellfile, 24)
}
 
