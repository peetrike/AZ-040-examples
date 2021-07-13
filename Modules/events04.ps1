Param(
    [datetime]$aeg = (Get-Date).AddDays(-1),
        [Parameter(Mandatory=$true)]
    [string]$Computername,
    [int]$EventID = 15,
        [ValidateSet("application","system")]
    [string]$LogName = "application"
)

Write-Host " Tere, mina olen skript"

Get-WinEvent -ComputerName $Computername -MaxEvents 10 -FilterHashtable @{
    LogName = $LogName
    ID = $EventID
    StartTime = $aeg
}
