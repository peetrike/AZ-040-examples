$aeg = (Get-Date).AddDays(-1)
$Computername = "."
$EventID = 15
$LogName = "application"

Get-WinEvent -ComputerName $Computername -MaxEvents 10 -FilterHashtable @{
    LogName = $LogName
    ID = $EventID
    StartTime = $aeg
}
