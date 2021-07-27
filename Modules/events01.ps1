$aeg = (Get-Date).AddDays(-1)

Get-WinEvent -MaxEvents 10 -FilterHashtable @{
    LogName   = 'Application'
    ID        = 15
    StartTime = $aeg
}
