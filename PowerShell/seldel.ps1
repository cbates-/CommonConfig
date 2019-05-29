

Param(
    [string]$filter="*" 
)

gci $filter | sort Name | select Name | out-gridview -Title "Select file(s) to delete" -PassThru |% { write-host $_.Name; del $_.Name -ea continue }



