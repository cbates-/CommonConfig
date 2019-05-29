
# 
# From http://blogs.technet.com/b/heyscriptingguy/archive/2014/07/17/using-the-split-method-in-powershell.aspx
#
$string = $string = "This string is cool. Very cool. It also rocks. Very cool. I mean dude.Very cool. Very cool."

# array of strings as separators
$separator = "Very cool.","."

# Now, I need to create my StringSplitOption. 
# There are two options: None and RemoveEmptyEntries. 
# The first time I run the command, I will remove the empty entries. 
# So here is that command:

$option = [System.StringSplitOptions]::RemoveEmptyEntries

$string.Split($separator, $option)


