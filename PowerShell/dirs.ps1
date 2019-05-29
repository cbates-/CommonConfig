#
# From: http://blogs.technet.com/b/heyscriptingguy/archive/2014/06/07/weekend-scripter-cool-powershell-profile-functions-from-bruce-payette.aspx
# remove any existing cd alias...

rm -force alias:/cd 2> $null

$global:DIRLIST = @{}

# a cd function that maintains a list of directories visited. Each path is added only once (bag not stack)

# it also implements the UNIX-like ‘cd –‘ to jump back to the previous directory

# cd ...            # go up 2 levels

# cd ....           # go up three levels

# cd -              # go back to the previous directory

function cd
{

    param ($path='~', [switch] $parent, [string[]] $replace, [switch] $my, [switch] $one);
    if ($index = $path -as [int])
    {
        dirs $index;
        return
    }

    if ($replace)
    {
        $path = $path -replace $replace
    }

    if ($parent)
    {
        $path = Split-Path path
    }

    if ($my)
    {
        if ($path -eq '~') { $path = '' }

        $path = "~/documents/$path"
    }
    elseif ($one)
    {
        if ($path -eq '~') { $path = '' }
        $path = "~/skydrive/documents/$path"
    }

# .'ing shortcuts

    switch ($path)
    {
        '...' { $path = '..\..' }
        '....' { $path = '..\..\..' }
        '-' {
            if (test-path variable:global:oldpath)
            {
# pop back to your old path

                Write-Host "cd'ing back to $global:OLDPATH"

                $temp = Get-Location

                Set-Location $global:OLDPATH

                $global:OLDPATH=$temp
            }
            else
            {
                Write-Warning 'OLDPATH not set'
            }
        }
        default {
            $temp = Get-Location
                Set-Location $path
                if ($?) {
                    $global:OLDPATH = $temp
                    $DIRLIST[(Get-Location).path] = $true
                }
                else
                {
                    Write-Warning 'cd failed!'
                }
        }
    }
}

set-alias cdd cd

#
# lists the directories accumulated by the cd function
# dirs              # list the accumulated directories
# dirs <number>     # cd to the directory entry corresponding to <number>
function dirs
{
    param ($id = -1)
        $dl = $dirlist.keys | sort
        if ($dl)
        {
            if ($id -ge 0)
            {
                cd $dl[$id]
            }
            else
            {
                $count=0;
                foreach ($d in $dl)
                {
                    '{0,3} {1}' -f $count++, $d
                }
            }
        }
}



# A function that cd's relative to ~/documents, with special handling for 'my modules'
# Works with the cd function
# my           # go to ~/documents
# my modules   # cd to ~/documents/windowspowershell/modules
# my foobar    # cd to ~/documents/foobar
function my ($path='', [switch] $resolve=$false)
{
    switch ($path)
    {
        modules {
            $resolvedPath = (rvpa '~/documents/windowspowershell/modules').Path
                if ($resolve) { return $resolvePath }
            cd $resolvedPath
                return
        }
    }
    $resolvedPath = $null
        $resolvedPath =  (rvpa "~/documents/$path").Path
        if (! $resolvedPath ) { return }

    if ($resolve)
    {
        return $resolvedPath
    }
    else
    {
        if ((get-item $resolvedPath).PSIsContainer)
        {
            cd "~/documents/$path"
        }
        else
        {
            return $resolvedPath
        }
    }
}
