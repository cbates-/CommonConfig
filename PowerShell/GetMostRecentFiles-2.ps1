
# From: http://stackoverflow.com/a/20332039

Param (
    [int]$numItems = 5
)
$l = Get-ChildItem -Recurse | where {$_.PsIsContainer -ne $true } | sort LastWriteTime | select -last $numItems

$MIFProblem_ht = @{}
$LastCreate_ht = @{}

$l |
 foreach {
   $MIFProblem_ht[$_.PsParentPath]++
   if ($_.LastWriteTime -gt $LastCreate_ht[$_.PsParentPath])
     {$LastCreate_ht[$_.PsParentPath] = $_.LastWriteTime}
   }

$MIFProblem_ht.keys |
 foreach { [PSCustomObject]@{
   PsParentPath = $_
   MifProblems = $MIFProblem_ht[$_]
   LastLastWriteTime = $LastCreate_ht[$_]
  }
}