

$stack = gl -stack;

$d = $stack | out-gridview -Title "Select dir to go to" -passthru;

cdd $d


