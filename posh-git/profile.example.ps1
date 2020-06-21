Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

# Load posh-git module from current directory
Import-Module .\posh-git

# If module is installed in a default location ($env:PSModulePath),
# use this instead (see about_Modules for more information):
# Import-Module posh-git

# CB Mod
if($env:PromptLength -eq $null) {
	$env:PromptLength = 64;
}
# end mod

# Set up a simple prompt, adding the git prompt parts inside git repos
function global:prompt {
    $realLASTEXITCODE = $LASTEXITCODE

    # CB mod
    $path = ShortenPath -Len $env:PromptLength

    # Write-Host($pwd.ProviderPath) -nonewline
    Write-Host($path) -nonewline
    # end mod

    Write-VcsStatus

    $global:LASTEXITCODE = $realLASTEXITCODE
    return "> "
}

Pop-Location

# Start-SshAgent -Quiet
