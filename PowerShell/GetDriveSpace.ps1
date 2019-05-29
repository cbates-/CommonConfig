
function DriveSpace {
    param( [string] $strComputer="localhost") 
        "$strComputer ---- `tFree Space `t`t(percentage) ----"

        # Does the server responds to a ping (otherwise the WMI queries will fail)

        $query = "select * from win32_pingstatus where address = '$strComputer'"
        $result = Get-WmiObject -query $query
        if ($result.protocoladdress) {

            # Get the Disks for this computer
            $colDisks = get-wmiobject Win32_LogicalDisk -computername $strComputer -Filter "DriveType = 3";

            # For each disk calculate the free space
            foreach ($disk in $colDisks) {
                if ($disk.size -gt 0) {$PercentFree = [Math]::round((($disk.freespace/$disk.size) * 100))}
                else {$PercentFree = 0}

                # $free = string::Format("{0}", $disk.freespace)
                $free = ($disk.freespace).ToString("N");
                $Drive = $disk.DeviceID ;
                # $s = [string]::Format("{0}  {1}  Disk Size: {2}", $strComputer, $Drive, $disk.size)
                # write-host $s
                "$Drive `t`t$free  `t$PercentFree `% ";

                # if  < 20% free space, log to a file
                if ($PercentFree -le 20) {"$strComputer - $Drive - $PercentFree" | out-file -append -filepath "C:\temp\Drive-Space.txt"}
            }
        }
}
