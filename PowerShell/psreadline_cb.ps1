

$fullPathIncFileName = $MyInvocation.MyCommand.Definition
Write-Host "**** Reading $fullPathIncFileName ****" -Foreground Cyan

# From : SamplePSReadlineProfile.ps1
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

# The next four key handlers are designed to make entering matched quotes
# parens, and braces a nicer experience.  I'd like to include functions
# in the module that do this, but this implementation still isn't as smart
# as ReSharper, so I'm just providing it as a sample.

# 20150305 -- this is proving to be annoying...
#
<#
Set-PSReadlineKeyHandler -Key '"',"'" `
                         -BriefDescription SmartInsertQuote `
                         -LongDescription "Insert paired quotes if not already on a quote" `
                         -ScriptBlock {
    param($key, $arg)

    $line = $null
    $cursor = $null
    [PSConsoleUtilities.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    if ($line[$cursor] -eq $key.KeyChar) {
        # Just move the cursor
        [PSConsoleUtilities.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
    }
    else {
        # Insert matching quotes, move cursor to be in between the quotes
        [PSConsoleUtilities.PSConsoleReadLine]::Insert("$($key.KeyChar)" * 2)
        [PSConsoleUtilities.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
        [PSConsoleUtilities.PSConsoleReadLine]::SetCursorPosition($cursor - 1)
    }
}
#>

# Set-PSReadlineKeyHandler -Key '{' `
                         # -BriefDescription InsertPairedBraces `
                         # -LongDescription "Insert matching braces" `
                         # -ScriptBlock {
    # param($key, $arg)

    # $closeChar = switch ($key.KeyChar)
    # {
        # <#case#> '{' { [char]'}'; break }
        # <#case#> '[' { [char]']'; break }
    # }

    # [PSConsoleUtilities.PSConsoleReadLine]::Insert("$($key.KeyChar)$closeChar")
    # $line = $null
    # $cursor = $null
    # [PSConsoleUtilities.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    # [PSConsoleUtilities.PSConsoleReadLine]::SetCursorPosition($cursor - 1)
# }

# Set-PSReadlineKeyHandler -Key '}' `
                         # -BriefDescription SmartCloseBraces `
                         # -LongDescription "Insert closing brace or skip" `
                         # -ScriptBlock {
    # param($key, $arg)

    # $line = $null
    # $cursor = $null
    # [PSConsoleUtilities.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    # if ($line[$cursor] -eq $key.KeyChar)
    # {
        # [PSConsoleUtilities.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
    # }
    # else
    # {
        # [PSConsoleUtilities.PSConsoleReadLine]::Insert("$($key.KeyChar)")
    # }
# }


#
# Sometimes you enter a command but realize you forgot to do something else first.
# This binding will let you save that command in the history so you can recall it,
# but it doesn't actually execute.
# CB: This saves it in PSReadline's history, apparently.  Up arrow will find it, but not get-history.
# It also clears the line with RevertLine so the
# undo stack is reset - though redo will still reconstruct the command line.
Set-PSReadlineKeyHandler -Key Alt+w `
                         -BriefDescription SaveInHistory `
                         -LongDescription "Save current line in history but do not execute" `
                         -ScriptBlock {
    param($key, $arg)

    $line = $null
    $cursor = $null
    [PSConsoleUtilities.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    [PSConsoleUtilities.PSConsoleReadLine]::AddToHistory($line)
    [PSConsoleUtilities.PSConsoleReadLine]::RevertLine()
}

# Insert text from the clipboard as a here string
Set-PSReadlineKeyHandler -Key Ctrl+Shift+v `
                         -BriefDescription PasteAsHereString `
                         -LongDescription "Paste the clipboard text as a here string" `
                         -ScriptBlock {
    param($key, $arg)

    Add-Type -Assembly PresentationCore
    if ([System.Windows.Clipboard]::ContainsText())
    {
        # Get clipboard text - remove trailing spaces, convert \r\n to \n, and remove the final \n.
        $text = ([System.Windows.Clipboard]::GetText() -replace "\p{Zs}*`r?`n","`n").TrimEnd()
        [PSConsoleUtilities.PSConsoleReadLine]::Insert("@'`n$text`n'@")
    }
    else
    {
        [PSConsoleUtilities.PSConsoleReadLine]::Ding()
    }
}

Set-PSReadlineKeyHandler -Key F1 `
                         -BriefDescription CommandHelp `
                         -LongDescription "Open the help window for the current command" `
                         -ScriptBlock {
    param($key, $arg)

    $ast = $null
    $tokens = $null
    $errors = $null
    $cursor = $null
    [PSConsoleUtilities.PSConsoleReadLine]::GetBufferState([ref]$ast, [ref]$tokens, [ref]$errors, [ref]$cursor)

    $commandAst = $ast.FindAll( {
        $node = $args[0]
        $node -is [System.Management.Automation.Language.CommandAst] -and
            $node.Extent.StartOffset -le $cursor -and
            $node.Extent.EndOffset -ge $cursor
        }, $true) | Select-Object -Last 1

    if ($commandAst -ne $null)
    {
        $commandName = $commandAst.GetCommandName()
        if ($commandName -ne $null)
        {
            $command = $ExecutionContext.InvokeCommand.GetCommand($commandName, 'All')
            if ($command -is [System.Management.Automation.AliasInfo])
            {
                $commandName = $command.ResolvedCommandName
            }

            if ($commandName -ne $null)
            {
                Get-Help $commandName -ShowWindow
            }
        }
    }
}
