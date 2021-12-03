#region User preference variables
$aeg = [datetime]::Now.AddDays(-1)
$ComputerName = ''
$EventID = 15
$LogName = 'Application'
#endregion

$EventParams = @{
    MaxEvents       = 1
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
