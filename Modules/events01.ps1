#region User preference variables
$aeg = (Get-Date).AddDays(-1)
#endregion

Get-WinEvent -MaxEvents 10 -FilterHashtable @{
    LogName   = 'Application'
    ID        = 15
    StartTime = $aeg
}
