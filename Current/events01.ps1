$aeg = (Get-Date).AddDays(-1)

Get-WinEvent -MaxEvents 10 -FilterHashtable @{
    LogName = "application"
    ID = 15
    StartTime = $aeg
}
