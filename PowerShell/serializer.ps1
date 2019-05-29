Filter ConvertTo-JSON {
    Function Return-Value($value) {
        $dataType = $value.GetType().Name
        $jsonProperties = ""

        switch -regex ($dataType) {
            'String'  						{ $jsonProperties += "`"$value`""}
            'Int32|Int64|Double'  { $jsonProperties += $value}
            'Hashtable' 					{
            		$str = "{"
            		
            		$count = $value.Keys.Count
            		$idx = 0
            		
                $value.Keys |% {
                	$v = Return-Value($value.$_)
               		$str += "`"$_`": $v"
               		
               		$idx++
               		if ($idx -lt $count) {
               			$str += ", "
               		} # if
                } # for all keys
                
                $jsonProperties += "$str}"
            }  # HashTable
            'Object\[\]' 	  			{
                $str = "["

                $count = $value.Count
                For($idx=0; $idx -lt $count; $idx++) {
                    $v = $targetObject.($Name)[$idx]
                    $str += Return-Value $v

                    if($idx+1 -lt $count) {
                        $str += ", "
                    } # if
                } # for
                
                $jsonProperties += "$str]"
            } # Object
            
            default {$_}
        }
        
        return $jsonProperties
    } # Return-Value

    $targetObject = $_
    $jsonProperties = @()
    $properties = $_ | Get-Member -MemberType *property

    ForEach ($property in $properties) {
				$name = $property.name
        $value = $targetObject.($property.Name)
        $jsonProperties += "`t`"$($name)`": " + (Return-Value $value)
    }

    "{`r`n $($jsonProperties -join ",`r`n") `r`n}"
}

# Simple test for the convert
(new-object PSObject |
    add-member -pass noteproperty Name 'John Doe' |
    add-member -pass noteproperty Age 10          |
    add-member -pass noteproperty Amount 10.1     |
    add-member -pass noteproperty MixedItems (1,2,3,"a") |
    add-member -pass noteproperty NumericItems (1,2,3) |
    add-member -pass noteproperty StringItems ("a","b","c", @{"a"="d"})  |
  	add-member -pass noteproperty HashItems @{"a"="b"; "c"="d"}
) | ConvertTo-JSON
