param (
        [datetime]
    $aeg = [datetime]::Now.AddDays(-1),
        [Alias('CN')]
        [string]
    $ComputerName
)

$EventID = 15
$LogName = 'Application'

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
