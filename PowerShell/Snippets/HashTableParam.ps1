
$myMap = @{
   Name = "Snappy"
   Foo = 15
   Bar = "Kick"
   Baz = 1GB
   MB = 1MB
}

function giggle {
    param (
        $name,
        $foo
    )
    # $thing
    # assume thing is a hash table
    # $thing.GetEnumerator() | % { $_.Value }
    $name
    $foo
}

function gopher {
    param (
        [hashtable] $thing
    )
    # $thing
    # assume thing is a hash table
    $thing.GetEnumerator() | % {
        $k = $_.Key
        $v = $_.Value
        "$k : $v" }
 }

giggle @myMap

gopher $myMap

