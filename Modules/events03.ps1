param (
    $aeg = [datetime]::Now.AddDays(-1),
    $ComputerName
)

#region User preference variables
$EventID = 15
$LogName = 'Application'
#endregion

$EventParams = @{
    MaxEvents       = 10
    FilterHashtable = @{
        LogName   = $LogName
        ID        = $EventID
        StartTime = $aeg
    }
}
if ($ComputerName) {
    $EventParams.ComputerName = $ComputerName
}

Get-WinEvent @EventParams
